// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "AirDropRouterWorker",
    platforms: [.macOS(.v13)],
    products: [.executable(name: "airdrop-router-worker", targets: ["AirDropRouterWorker"])],
    targets: [.executableTarget(name: "AirDropRouterWorker")]
)
