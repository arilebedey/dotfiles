import { promises as fs } from "fs";
import { homedir } from "os";
import path from "path";

export interface RouterConfig {
  version: 1;
  enabled: boolean;
  destinationPath?: string;
  recentDestinations: string[];
  updatedAt: string;
}

const configDirectory = path.join(homedir(), "Library", "Application Support", "AirDrop Router");
export const configPath = path.join(configDirectory, "config.json");

export async function readConfig(): Promise<RouterConfig> {
  try {
    const raw = await fs.readFile(configPath, "utf8");
    const parsed = JSON.parse(raw) as Partial<RouterConfig>;
    return {
      version: 1,
      enabled: parsed.enabled === true,
      destinationPath: typeof parsed.destinationPath === "string" ? parsed.destinationPath : undefined,
      recentDestinations: Array.isArray(parsed.recentDestinations)
        ? parsed.recentDestinations.filter((item): item is string => typeof item === "string")
        : [],
      updatedAt: typeof parsed.updatedAt === "string" ? parsed.updatedAt : new Date(0).toISOString(),
    };
  } catch (error) {
    if ((error as NodeJS.ErrnoException).code !== "ENOENT") throw error;
    return { version: 1, enabled: false, recentDestinations: [], updatedAt: new Date(0).toISOString() };
  }
}

async function writeConfig(config: RouterConfig): Promise<void> {
  await fs.mkdir(configDirectory, { recursive: true });
  const temporaryPath = `${configPath}.${process.pid}.${Date.now()}.tmp`;
  await fs.writeFile(temporaryPath, `${JSON.stringify(config, null, 2)}\n`, { mode: 0o600 });
  await fs.rename(temporaryPath, configPath);
}

export async function setDestination(destinationPath: string): Promise<RouterConfig> {
  const stat = await fs.stat(destinationPath);
  if (!stat.isDirectory()) throw new Error("The selected item is not a folder.");

  const existing = await readConfig();
  const recentDestinations = [
    destinationPath,
    ...existing.recentDestinations.filter((item) => item !== destinationPath),
  ].slice(0, 10);
  const updated: RouterConfig = {
    version: 1,
    enabled: true,
    destinationPath,
    recentDestinations,
    updatedAt: new Date().toISOString(),
  };
  await writeConfig(updated);
  return updated;
}

export async function disableRouting(): Promise<RouterConfig> {
  const existing = await readConfig();
  const updated: RouterConfig = { ...existing, version: 1, enabled: false, updatedAt: new Date().toISOString() };
  await writeConfig(updated);
  return updated;
}

export function compactPath(filePath: string): string {
  const home = homedir();
  return filePath === home ? "~" : filePath.startsWith(`${home}/`) ? `~/${filePath.slice(home.length + 1)}` : filePath;
}
