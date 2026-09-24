import Foundation
import Darwin

private struct RouterConfig: Decodable {
    let version: Int
    let enabled: Bool
    let destinationPath: String?
}

private struct FileSignature: Equatable {
    let size: UInt64
    let modified: TimeInterval
}

private struct Candidate {
    let firstSeen: Date
    var signature: FileSignature?
    var stableChecks: Int
}

private final class Logger {
    private let path: String
    private let formatter = ISO8601DateFormatter()

    init(path: String) { self.path = path }

    func write(_ message: String) {
        let line = "\(formatter.string(from: Date())) \(message)\n"
        guard let data = line.data(using: .utf8) else { return }
        let directory = URL(fileURLWithPath: path).deletingLastPathComponent()
        try? FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
        if !FileManager.default.fileExists(atPath: path) {
            FileManager.default.createFile(atPath: path, contents: nil)
        }
        guard let handle = try? FileHandle(forWritingTo: URL(fileURLWithPath: path)) else { return }
        defer { try? handle.close() }
        do {
            try handle.seekToEnd()
            try handle.write(contentsOf: data)
        } catch { }
    }
}

private struct RuntimePaths {
    let downloads: URL
    let config: URL
    let log: URL

    static func current() -> RuntimePaths {
        let environment = ProcessInfo.processInfo.environment
        let home = FileManager.default.homeDirectoryForCurrentUser
        let support = home.appendingPathComponent("Library/Application Support/AirDrop Router", isDirectory: true)
        return RuntimePaths(
            downloads: URL(fileURLWithPath: environment["AIRDROP_ROUTER_DOWNLOADS_PATH"] ?? home.appendingPathComponent("Downloads").path),
            config: URL(fileURLWithPath: environment["AIRDROP_ROUTER_CONFIG_PATH"] ?? support.appendingPathComponent("config.json").path),
            log: URL(fileURLWithPath: environment["AIRDROP_ROUTER_LOG_PATH"] ?? support.appendingPathComponent("router.log").path)
        )
    }
}

private func readConfig(at url: URL) throws -> RouterConfig {
    let data = try Data(contentsOf: url)
    return try JSONDecoder().decode(RouterConfig.self, from: data)
}

private func fileSignature(at url: URL) -> FileSignature? {
    guard let values = try? url.resourceValues(forKeys: [.fileSizeKey, .contentModificationDateKey]) else { return nil }
    return FileSignature(size: UInt64(values.fileSize ?? 0), modified: values.contentModificationDate?.timeIntervalSince1970 ?? 0)
}

private func extendedAttribute(_ name: String, at url: URL) -> Data? {
    let length = url.path.withCString { pathPointer in
        name.withCString { namePointer in
            getxattr(pathPointer, namePointer, nil, 0, 0, 0)
        }
    }
    guard length > 0 else { return nil }
    var data = Data(count: length)
    let result = data.withUnsafeMutableBytes { buffer in
        url.path.withCString { pathPointer in
            name.withCString { namePointer in
                getxattr(pathPointer, namePointer, buffer.baseAddress, length, 0, 0)
            }
        }
    }
    return result == length ? data : nil
}

private func objectContainsAirDropMarker(_ object: Any) -> Bool {
    if let string = object as? String {
        let value = string.lowercased()
        return value.contains("sharingd") || value.contains("airdrop")
    }
    if let values = object as? [Any] { return values.contains(where: objectContainsAirDropMarker) }
    if let values = object as? [String: Any] { return values.values.contains(where: objectContainsAirDropMarker) }
    return false
}

private func dataContainsAirDropMarker(_ data: Data) -> Bool {
    let text = String(decoding: data, as: UTF8.self).lowercased()
    if text.contains("sharingd") || text.contains("airdrop") { return true }
    guard let propertyList = try? PropertyListSerialization.propertyList(from: data, options: [], format: nil) else { return false }
    return objectContainsAirDropMarker(propertyList)
}

private func isAirDropItem(_ url: URL) -> Bool {
    let attributeNames = ["com.apple.quarantine", "com.apple.metadata:kMDItemWhereFroms"]
    return attributeNames.contains { name in
        extendedAttribute(name, at: url).map(dataContainsAirDropMarker) ?? false
    }
}

