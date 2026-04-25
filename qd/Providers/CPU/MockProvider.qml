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

    model: "Unknown"
    cores: _coresUsage.length
    frequency: 1790.873
    usage: _usage[_usage.length - 1]
    temperature: 57

    readonly property var _coresUsage: [
        13.131313130914805,
        3.0303030305368766,
        8.08080808130918,
        3.0303030303983784,
        3.030303029824202,
        0,
        11.111111110825298,
        1.0101010103014496,
        1.0204081627349886,
        25.0000000000436557,
        71.0309278352603368,
        5.0000000000873115,
        2.0408163269397144,
        1.0000000002037268,
        99.0101010095739282,
        1.0101010103014496,
        0.9900990101007028,
        0,
    ]

    readonly property var _usage: [
        12.4, 14.1, 13.5, 15.9, 18.2, 17.5, 14.8, 12.2, 13.6, 15.2,
        15.8, 18.2, 22.4, 28.7, 35.1, 33.4, 42.9, 55.6, 62.3, 58.1,
        42.1, 88.5, 92.3, 75.6, 45.2, 32.1, 28.4, 24.5, 21.8, 19.3,
        18.2, 16.9, 14.5, 12.1, 13.4, 15.8, 18.9, 22.1, 20.4, 17.7,
        16.5, 14.2, 13.8, 15.1, 19.4, 25.6, 38.7, 42.1, 35.5, 22.8,
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
            root.updateCoresUsage(root._coresUsage)
            for (const value of root._usage) {
                root.updateUsage({
                    frequency: root.frequency,
                    temperature: root.temperature,
                    usage: value,
                })
            }
            root.processListModel.updateData(root._processesByCPU)
        })
    }
}
