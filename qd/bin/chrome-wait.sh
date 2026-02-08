#!/bin/sh

# This file is a part of quickdashboard: https://github.com/chpock/quickdashboard
#
# Copyright (C) 2025-2026 Kostiantyn Kushnir <chpock@gmail.com>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.

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
