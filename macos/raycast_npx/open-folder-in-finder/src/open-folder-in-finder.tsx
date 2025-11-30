import { Action, ActionPanel, List } from "@raycast/api";
import { homedir } from "os";

export default function Command() {
  const home = homedir();
  const folders = [
    { title: "Downloads", path: `${home}/Downloads`, icon: { source: "📥" } },
    { title: "Screenshots", path: `${home}/Desktop/Screenshots`, icon: { source: "🖼️" } },
    { title: "Documents", path: `${home}/Documents`, icon: { source: "📄" } },
  ];

  return (
    <List navigationTitle="Open Folder in Finder">
      {folders.map((folder) => (
        <List.Item
          key={folder.title}
          title={folder.title}
          icon={folder.icon}
          actions={
            <ActionPanel>
              <Action.Open title="Open in Finder" target={folder.path} />
            </ActionPanel>
          }
        />
      ))}
    </List>
  );
}