private func uniqueDestination(for source: URL, in directory: URL) -> URL {
    let manager = FileManager.default
    let initial = directory.appendingPathComponent(source.lastPathComponent)
    if !manager.fileExists(atPath: initial.path) { return initial }

    let extensionName = source.pathExtension
    let baseName = extensionName.isEmpty ? source.lastPathComponent : String(source.lastPathComponent.dropLast(extensionName.count + 1))
    var counter = 2
    while true {
        let candidateName = extensionName.isEmpty ? "\(baseName) \(counter)" : "\(baseName) \(counter).\(extensionName)"
        let candidate = directory.appendingPathComponent(candidateName)
        if !manager.fileExists(atPath: candidate.path) { return candidate }
        counter += 1
    }
}

private func notifyFailure(title: String, message: String) {
    if ProcessInfo.processInfo.environment["AIRDROP_ROUTER_DISABLE_NOTIFICATIONS"] == "1" { return }
    func escaped(_ value: String) -> String {
        value.replacingOccurrences(of: "\\", with: "\\\\").replacingOccurrences(of: "\"", with: "\\\"")
    }
    let script = "display notification \"\(escaped(message))\" with title \"\(escaped(title))\""
    let process = Process()
    process.executableURL = URL(fileURLWithPath: "/usr/bin/osascript")
    process.arguments = ["-e", script]
    try? process.run()
}

@discardableResult
private func route(_ source: URL, using config: RouterConfig, logger: Logger, force: Bool = false) -> Bool {
    let manager = FileManager.default
    guard config.enabled, let path = config.destinationPath else {
        logger.write("Skipped \(source.lastPathComponent): routing disabled")
        return false
    }
    let destinationDirectory = URL(fileURLWithPath: path, isDirectory: true)
    var isDirectory: ObjCBool = false
    guard manager.fileExists(atPath: destinationDirectory.path, isDirectory: &isDirectory), isDirectory.boolValue else {
        logger.write("Destination unavailable: \(path)")
        notifyFailure(title: "AirDrop Router", message: "Destination unavailable; the transfer remains in Downloads.")
        return false
    }
    guard destinationDirectory.standardizedFileURL != source.deletingLastPathComponent().standardizedFileURL else {
        logger.write("Skipped: destination is Downloads")
        return false
    }
    guard force || isAirDropItem(source) else {
        logger.write("Ignored non-AirDrop item: \(source.lastPathComponent)")
        return false
    }
    let destination = uniqueDestination(for: source, in: destinationDirectory)
    do {
        try manager.moveItem(at: source, to: destination)
        logger.write("Routed \(source.lastPathComponent) to \(destination.path)")
        return true
    } catch {
        logger.write("Move failed for \(source.lastPathComponent): \(error.localizedDescription)")
        notifyFailure(title: "AirDrop Router", message: "Could not move \(source.lastPathComponent); it remains in Downloads.")
        return false
    }
}

private final class DownloadsWatcher {
    private let paths: RuntimePaths
    private let logger: Logger
    private var knownPaths = Set<String>()
    private var candidates: [String: Candidate] = [:]
    private var source: DispatchSourceFileSystemObject?
    private var timer: DispatchSourceTimer?
    private var descriptor: Int32 = -1

    init(paths: RuntimePaths) {
        self.paths = paths
        self.logger = Logger(path: paths.log.path)
    }

    func run() throws {
        knownPaths = Set(contents().map(\.path))
        descriptor = open(paths.downloads.path, O_EVTONLY)
        guard descriptor >= 0 else { throw NSError(domain: NSPOSIXErrorDomain, code: Int(errno)) }

        let queue = DispatchQueue(label: "com.arilebedey.airdrop-router")
        let source = DispatchSource.makeFileSystemObjectSource(
            fileDescriptor: descriptor,
            eventMask: [.write, .extend, .attrib, .rename],
            queue: queue
        )
        source.setEventHandler { self.scanForNewItems() }
        source.setCancelHandler { [descriptor] in close(descriptor) }
        self.source = source

        let timer = DispatchSource.makeTimerSource(queue: queue)
        timer.schedule(deadline: .now() + 1, repeating: 1)
        timer.setEventHandler { self.evaluateCandidates() }
        self.timer = timer

        logger.write("Worker started; watching \(paths.downloads.path)")
        source.resume()
        timer.resume()
        dispatchMain()
    }

    private func contents() -> [URL] {
        let keys: [URLResourceKey] = [.isRegularFileKey, .isDirectoryKey]
        return (try? FileManager.default.contentsOfDirectory(at: paths.downloads, includingPropertiesForKeys: keys, options: [.skipsHiddenFiles])) ?? []
    }

