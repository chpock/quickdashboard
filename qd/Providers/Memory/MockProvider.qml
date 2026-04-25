/*
    This file is a part of quickdashboard: https://github.com/chpock/quickdashboard

    Copyright (C) 2025-2026 Kostiantyn Kushnir <chpock@gmail.com>

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <https://www.gnu.org/licenses/>.
*/

pragma ComponentBehavior: Bound

import QtQuick

Provider {
    id: root

    ramTotal: 2**35
    ramAvailable: ramTotal * 0.57

    swapTotal: 2**34
    swapFree: swapTotal * 0.81
    swapIsInstalled: true

    hasService: false

    readonly property var _processesByRAM: [
        {"command":"firefox","args":"","pid":16927,"value":2760769536},
        {"command":"vesktop","args":"--start-minimized --relaunch","pid":16218,"value":1170209792},
        {"command":"qmlls6","args":"-E","pid":42064,"value":1087541248},
        {"command":"spotify","args":"--enable-features=UseOzonePlatform --ozone-platform=wayland --uri","pid":62428,"value":706419712},
        {"command":"Telegram","args":"-startintray","pid":2089,"value":573709312},
        {"command":"qs","args":"-c quickdashboard","pid":146520,"value":235144192},
        {"command":"nvim","args":"-c NeovimProjectHistory","pid":42010,"value":170852352},
        {"command":"crow","args":"","pid":2100,"value":131780608},
        {"command":"Hyprland","args":"--watchdog-fd 4","pid":1948,"value":102539264},
        {"command":"spotify","args":"--monitor-self-annotation=ptype=crashpad-handler --type=crashpad-handler --max-uploads=5 --max-db-size=20 --max-db-age=5 --database=/home/kot/.cache/spotify --url=https://crashdump.spotify.com:443/ --annotation=lsb-release=Arch Linux --annotation=platform=linux64 --annotation=product=spotify --annotation=version=1.2.79.427 --initial-client-fd=7 --shared-client-connection","pid":62434,"value":98377728},
        {"command":"far2l","args":"--notty","pid":18509,"value":97394688},
        {"command":"dockerd","args":"-H fd:// --containerd=/run/containerd/containerd.sock","pid":1303,"value":94416896},
        {"command":"alacritty","args":"","pid":15956,"value":93569024},
        {"command":"marksman","args":"server","pid":144590,"value":89821184},
        {"command":"hyprpolkitagent","args":"","pid":2363,"value":61247488},
        {"command":"containerd","args":"","pid":1062,"value":58728448},
        {"command":"systemd-journald","args":"","pid":425,"value":44326912},
        {"command":"Xwayland","args":":0 -rootless -core -listenfd 58 -listenfd 59 -displayfd 119 -wm 116","pid":2190,"value":41574400},
        {"command":"dms","args":"run","pid":2083,"value":36675584},
        {"command":"alacritty","args":"","pid":47362,"value":36443136},
        {"command":"python3","args":"/usr/bin/tlp-pd","pid":1569,"value":33050624},
        {"command":"alacritty","args":"--class Neovim -e nvim -c NeovimProjectHistory","pid":42001,"value":31784960},
        {"command":"mozhi","args":"serve","pid":1990,"value":31670272},
        {"command":"pipewire-pulse","args":"","pid":2858,"value":30756864},
        {"command":"xdg-desktop-portal-gtk","args":"","pid":2369,"value":29626368},
        {"command":"NetworkManager","args":"--no-daemon","pid":892,"value":27660288},
    ]

    Component.onCompleted: {
        Qt.callLater(() => {
            root.processListModel.updateData(root._processesByRAM)
        })
    }
}
