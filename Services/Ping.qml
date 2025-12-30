pragma ComponentBehavior: Bound
pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick
import qs.Services as Service

Singleton {
    id: root

    signal updateInfoPing(var data, real value)
    signal updateListPing(var data)
    signal updateListPingGateway(var data)

    // ping interval in seconds
    property int interval: 3
    // timeout for ping in milliseconds
    property int timeout: 3000

    property var pingHostsList: [
        { name: 'Google DNS',     host: '8.8.8.8', isGateway: false, },
        { name: 'Cloudflare DNS', host: '1.1.1.1', isGateway: false, },
        { name: 'Quad9 DNS',      host: '9.9.9.9', isGateway: false, },
    ]
    property var gatewayHostsList: []
    readonly property var hostsList: [
        ...pingHostsList,
        ...gatewayHostsList,
    ]

    Connections {
        target: Service.Ip
        function onUpdateListGateway(data) {
            const gatewayHostsList = []
            let isDefault = true
            for (const gateway of data) {
                gatewayHostsList.push({
                    name: '',
                    host: gateway,
                    isGateway: true,
                    isDefault: isDefault,
                })
                isDefault = false
            }
            root.gatewayHostsList = gatewayHostsList
        }
    }

    Instantiator {
        model: root.hostsList
        Scope {
            id: pinger

            required property var modelData
            readonly property string name: modelData.name
            readonly property string host: modelData.host

            Timer {
                id: startupTimer
                interval: 500
                running: true
                repeat: false
                onTriggered: pingProc.running = true
            }

            Process {
                id: pingProc
                property int lineNumber: 0
                property bool scheduledRestart: false
                command: ['ping', '-i', root.interval, pinger.host]
                running: false
                stderr: SplitParser {
                    splitMarker: "\n"
                    onRead: line => {
                        console.warn('[Services/Ping]', '[ping stderr]', line)
                    }
                }
                stdout: SplitParser {
                    splitMarker: "\n"
                    onRead: line => {
                        timeoutTimer.stop()
                        let errmsg = ''
                        const timePos = line.indexOf('time=')
                        if (timePos === -1) {
                            // skip the first line from ping's output as it is an output header
                            if (pingProc.lineNumber !== 0) {
                                errmsg = 'could not find "time=" in ping output'
                            }
                        } else {
                            let part = line.slice(timePos + 5)
                            const endPos = part.indexOf(' ')
                            if (endPos === -1) {
                                errmsg = 'could not find end of milliseconds'
                            } else {
                                part = part.slice(0, endPos)
                                part = part.replace(',', '.')
                                const value = Number.parseFloat(part)
                                if (!Number.isFinite(value)) {
                                    errmsg = `unable to parse float '${part}'`
                                } else {
                                    root.updateInfoPing(pinger.modelData, value)
                                }
                            }
                        }
                        if (errmsg !== '') {
                            console.error('[Services/Ping]', 'error while parse ping output:', errmsg, '; line:', line)
                            root.updateInfoPing(pinger.modelData, Infinity)
                        }
                        pingProc.lineNumber++
                        timeoutTimer.start()
                    }
                }
                // qmllint disable signal-handler-parameters
                onExited: (exitCode, _) => {
                // qmllint enable signal-handler-parameters
                    timeoutTimer.stop()
                    if (scheduledRestart) {
                        pingProc.scheduledRestart = false
                        pingProc.running = true
                    } else {
                        console.warn('[Services/Ping]', 'ping for', pinger.host, 'exited with code:', exitCode)
                        if (!restartTimer.running) {
                            console.log('[Services/Ping]', 'restart ping in 5 seconds...')
                            restartTimer.start()
                        }
                        root.updateInfoPing(pinger.modelData, Infinity)
                    }
                    lineNumber = 0
                }
            }

            // There seems to be a bug in Quickshell where long running processes eat up RAM.
            // In order to workaround this bug, we will restart service periodically.
            Timer {
                id: scheduledRestartTimer
                interval: 1000 * 60 * 60
                running: true
                repeat: true
                onTriggered: {
                    if (pingProc.running) {
                        pingProc.scheduledRestart = true
                        pingProc.running = false
                    }
                }
            }

            Timer {
                id: restartTimer
                interval: 5000
                running: false
                repeat: false
                onTriggered: pingProc.running = true
            }

            Timer {
                id: timeoutTimer
                interval: root.interval * 1000 + root.timeout
                running: false
                repeat: false
                onTriggered: {
                    console.warn('[Services/Ping]', 'timeout reached in ping for', pinger.host)
                    root.updateInfoPing(pinger.modelData, Infinity)
                }
            }

        }
    }

    onPingHostsListChanged: {
        root.updateListPing(root.pingHostsList)
    }

    onGatewayHostsListChanged: {
        root.updateListPingGateway(root.gatewayHostsList)
    }

}