    private func scanForNewItems() {
        let current = Set(contents().map(\.path))
        let newPaths = current.subtracting(knownPaths)
        for path in newPaths {
            candidates[path] = Candidate(firstSeen: Date(), signature: nil, stableChecks: 0)
            logger.write("Observed new Downloads item: \(URL(fileURLWithPath: path).lastPathComponent)")
        }
        knownPaths = current
    }

    private func evaluateCandidates() {
        for path in Array(candidates.keys) {
            let url = URL(fileURLWithPath: path)
            guard FileManager.default.fileExists(atPath: path), var candidate = candidates[path] else {
                candidates.removeValue(forKey: path)
                continue
            }
            guard let signature = fileSignature(at: url) else { continue }
            if candidate.signature == signature {
                candidate.stableChecks += 1
            } else {
                candidate.signature = signature
                candidate.stableChecks = 0
            }
            candidates[path] = candidate

            if candidate.stableChecks >= 4, isAirDropItem(url) {
                do {
                    let config = try readConfig(at: paths.config)
                    _ = route(url, using: config, logger: logger)
                } catch {
                    logger.write("Could not read config: \(error.localizedDescription)")
                }
                candidates.removeValue(forKey: path)
                knownPaths.remove(path)
            } else if Date().timeIntervalSince(candidate.firstSeen) > 30, candidate.stableChecks >= 4 {
                logger.write("Ignored item without AirDrop metadata: \(url.lastPathComponent)")
                candidates.removeValue(forKey: path)
            }
        }
    }
}

private func diagnose(_ url: URL) {
    print("Path: \(url.path)")
    print("AirDrop marker: \(isAirDropItem(url) ? "yes" : "no")")
    for name in ["com.apple.quarantine", "com.apple.metadata:kMDItemWhereFroms"] {
        if let data = extendedAttribute(name, at: url) {
            print("\(name): \(String(decoding: data, as: UTF8.self))")
        } else {
            print("\(name): not present")
        }
    }
}

private func selfTest() throws {
    let manager = FileManager.default
    let root = manager.temporaryDirectory.appendingPathComponent("airdrop-router-self-test-\(UUID().uuidString)")
    defer { try? manager.removeItem(at: root) }
    let destination = root.appendingPathComponent("destination")
    try manager.createDirectory(at: destination, withIntermediateDirectories: true)
    let source = root.appendingPathComponent("clip.mov")
    try Data("new".utf8).write(to: source)
    try Data("existing".utf8).write(to: destination.appendingPathComponent("clip.mov"))
    let unique = uniqueDestination(for: source, in: destination)
    guard unique.lastPathComponent == "clip 2.mov" else { throw NSError(domain: "SelfTest", code: 1) }
    let logger = Logger(path: root.appendingPathComponent("test.log").path)
    let config = RouterConfig(version: 1, enabled: true, destinationPath: destination.path)
    guard route(source, using: config, logger: logger, force: true) else { throw NSError(domain: "SelfTest", code: 2) }
    guard manager.fileExists(atPath: destination.appendingPathComponent("clip 2.mov").path) else { throw NSError(domain: "SelfTest", code: 3) }
    print("AirDrop Router worker self-test passed")
}

private let arguments = Array(CommandLine.arguments.dropFirst())
private let paths = RuntimePaths.current()
private let logger = Logger(path: paths.log.path)

do {
    if arguments.first == "--diagnose", arguments.count == 2 {
        diagnose(URL(fileURLWithPath: arguments[1]))
    } else if arguments.first == "--route-test", arguments.count == 2 {
        let config = try readConfig(at: paths.config)
        guard route(URL(fileURLWithPath: arguments[1]), using: config, logger: logger, force: true) else { exit(1) }
    } else if arguments.first == "--self-test" {
        try selfTest()
    } else if arguments.isEmpty || arguments.first == "--watch" {
        try DownloadsWatcher(paths: paths).run()
    } else {
        fputs("Usage: airdrop-router-worker [--watch | --diagnose PATH | --route-test PATH | --self-test]\n", stderr)
        exit(64)
    }
} catch {
    logger.write("Fatal error: \(error.localizedDescription)")
    fputs("AirDrop Router: \(error.localizedDescription)\n", stderr)
    exit(1)
}
