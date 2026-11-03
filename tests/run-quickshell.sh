#!/bin/sh
set -eu

# Quickshell's native QML types are linked into qs, not qmltestrunner.
ROOT="$(CDPATH='' cd -- "$(dirname -- "$0")/.." && pwd)"
TEST_FILE="${1:?Pass the QML test file path}"
TEST_ROOT="$(mktemp -d)"
trap 'rm -rf "$TEST_ROOT"' EXIT HUP INT TERM
ln -s "$ROOT/qd" "$TEST_ROOT/qd"
cp "$TEST_FILE" "$TEST_ROOT/shell.qml"

# Mock providers still instantiate the backend service; prevent real CLI queries.
mkdir "$TEST_ROOT/bin"
printf '#!/bin/sh\nexit 1\n' > "$TEST_ROOT/bin/openusage-cli"
chmod +x "$TEST_ROOT/bin/openusage-cli"

XDG_CACHE_HOME="$TEST_ROOT/cache" PATH="$TEST_ROOT/bin:$PATH" \
QT_QPA_PLATFORM=offscreen QT_QUICK_BACKEND=software \
    qs -p "$TEST_ROOT/shell.qml" --no-color
