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

    readonly property var _mount_points: [
        {
            device: '/dev/nvme0n1p2',
            mount:  '/',
            fstype: 'btrfs',
            size:  1023168584089,
            used:  111991272243,
            avail: 903446370713,
        },
        {
            device: '/dev/nvme0n1p1',
            mount:  '/boot',
            fstype: 'vfat',
            size:  1071644672,
            used:  301780172,
            avail: 769864499,
        },
    ]

    readonly property var _rates: [
        // 0-9s: Mostly idle with tiny background noise (logging, heartbeats)
        [0, 1024],
        [4096, 2048],
        [0, 512],
        [0, 0],
        [8192, 4096],
        [0, 1024],
        [2048, 0],
        [0, 256],
        [16384, 8192],
        [0, 0],
        // 10-15s: Sudden Write spike (e.g., file download or log flush)
        [1048576, 45000000],
        [524288, 85000000],
        [256000, 120000000], // Peak write burst
        [128000, 95000000],
        [1024000, 60000000],
        [500000, 30000000],
        // 16-30s: Heavy Mixed Activity (Processing/Database - high reads, moderate writes)
        [25000000, 15000000],
        [45000000, 22000000],
        [80000000, 10000000],
        [65000000, 18000000],
        [110000000, 5000000], // Peak read burst
        [95000000, 12000000],
        [70000000, 25000000],
        [40000000, 40000000], // Sync point
        [60000000, 35000000],
        [85000000, 20000000],
        [55000000, 15000000],
        [30000000, 8000000],
        [45000000, 5000000],
        [20000000, 2000000],
        // 31-40s: Activity tailing off, intermittent spikes
        [5000000, 1000000],
        [12000000, 500000],
        [2000000, 4096],
        [8000000, 1024000],
        [500000, 0],
        [1500000, 256000],
        [0, 128000],
        [3000000, 512000],
        [500000, 0],
        [0, 0],
        // 41-49s: Return to Idle
        [4096, 2048],
        [0, 0],
        [2048, 1024],
        [0, 4096],
        [0, 0],
        [1024, 1024],
        [0, 512],
        [8192, 0],
        [0, 0],
        [6000000, 510000],
    ]

    Component.onCompleted: {
        Qt.callLater(() => {

            for (const item of root._mount_points) {
                root.mountModel.append(item)
            }

            for (const item of root._rates) {
                root.updateDiskRate({
                    readrate: item[0],
                    writerate: item[1],
                })
            }

            const lastPoint = root._rates[root._rates.length - 1]
            root.rate.read = lastPoint[0]
            root.rate.write = lastPoint[1]

        })
    }
}
