import { Action, ActionPanel, closeMainWindow, Icon, List, showToast, Toast } from "@raycast/api";
import { execFile } from "child_process";
import { promises as fs } from "fs";
import { homedir } from "os";
import path from "path";
import { promisify } from "util";
import { useEffect, useMemo, useState } from "react";
import { compactPath, readConfig, setDestination } from "./config";

const execFileAsync = promisify(execFile);
const home = homedir();
const packageSuffixes = [".app", ".bundle", ".framework", ".photoslibrary", ".photolibrary"];

interface Folder {
  path: string;
  title: string;
}

interface FolderPickerProps {
  onSelected?: (folder: string) => void;
}

async function isDirectory(filePath: string): Promise<boolean> {
  try {
    return (await fs.stat(filePath)).isDirectory();
  } catch {
    return false;
  }
}

function isVisibleFolderName(name: string): boolean {
  const lower = name.toLowerCase();
  return !name.startsWith(".") && !packageSuffixes.some((suffix) => lower.endsWith(suffix));
}

async function childFolders(parent: string): Promise<Folder[]> {
  try {
    const entries = await fs.readdir(parent, { withFileTypes: true });
    const folders = await Promise.all(
      entries
        .filter((entry) => isVisibleFolderName(entry.name))
        .map(async (entry) => {
          const childPath = path.join(parent, entry.name);
          return entry.isDirectory() || (entry.isSymbolicLink() && (await isDirectory(childPath)))
            ? { path: childPath, title: entry.name }
            : undefined;
        }),
    );
    return folders
      .filter((folder): folder is Folder => folder !== undefined)
      .sort((a, b) => a.title.localeCompare(b.title));
  } catch {
    return [];
  }
}

async function mountedVolumes(): Promise<Folder[]> {
  const volumes = await childFolders("/Volumes");
  const result: Folder[] = [];
  for (const volume of volumes) {
    try {
      if ((await fs.realpath(volume.path)) !== "/") result.push(volume);
    } catch {
      // Ignore volumes that disappear while the list is loading.
    }
  }
  return result;
}

