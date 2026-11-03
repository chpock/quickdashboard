#!/bin/sh
set -eu

# Quickshell's native QML types are linked into qs, not qmltestrunner.
ROOT="$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)"
TEST_ROOT="$(mktemp -d)"
trap 'rm -rf "$TEST_ROOT"' EXIT HUP INT TERM
ln -s "$ROOT/qd" "$TEST_ROOT/qd"
cp "$ROOT/tests/quickshell/Bar.qml" "$TEST_ROOT/shell.qml"

QT_QPA_PLATFORM=offscreen QT_QUICK_BACKEND=software \
    qs -p "$TEST_ROOT/shell.qml" --no-color
