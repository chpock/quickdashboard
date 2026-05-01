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

import Quickshell
import QtQuick
import qs.qd.Services as Service

Scope {
    id: root

    readonly property alias providersModel: providersModelObj
    property bool hasService: true
    property bool running: false

    property var notice: null

    property string latestProviders: ''
    property var latestProvidersLines: ({})

    Connections {
        target: Service.Openusage
        enabled: root.hasService
        function onUpdateProviders(data) {
            // root.dataProviders = data
            // root.updateModels()
            console.log("Got data:", JSON.stringify(data))
            root.notice = data.notice
            const providersData = data.data
            for (let i = 0; i < providersData.length; ++i) {

                const providerData = providersData[i]

                const modelData = {
                    id: providerData.id,
                    displayName: providerData.displayName,
                    plan: providerData.plan ?? '',
                    error: providerData.error ?? '',
                }

                if (i < providersModelObj.count) {
                    providersModelObj.set(i, modelData)
                } else {
                    modelData.lines = []
                    providersModelObj.append(modelData)
                }

                const lines = providerData.lines

                if (lines.length) {

                    const providerModel = providersModelObj.get(i)
                    const linesModel = providerModel.lines

                    for (let j = 0; j < lines.length; ++j) {
                        const line = lines[j]
                        const linesModelData = {
                            label: line.label,
                            periodDurationSeconds: line.periodDurationSeconds,
                            percent: line.percent,
                            resetsAt: line.resetsAt,
                        }
                        if (j < linesModel.count) {
                            linesModel.set(j, linesModelData)
                        } else {
                            linesModel.append(linesModelData)
                        }
                    }

                    if (lines.length < linesModel.count) {
                        linesModel.remove(lines.length, linesModel.count - lines.length)
                    }

                }
            }
            if (providersData.length < providersModelObj.count) {
                providersModelObj.remove(providersData.length, providersModelObj.count - providersData.length)
            }
        }
        function onAvailable() {
            root.running = true
        }
        function onUnavailable() {
            root.running = false
        }
    }

    ListModel {
        id: providersModelObj
        // Component.onCompleted: {
        //     if (root.hasService) {
        //         let stateCount = QD.Settings.stateGet('Provider.Disk.ListModel.count', 0)
        //         const sampleData = {
        //             device: '',
        //             mount:  '',
        //             fstype: '',
        //             size:  0,
        //             used:  0,
        //             avail: 0,
        //         }
        //         while (stateCount-- > 0) {
        //             append(sampleData)
        //             root.mountModelList.push('')
        //         }
        //     }
        // }
        // onCountChanged: {
        //     if (root.hasService) {
        //         QD.Settings.stateSet('Provider.Disk.ListModel.count', count)
        //     }
        // }
    }
}
