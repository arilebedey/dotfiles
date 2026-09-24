import { Action, ActionPanel, Detail, Icon, updateCommandMetadata } from "@raycast/api";
import { promises as fs } from "fs";
import { useEffect, useState } from "react";
import { compactPath, disableRouting, readConfig, RouterConfig } from "./config";
import { FolderPicker } from "./folder-picker";

export default function Command() {
  const [config, setConfig] = useState<RouterConfig>();
  const [available, setAvailable] = useState(false);

  async function refresh() {
    const next = await readConfig();
    setConfig(next);
    const destinationAvailable = Boolean(
      next.destinationPath &&
      (await fs
        .stat(next.destinationPath)
        .then((stat) => stat.isDirectory())
        .catch(() => false)),
    );
    setAvailable(destinationAvailable);
    await updateCommandMetadata({
      subtitle: next.enabled && next.destinationPath ? compactPath(next.destinationPath) : "Routing disabled",
    });
  }

  useEffect(() => {
    void refresh();
  }, []);

  if (!config) return <Detail isLoading />;

  const destination = config.destinationPath;
  const status = !config.enabled ? "Disabled" : available ? "Enabled" : "Destination unavailable";
  const markdown = [
    "# Current AirDrop Folder",
    "",
    `**Status:** ${status}`,
    "",
    destination ? `\`${compactPath(destination).replace(/`/g, "\\`")}\`` : "No destination has been selected.",
    "",
    config.enabled && !available
      ? "> AirDrops will remain safely in Downloads until this destination becomes available."
      : "Future AirDrops are routed after the transfer finishes.",
  ].join("\n");

  return (
    <Detail
      markdown={markdown}
      actions={
        <ActionPanel>
          {destination && available ? (
            <Action.Open title="Open in Finder" target={destination} icon={Icon.Finder} />
          ) : null}
          <Action.Push
            title="Change AirDrop Folder"
            icon={Icon.Folder}
            target={<FolderPicker onSelected={refresh} />}
          />
          {destination ? <Action.CopyToClipboard title="Copy Path" content={destination} /> : null}
          {config.enabled ? (
            <Action
              title="Disable AirDrop Routing"
              icon={Icon.XMarkCircle}
              style={Action.Style.Destructive}
              onAction={async () => {
                await disableRouting();
                await refresh();
              }}
            />
          ) : null}
        </ActionPanel>
      }
    />
  );
}
