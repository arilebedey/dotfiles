# Repeating low-battery alert

Installed a per-user LaunchAgent that checks the Mac battery once a minute while the user is logged in and the Mac is awake.

- Script: `~/Library/Scripts/low-battery-alert.sh`
- LaunchAgent: `~/Library/LaunchAgents/com.user.lowbatteryalert.plist`
- Threshold: 10% or lower, only while on battery power
- Notification: "Low battery" with the Basso sound

The agent starts at login. To reload it after editing:

```zsh
launchctl bootout "gui/$(id -u)" "$HOME/Library/LaunchAgents/com.user.lowbatteryalert.plist" 2>/dev/null || true
launchctl bootstrap "gui/$(id -u)" "$HOME/Library/LaunchAgents/com.user.lowbatteryalert.plist"
```

To remove it:

```zsh
launchctl bootout "gui/$(id -u)" "$HOME/Library/LaunchAgents/com.user.lowbatteryalert.plist"
rm "$HOME/Library/LaunchAgents/com.user.lowbatteryalert.plist"
rm "$HOME/Library/Scripts/low-battery-alert.sh"
```

Notifications are only emitted while on battery power; they stop once connected to AC power. A sleeping Mac is not awakened for these checks.
