# AGENTS.md

## Quick Facts
- This repository is a Quickshell/QtQuick project (QML + small JS helpers), not a CMake/npm/python workspace.
- Main runtime entrypoint is `shell.qml`, which creates `QuickDashboard` and then `DashboardMain`.

## Commands (Verified Here)
- Run dashboard: `qs -c quickdashboard`
- Lint all QML: `shopt -s globstar nullglob && qmllint shell.qml DashboardMain.qml qd/**/*.qml`
- Lint one file: `qmllint qd/Widgets/Calendar/Widget.qml`

## Real Structure (What Wires What)
- `shell.qml` -> `qd/QuickDashboard.qml` (`QuickDashboard`) -> `DashboardMain.qml` (`Dashboard`).
- `qd/Widgets/*.qml` are thin module entry wrappers; implementation lives in `qd/Widgets/<Name>/Widget.qml`.
- `qd/Providers/*.qml` are singleton loaders exposing `instance`; they load `<Name>/Provider.qml` or `<Name>/MockProvider.qml` based on `QD.Settings.isDemo`.
- `qd/Services/*.qml` are singleton data sources backed by `Process` + timers (`Dgop`, `Ping`, `Ip`, `Getent`, `Khal`, etc.).
- `qd/Config/*.qml` contains typed config objects and merge/validation logic.

## Repo-Specific Conventions and Gotchas
- Keep `pragma ComponentBehavior: Bound` in new QML files (project-wide convention).
- In `qd/Providers/*.qml`, keep the seemingly unused import like `import qs.qd.Providers.CPU`; comments state it is required for Quickshell hot reload.
- `qd/Dashboard.qml`: do not restore `root.activeWidget = null` in `closeDetailsTimer`; file comment says this crashes Quickshell.
- `qd/Services/Dgop.qml` and `qd/Services/Ping.qml` intentionally restart long-running processes periodically to work around Quickshell RAM growth; do not remove as "cleanup".

## Runtime and Feature Dependencies
- Core metrics path depends on `dgop` (`qd/Services/Dgop.qml` launches `dgop server`).
- Network-related data relies on system tools used by services: `ping`, `ip`, `iw`, `getent`.
- Calendar integration uses `khal` and optionally `vdirsyncer`; calendar app launcher logic also uses `qd/bin/chrome-wait.sh`.
- Media/audio widgets use Quickshell MPRIS/PipeWire services.

## State and Local Files
- Persistent UI state is stored via `QD.Settings` at `${XDG_CACHE_HOME}/quickdashboard/state.ini` (`qd/Settings.qml`).
- `.qmlls.ini` is local and gitignored.
