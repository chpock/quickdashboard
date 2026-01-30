#!/bin/sh

set -e

[ "$1" = /usr/bin/chromium ] || exec "$@"

command -v hyprctl >/dev/null 2>&1 || exec "$@"
command -v jq >/dev/null 2>&1 || exec "$@"

APP_ID=""

for PARAM; do
    case "$PARAM" in
        --app-id=*)
            APP_ID="${PARAM#*=}"
            break
            ;;
    esac
done

[ -n "$APP_ID" ] || exec "$@"

nohup "$@" > /dev/null 2>&1 &

COUNT=0
while true; do

    FOUND="$(hyprctl clients -j | jq "any(.[]; .initialClass | test(\"^chrome-${APP_ID}-.*\"))")"

    if [ "$FOUND" = "true" ]; then
        COUNT=-1
    else
        if [ "$COUNT" -eq -1 ] || [ "$COUNT" -gt 3 ]; then
            break
        fi
        COUNT=$(( COUNT + 1 ))
    fi

    sleep 0.5

done
