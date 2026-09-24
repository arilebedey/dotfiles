# Raycast configuration

This public dotfiles repository keeps reviewable Raycast configuration in source control without publishing private application state.

**Quick restoration:** On a new Mac, install Raycast, Node.js, and the Xcode Command Line Tools; clone this repository to `~/System`; add `~/System/macos/raycast` as a Raycast Script Commands directory; then run `npm install && npm run dev` in each project under `macos/raycast_npx` (run `./scripts/install.sh` first for AirDrop Router). Finally, import any reviewed Quicklinks or Snippets JSON from `macos/raycast/exports` and reselect machine-specific folders, permissions, and hotkeys.

## What is backed up

- `../raycast_npx/` contains source, lockfiles, and setup instructions for local Raycast extensions.
- This directory contains Raycast Script Commands.
- `exports/` is reserved for manually reviewed Quicklinks and Snippets JSON exports.

Full `.rayconfig` exports are intentionally ignored. Raycast documents that they can contain clipboard history, AI chats, notes, MCP server configuration, extension settings, aliases, and hotkeys. Keep full encrypted exports in private storage rather than this public repository.

## Restore on a new Mac

1. Install Raycast, Node.js, and the Xcode Command Line Tools.
2. Clone this repository to `~/System`.
3. In Raycast Settings, add `~/System/macos/raycast` as a Script Commands directory.
4. Install each extension under `../raycast_npx/`:

   ```sh
   cd ~/System/macos/raycast_npx/open-folder-in-finder
   npm install
   npm run dev

   cd ~/System/macos/raycast_npx/airdrop-router
   ./scripts/install.sh
   npm run dev
   ```

   Run each `npm run dev` command once so Raycast imports the local extension. It can then be stopped; rerun it when developing extension changes.

5. Import reviewed JSON files from `exports/` using Raycast's **Import Quicklinks** and **Import Snippets** commands.
6. Reassign machine-specific hotkeys and protected-folder permissions when macOS or Raycast prompts for them.

## Add portable settings

- Export Quicklinks or Snippets individually as JSON from Raycast.
- Inspect the JSON for personal URLs, addresses, tokens, private text, or machine-specific absolute paths.
- Commit only the reviewed JSON to `exports/`.
- Never rename a full settings archive to bypass the repository's `*.rayconfig` guard.

Raycast does not provide a reviewable, declarative export for every preference. Settings that exist only in a full `.rayconfig` archive should be documented here or kept in a private encrypted backup outside GitHub.