function spotlightLiteral(value: string): string {
  return value.replace(/[\\"]/g, "\\$&").replace(/\*/g, "");
}

async function spotlightSearch(root: string, query: string): Promise<Folder[]> {
  const literal = spotlightLiteral(query.trim());
  if (!literal) return [];
  const predicate =
    `kMDItemContentType == "public.folder" && ` +
    `(kMDItemFSName == "*${literal}*"cd || kMDItemPath == "*${literal}*"cd)`;
  try {
    const { stdout } = await execFileAsync("/usr/bin/mdfind", ["-onlyin", root, predicate], {
      timeout: 5000,
      maxBuffer: 4 * 1024 * 1024,
    });
    return stdout
      .split("\n")
      .filter(Boolean)
      .filter((item) => root !== home || !item.startsWith(`${home}/Library/`))
      .filter((item) => item.split(path.sep).every((part) => !part.startsWith(".")))
      .filter((item) => !packageSuffixes.some((suffix) => item.toLowerCase().includes(`${suffix}/`)))
      .slice(0, 150)
      .map((item) => ({ path: item, title: path.basename(item) }));
  } catch {
    return [];
  }
}

function findPattern(value: string): string {
  const escaped = value.replaceAll("\\", "\\\\").replaceAll("*", "\\*").replaceAll("?", "\\?").replaceAll("[", "\\[");
  return `*${escaped}*`;
}

async function filesystemSearch(root: string, query: string): Promise<Folder[]> {
  const excludedNames = [".*", "node_modules", "*.app", "*.bundle", "*.framework", "*.photoslibrary", "*.photolibrary"];
  if (root === home) excludedNames.push("Library");
  const argumentsList = [root, "-xdev", "("];
  excludedNames.forEach((name, index) => {
    if (index > 0) argumentsList.push("-o");
    argumentsList.push("-name", name);
  });
  argumentsList.push(")", "-prune", "-o", "-type", "d", "-iname", findPattern(query.trim()), "-print");

  try {
    const { stdout } = await execFileAsync("/usr/bin/find", argumentsList, {
      timeout: 6000,
      maxBuffer: 4 * 1024 * 1024,
    });
    return stdout
      .split("\n")
      .filter(Boolean)
      .slice(0, 150)
      .map((item) => ({ path: item, title: path.basename(item) }));
  } catch (error) {
    const stdout = (error as { stdout?: string }).stdout ?? "";
    return stdout
      .split("\n")
      .filter(Boolean)
      .slice(0, 150)
      .map((item) => ({ path: item, title: path.basename(item) }));
  }
}

async function searchRoot(root: string, query: string): Promise<Folder[]> {
  const spotlightResults = await spotlightSearch(root, query);
  return spotlightResults.length > 0 ? spotlightResults : filesystemSearch(root, query);
}

async function searchFolders(query: string, volumes: Folder[]): Promise<Folder[]> {
  const roots = [home, ...volumes.map((volume) => volume.path)];
  const batches = await Promise.all(roots.map((root) => searchRoot(root, query)));
  const unique = new Map<string, Folder>();
  for (const folder of batches.flat()) unique.set(folder.path, folder);
  const normalized = query.toLocaleLowerCase();
  return [...unique.values()]
    .sort((a, b) => {
      const aStarts = a.title.toLocaleLowerCase().startsWith(normalized) ? 0 : 1;
      const bStarts = b.title.toLocaleLowerCase().startsWith(normalized) ? 0 : 1;
      return aStarts - bStarts || a.title.localeCompare(b.title) || a.path.localeCompare(b.path);
    })
    .slice(0, 200);
}

function FolderActions({ folder, onSelected }: { folder: Folder; onSelected?: (folder: string) => void }) {
  async function selectFolder() {
    try {
      await setDestination(folder.path);
      await showToast({
        style: Toast.Style.Success,
        title: "AirDrop folder updated",
        message: compactPath(folder.path),
      });
      onSelected?.(folder.path);
      await closeMainWindow({ clearRootSearch: true });
    } catch (error) {
      await showToast({ style: Toast.Style.Failure, title: "Could not set AirDrop folder", message: String(error) });
    }
  }

  return (
    <ActionPanel>
      <Action title="Use as AirDrop Folder" icon={Icon.CheckCircle} onAction={selectFolder} />
      <Action.Push
        title="Browse Folder"
        icon={Icon.ArrowRight}
        shortcut={{ modifiers: ["cmd"], key: "arrowRight" }}
        target={<DirectoryBrowser root={folder.path} onSelected={onSelected} />}
      />
      <Action.Open title="Open in Finder" target={folder.path} />
      <Action.CopyToClipboard title="Copy Path" content={folder.path} />
    </ActionPanel>
  );
}

function FolderItem({ folder, onSelected }: { folder: Folder; onSelected?: (folder: string) => void }) {
  return (
    <List.Item
      key={folder.path}
      title={folder.title}
      subtitle={compactPath(path.dirname(folder.path))}
      icon={{ fileIcon: folder.path }}
      accessories={[{ text: compactPath(folder.path) }]}
      actions={<FolderActions folder={folder} onSelected={onSelected} />}
    />
  );
}

function DirectoryBrowser({ root, onSelected }: { root: string; onSelected?: (folder: string) => void }) {
  const [folders, setFolders] = useState<Folder[]>([]);
  const [loading, setLoading] = useState(true);
  useEffect(() => {
    childFolders(root)
      .then(setFolders)
      .finally(() => setLoading(false));
  }, [root]);
  const rootFolder = { path: root, title: path.basename(root) || root };
  return (
    <List
      isLoading={loading}
      navigationTitle={`Choose AirDrop Folder — ${compactPath(root)}`}
      searchBarPlaceholder="Filter folders…"
    >
      <List.Section title="Current Folder">
        <FolderItem folder={rootFolder} onSelected={onSelected} />
      </List.Section>
      <List.Section title="Subfolders">
        {folders.map((folder) => (
          <FolderItem key={folder.path} folder={folder} onSelected={onSelected} />
        ))}
      </List.Section>
    </List>
  );
}

export function FolderPicker({ onSelected }: FolderPickerProps) {
  const [query, setQuery] = useState("");
  const [homeFolders, setHomeFolders] = useState<Folder[]>([]);
  const [volumes, setVolumes] = useState<Folder[]>([]);
  const [recents, setRecents] = useState<Folder[]>([]);
  const [results, setResults] = useState<Folder[]>([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    Promise.all([childFolders(home), mountedVolumes(), readConfig()])
      .then(async ([children, mounted, config]) => {
        setHomeFolders(children);
        setVolumes(mounted);
        const existing = await Promise.all(
          config.recentDestinations.map(async (item) =>
            (await isDirectory(item)) ? { path: item, title: path.basename(item) } : undefined,
          ),
        );
        setRecents(existing.filter((item): item is Folder => item !== undefined));
      })
      .finally(() => setLoading(false));
  }, []);

  useEffect(() => {
    if (!query.trim()) {
      setResults([]);
      return;
    }
    let cancelled = false;
    setLoading(true);
    const timer = setTimeout(() => {
      searchFolders(query, volumes)
        .then((folders) => {
          if (!cancelled) setResults(folders);
        })
        .finally(() => {
          if (!cancelled) setLoading(false);
        });
    }, 180);
    return () => {
      cancelled = true;
      clearTimeout(timer);
    };
  }, [query, volumes]);

  const homeRoot = useMemo(() => ({ path: home, title: "Home" }), []);
  const isSearching = query.trim().length > 0;

  return (
    <List
      isLoading={loading}
      navigationTitle="Set AirDrop Folder"
      searchBarPlaceholder="Search folders in Home and external drives…"
      onSearchTextChange={setQuery}
      throttle
    >
      {isSearching ? (
        <List.Section title="Search Results" subtitle={`${results.length}`}>
          {results.map((folder) => (
            <FolderItem key={folder.path} folder={folder} onSelected={onSelected} />
          ))}
        </List.Section>
      ) : (
        <>
          {recents.length > 0 ? (
            <List.Section title="Recent Destinations">
              {recents.map((folder) => (
                <FolderItem key={folder.path} folder={folder} onSelected={onSelected} />
              ))}
            </List.Section>
          ) : null}
          <List.Section title="Home">
            <FolderItem folder={homeRoot} onSelected={onSelected} />
            {homeFolders.map((folder) => (
              <FolderItem key={folder.path} folder={folder} onSelected={onSelected} />
            ))}
          </List.Section>
          {volumes.length > 0 ? (
            <List.Section title="External Drives">
              {volumes.map((folder) => (
                <FolderItem key={folder.path} folder={folder} onSelected={onSelected} />
              ))}
            </List.Section>
          ) : null}
        </>
      )}
    </List>
  );
}
