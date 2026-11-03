#!/bin/sh
set -eu

TEST_DIR="$(CDPATH='' cd -- "$(dirname -- "$0")" && pwd)"
exec "$TEST_DIR/run-quickshell.sh" "$TEST_DIR/quickshell/Bar.qml"
