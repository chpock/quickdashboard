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

    dnsCheckTime: 12

    readonly property var _latency: [
        {
            name: 'Google DNS',
            host: '8.8.8.8',
            isGateway: false,
            time: 21,
        },
        {
            name: 'Cloudflare DNS',
            host: '1.1.1.1',
            isGateway: false,
            time: 14,
        },
        {
            name: 'Quad9 DNS',
            host: '9.9.9.9',
            isGateway: false,
            time: 45,
        },
    ]

    readonly property var _rates: [
        [3625, 1934],
        [4169, 2011],
        [185, 99],
        [1504, 748],
        [2002, 904],
        [2302, 882],
        [3433, 1003],
        [3268, 1370],
        [0, 0],       // Zero drop
        [1189, 919],
        [5202, 1498],
        [11000, 164],
        [28389, 6955], // Spike 1
        [19839, 6708], // Tailing off
        [10000, 3000],
        [5000, 191],
        [2150, 879],
        [2363, 959],
        [3182, 898],
        [2323, 1430],
        [1977, 6430],
        [21350, 8782], // Spike 2
        [17294, 5819],
        [10564, 4080],
        [8017, 5471],
        [6432, 3622],
        [170, 193],
        [1747, 811],
        [2120, 1698],
        [2827, 1992],
        [0, 0],
        [1062, 681],
        [2081, 963],
        [2038, 1469],
        [2416, 1816],
        [2600, 1827],
        [0, 0],
        [1709, 628],
        [1503, 781],
        [2044, 650],
        [10000, 3000],
        [20387, 5915], // Spike 3
        [19750, 4024],
        [12764, 3714],
        [10047, 2572],
        [8042, 183],
        [7369, 695],
        [2780, 1423],
        [2927, 1732],
        [2283, 1845]
    ]

    Component.onCompleted: {
        Qt.callLater(() => {

            for (const item of root._rates) {
                root.updateNetworkRate({
                    rxrate: item[0],
                    txrate: item[1],
                })
            }

            const lastPoint = root._rates[root._rates.length - 1]
            root.rate.download = lastPoint[0]
            root.rate.upload = lastPoint[1]

            root.latency.time = 10

            latencyHostsModel.updateElements(root._latency)
            for (let idx = 0; idx < root._latency.length; ++idx) {
                const value = root._latency[idx].time
                latencyHostsModel.latencyValues[idx] = value
                latencyHostsModel.setProperty(idx, 'time', value)
            }
            root.refreshLatency()

            root.gatewayDefault.host = '192.168.0.1'
            root.gatewayDefault.latency = 5

        })
    }
}
