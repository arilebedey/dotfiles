# AirDrop Router

Choose a persistent destination for future AirDrop transfers from Raycast. macOS still receives items in `~/Downloads`; a native login agent verifies AirDrop metadata and safely moves completed transfers to the selected folder.

## Commands

- **Set AirDrop Folder** — search folders under Home and mounted external drives, browse without leaving Raycast, and select the destination.
- **Show Current AirDrop Folder** — show status and path, open it in Finder, change it, copy it, or disable routing.
- **Disable AirDrop Routing** — leave future AirDrops in Downloads.

The selected destination is machine-local at `~/Library/Application Support/AirDrop Router/config.json`. The worker starts at login through `~/Library/LaunchAgents/com.arilebedey.airdrop-router.plist`.

## Install

```sh
./scripts/install.sh
npm run dev
```

Keep `npm run dev` running for development. Once Raycast has imported the local extension, its commands remain registered; rerun it whenever you change extension source.

macOS may ask for permission to access Downloads or another protected folder the first time. Grant access to the process identified in the prompt. If a protected destination cannot be accessed, the transfer remains in Downloads and the error is logged.

## Verify safely

Run the isolated tests first:

```sh
npm run lint
npm run build
npm run test:worker
```

Then perform a real AirDrop test:

1. In Raycast, run **Set AirDrop Folder** and select an empty test folder.
2. Run **Show Current AirDrop Folder** and confirm it reports **Enabled**.
3. AirDrop a disposable small file to this Mac.
4. Wait roughly five seconds after the transfer completes.
5. Confirm the item moved to the selected folder and no unrelated Downloads moved.

If it remains in Downloads, inspect Apple’s metadata without moving the file:

```sh
./scripts/diagnose-airdrop.sh "$HOME/Downloads/the-file-name"
tail -n 50 "$HOME/Library/Application Support/AirDrop Router/router.log"
```

The diagnostic should report `AirDrop marker: yes`. If it reports `no`, retain the file in Downloads and update the detector only after reviewing the metadata emitted by the diagnostic.

## Safety behavior

- Only items marked by macOS as coming from `sharingd` or AirDrop are moved automatically.
- New items must remain stable across multiple checks before they move.
- Existing destination files are never overwritten; collisions become `name 2.ext`, `name 3.ext`, and so on.
- Missing or disconnected destinations leave transfers safely in Downloads.
- Browser downloads and pre-existing Downloads are ignored.
- Successful transfers are quiet; failures are logged and generate a notification.

## Uninstall

```sh
./scripts/uninstall.sh
```

The uninstall script moves the login-agent plist and worker binary to Trash. It intentionally keeps the configuration and logs.
