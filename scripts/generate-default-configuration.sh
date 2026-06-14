#!/bin/sh

set -e

SELF_DIR="$(cd "$(dirname "$0")"; pwd)"
QD_DIR="$SELF_DIR/.."
QD="$QD_DIR/bin/quickdashboard"

THEME_JSON_FILE="$QD_DIR/theme.json"
WIDGET_JSON_FILE="$QD_DIR/widget.json"
DEFAULTS_JSON_FILE="$QD_DIR/defaults.json"

"$QD" ipc show >/dev/null 2>&1 && QD_RUNNING=1 || QD_RUNNING=0

if [ "$QD_RUNNING" -eq 0 ]; then
    "$QD" >/dev/null &

    CHECK_ATTEMPT=0
    MAX_CHECK_ATTEMPT=5
    while :; do
        ! "$QD" ipc show >/dev/null 2>&1 || break
        CHECK_ATTEMPT=$(( CHECK_ATTEMPT + 1 ))
        if [ "$CHECK_ATTEMPT" -gt "$MAX_CHECK_ATTEMPT" ]; then
            echo "ERROR: failed to launch quickdashboard." >&2
            exit 1
        fi
        sleep 1
    done
fi

"$QD" ipc call defaults getThemeJson > "$THEME_JSON_FILE"
"$QD" ipc call defaults getWidgetJson > "$WIDGET_JSON_FILE"
"$QD" ipc call defaults getDefaultsJson > "$DEFAULTS_JSON_FILE"

if [ "$QD_RUNNING" -eq 0 ]; then
    "$QD" kill >/dev/null
fi
