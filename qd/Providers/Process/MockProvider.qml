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

    readonly property var _processesByCPU: [
        {"command":"spotify","args":"--enable-features=UseOzonePlatform --ozone-platform=wayland --uri","pid":62428,"value":0.642462806173341916},
        {"command":"Hyprland","args":"--watchdog-fd 4","pid":1948,"value":0.37939825166907698},
        {"command":"pipewire-pulse","args":"","pid":2858,"value":0.134871172951377663},
        {"command":"firefox","args":"","pid":16927,"value":0.12026946450538711},
        {"command":"vesktop","args":"--start-minimized --relaunch","pid":16218,"value":0.09402756551978764},
        {"command":"qmlls6","args":"-E","pid":42064,"value":0.037377967831732556},
        {"command":"nvim","args":"-c NeovimProjectHistory","pid":42010,"value":0.026899714417022828},
        {"command":"Telegram","args":"-startintray","pid":2089,"value":0.02162720729737856},
        {"command":"pipewire","args":"","pid":2413,"value":0.012642327926622402},
        {"command":"kworker/u76:1-i915_flip","args":"","pid":144731,"value":0.008506099291366701},
        {"command":"marksman","args":"server","pid":144590,"value":0.007169615345996012},
        {"command":"alacritty","args":"--class Neovim -e nvim -c NeovimProjectHistory","pid":42001,"value":0.005021420044709151},
        {"command":"far2l","args":"--notty","pid":18509,"value":0.004273337962460475},
        {"command":"kworker/u76:3-i915_flip","args":"","pid":146985,"value":0.0032689226761668027},
        {"command":"containerd","args":"","pid":1062,"value":0.002767220734858467},
        {"command":"rcu_preempt","args":"","pid":16,"value":0.0018182550778992276},
        {"command":"kworker/u73:3-events_unbound","args":"","pid":139818,"value":0.0017910817266374908},
        {"command":"kworker/u73:4-btrfs-endio-write","args":"","pid":150301,"value":0.0015546615013873075},
        {"command":"kworker/u73:0-kvfree_rcu_reclaim","args":"","pid":148558,"value":0.0011419407556364158},
        {"command":"btrfs-transaction","args":"","pid":374,"value":0.0011405748720568363},
        {"command":"kworker/u73:2-kvfree_rcu_reclaim","args":"","pid":148601,"value":0.0010518809622638231},
        {"command":"kworker/u73:7-btrfs-endio-write","args":"","pid":149050,"value":0.0008650235084207511},
        {"command":"kworker/u73:1-btrfs-delalloc","args":"","pid":147859,"value":0.0007464958261508693},
        {"command":"kworker/u73:5-btrfs-endio-write","args":"","pid":148661,"value":0.0007081958990123433},
        {"command":"dms","args":"run","pid":2083,"value":0.0007053113774363203},
        {"command":"wireplumber","args":"","pid":2414,"value":0.0006441995281023952},
        {"command":"atop","args":"-w /var/log/atop/atop_20260208 600","pid":134898,"value":0.0005413070043666943},
        {"command":"mozhi","args":"serve","pid":1990,"value":0.0005072031090565345},
        {"command":"dockerd","args":"-H fd:// --containerd=/run/containerd/containerd.sock","pid":1303,"value":0.0004958941207324388},
        {"command":"irq/178-iwlwifi:default_queue","args":"","pid":744,"value":0.00047267186381774355},
        {"command":"migration/8","args":"","pid":43,"value":0.00046632728280505606},
        {"command":"alacritty","args":"","pid":15956,"value":0.0003288699660625809},
        {"command":"kworker/8:1-mm_percpu_wq","args":"","pid":146684,"value":0.00032831399718125434},
        {"command":"NetworkManager","args":"--no-daemon","pid":892,"value":0.00030692181660309047},
        {"command":"migration/9","args":"","pid":49,"value":0.0003047982510464737},
        {"command":"kworker/7:1-i915-unordered","args":"","pid":132769,"value":0.00028102131385741483},
        {"command":"kworker/8:1H-i915_cleanup","args":"","pid":156,"value":0.0002542339036700846},
        {"command":"upowerd","args":"","pid":915,"value":0.00024792546610875687},
    ]

    Component.onCompleted: {
        Qt.callLater(() => {
            root.updateProcessesByCPU(root._processesByCPU)
            root.updateProcessesByRAM(root._processesByRAM)
        })
    }
}
