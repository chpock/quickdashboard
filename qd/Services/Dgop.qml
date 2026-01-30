pragma ComponentBehavior: Bound
pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick
import '../utils.js' as Utils

Singleton {
    id: root

    signal available()

    property bool running: false

    property int activeRequests: 0
    property bool scheduledRestart: false
    property bool scheduledRestartInProgress: false
    property bool ready: running && !scheduledRestart

    readonly property var subscribers: QtObject {
        property int infoCPU: 0
        property int infoMemory: 0
        property int infoNetwork: 0
        property int infoDisk: 0
        property int infoMounts: 0
        property int processesByCPU: 0
        property int processesByRAM: 0
    }

    signal updateInfoCPU(var data)
    signal updateInfoMemory(var data)
    signal updateInfoNetwork(var data)
    signal updateInfoDisk(var data)
    signal updateInfoMounts(var data)
    signal updateProcessesByCPU(var data)
    signal updateProcessesByRAM(var data)

    // TODO: add ability to specify random port number by environment variable API_PORT.
    // Also, detect somehow that dgop failed to bind specified port and restart it with other port number.
    Process {
        id: dgopProc
        command: ["dgop", "server"]
        running: false

        // stderr: SplitParser {
        //     splitMarker: "\n"
        //     onRead: line => {
        //         console.log('[DGOP:stderr]', line)
        //     }
        // }
        //
        // stdout: SplitParser {
        //     splitMarker: "\n"
        //     onRead: line => {
        //         console.log('[DGOP:stdout]', line)
        //     }
        // }

        // qmllint disable signal-handler-parameters
        onExited: (exitCode, _) => {
        // qmllint enable signal-handler-parameters
            if (root.scheduledRestart) {
                // console.log('end: scheduled restart for dgop...')
                dgopProc.running = true
            } else {
                console.warn('dgop service exited with code:', exitCode)
                if (!restartTimer.running) {
                    console.log('restart dgop in 5 seconds...')
                    restartTimer.start()
                }
            }
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
            if (dgopProc.running) {
                root.scheduledRestart = true
                if (!root.activeRequests) {
                    // console.log('start: scheduled restart for dgop...')
                    root.scheduledRestartInProgress = true
                    dgopProc.running = false
                } else {
                    // console.log('start: scheduled (POSTPONED) restart for dgop...')
                }
            }
        }
    }

    Timer {
        id: restartTimer
        interval: 5000
        running: false
        repeat: false
        onTriggered: dgopProc.running = true
    }

    Timer {
        id: startupTimer
        interval: 500
        running: true
        repeat: false
        onTriggered: dgopProc.running = true
    }

    Timer {
        id: healthCheck
        interval: 500
        running: true
        repeat: true
        onTriggered: root.doHealthCheck()
    }

    Timer {
        id: infoCPU
        interval: 1000
        repeat: true
        running: root.running && root.subscribers.infoCPU > 0
        onTriggered: root.getInfoCPU()
    }

    Timer {
        id: infoMemory
        interval: 1000
        repeat: true
        running: root.running && root.subscribers.infoMemory > 0
        onTriggered: root.getInfoMemory()
    }

    Timer {
        id: infoNetwork
        interval: 1000
        repeat: true
        running: root.running && root.subscribers.infoNetwork > 0
        onTriggered: root.getInfoNetwork()
    }

    Timer {
        id: infoDisk
        interval: 1000
        repeat: true
        running: root.running && root.subscribers.infoDisk > 0
        onTriggered: root.getInfoDisk()
    }

    Timer {
        id: processesByCPU
        interval: 5000
        repeat: true
        running: root.running && root.subscribers.processesByCPU > 0
        onTriggered: root.getProcessesByCPU()
    }

    Timer {
        id: processesByRAM
        // Get the list of processes by RAM once every 10 seconds, as this is
        // an expensive operation.
        interval: 10000
        repeat: true
        running: root.running && root.subscribers.processesByRAM > 0
        onTriggered: root.getProcessesByRAM()
    }

    Timer {
        id: infoMounts
        interval: 10000
        repeat: true
        running: root.running && root.subscribers.infoMounts > 0
        onTriggered: root.getInfoMounts()
    }

    function triggerAll() {
        if (!root.ready) return
        if (subscribers.infoCPU > 0) getInfoCPU()
        if (subscribers.infoMemory > 0) getInfoMemory()
        if (subscribers.infoNetwork > 0) getInfoNetwork()
        if (subscribers.infoDisk > 0) getInfoDisk()
        if (subscribers.infoMounts > 0) getInfoMounts()
        if (subscribers.processesByCPU > 0) getProcessesByCPU()
        if (subscribers.processesByRAM > 0) getProcessesByRAM()
    }

    function subscribe(event) {
        ++root.subscribers[event]
    }

    function unsubscribe(event) {
        --root.subscribers[event]
    }

    function request(path, query, callback) {

        const xhr = new XMLHttpRequest()
        const silentErrors = path === '/health' && root.scheduledRestartInProgress

        xhr.onreadystatechange = function() {
            if(xhr.readyState !== XMLHttpRequest.DONE) return
            const responseText = xhr.responseText.toString()
            var processed = false
            if (xhr.status === 200) {
                try {
                    const response = responseText === "OK" ? responseText : JSON.parse(responseText)
                    try {
                        processed = true
                        callback(response)
                    }
                    catch (e) {
                        console.warn('Error in callback:', e, 'response:', responseText)
                    }
                }
                catch (e) {
                    console.warn('Unable to parse JSON from dgop response:', e, 'response:', responseText)
                }
            } else {
                if (!silentErrors) {
                    console.warn('HTTP request failed, status code:', xhr.status + '; response:', responseText)
                }
            }
            if (!processed) {
                try {
                    callback(null)
                }
                catch (e) {
                    console.warn('Error in callback:', e, 'response:', responseText)
                }
            }
            --root.activeRequests
        }

        var url = 'http://localhost:63484' + path
        if (query && Object.keys(query).length) {
            var parts = []
            for (var k in query) {
                var v = query[k]
                parts.push(encodeURIComponent(k) + "=" + encodeURIComponent(String(v)))
            }
            url += '?' + parts.join("&")
        }
        // console.log("Request URL", url)
        xhr.open('GET', url)

        xhr.send()
        ++root.activeRequests

        return {
            abort: function() { try { xhr.abort() } catch(e) {} }
        }

    }

    function doHealthCheck() {

        if (!dgopProc.running) {
            if (running && !scheduledRestart) running = false
            return
        }

        request('/health', {}, function(data) {
            if (data === "OK") {
                if (scheduledRestartInProgress) {
                    // console.log('Healthcheck: OK')
                    scheduledRestart = false
                    scheduledRestartInProgress = false
                }
                if (running) return
                running = true
                root.available()
                root.triggerAll()
            } else {
                if (!running || scheduledRestart) return
                running = false
            }
        })

    }

    property string cursorInfoCPU: ""
    function getInfoCPU() {
        if (!ready) return null
        return request('/gops/cpu', {
            'cursor': cursorInfoCPU,
        }, function(data) {
            if (!data) return
            cursorInfoCPU = data.data.cursor
            root.updateInfoCPU(data.data)
        })
    }

    // Disk rates in dgop is too spiky. Let's smooth them out by taking
    // the average of the last 3 measurements.
    property int avgWinSizeDiskRate: 3
    property var readAvgDiskRate: Utils.movingAverage(() => avgWinSizeDiskRate)
    property var writeAvgDiskRate: Utils.movingAverage(() => avgWinSizeDiskRate)
    property string cursorInfoDisk: ""
    function getInfoDisk() {
        if (!ready) return null
        return request('/gops/disk-rate', {
            'cursor': cursorInfoDisk,
        }, function(data) {
            if (!data) return
            cursorInfoDisk = data.cursor
            let readrate = 0
            let writerate = 0
            for (let i = 0; i < data.disks.length; ++i) {
                const diskData = data.disks[i]
                readrate += diskData.readrate
                writerate += diskData.writerate
            }
            root.updateInfoDisk({
                "readrate": readAvgDiskRate.push(Math.trunc(readrate)),
                "writerate": writeAvgDiskRate.push(Math.trunc(writerate)),
            })
        })
    }

    // Convert to bytes a string produced by this function:
    // https://github.com/AvengeMedia/dgop/blob/ae15dd44ae1c5f00cdbc6b405b468f58d860d277/gops/disk.go#L69
    function unformatBytes(val) {
        const units = "BKMGTPE"
        const lastChar = val[val.length - 1]
        const power = units.indexOf(lastChar)
        if (power === -1) {
            console.error("Unable to unformatBytes:", JSON.stringify(val))
            return 0
        }
        const numPart = val.slice(0, -1)
        const result = parseFloat(numPart)
        return Math.trunc(result * Math.pow(1024, power))
    }

    function getInfoMounts() {
        if (!ready) return null
        return request('/gops/disk/mounts', {}, function(data) {
            if (!data) return
            const callbackData = data.data.map(function(item) {
                return {
                    'device': item.device,
                    'mount':  item.mount,
                    'fstype': item.fstype,
                    "size":   root.unformatBytes(item.size),
                    "used":   root.unformatBytes(item.used),
                    "avail":  root.unformatBytes(item.avail),
                }
            })
            root.updateInfoMounts(callbackData)
        })
    }

    function getInfoMemory() {
        if (!ready) return null
        return request('/gops/memory', {}, function(data) {
            if (!data) return
            root.updateInfoMemory(data.data)
        })
    }

    function splitCommand(originalCommand, fullCommand) {
        if (fullCommand === '') {
            return [originalCommand, '', originalCommand]
        }
        let splitIdx = fullCommand.indexOf(' ')
        let commandRaw = (splitIdx === -1) ? fullCommand : fullCommand.slice(0, splitIdx)
        let args = (splitIdx === -1) ? '' : fullCommand.slice(splitIdx + 1)
        let command
        if (commandRaw === '/proc/self/exe') {
            command = originalCommand
        } else if (commandRaw.charAt(0) === '/') {
            splitIdx = commandRaw.lastIndexOf('/')
            command = splitIdx === -1 ? commandRaw : commandRaw.slice(splitIdx + 1)
        } else {
            command = commandRaw
        }
        return [command, args, commandRaw]
    }

    property string cursorProcessesByCPU: ""
    function getProcessesByCPU() {
        if (!ready) return null
        return request('/gops/processes', {
            cursor: cursorProcessesByCPU,
            sort_by: 'cpu',
            limit: 5,
            merge_children: true,
        }, function(data) {
            if (!data) return
            cursorProcessesByCPU = data.cursor
            const callbackData = data.data.filter(function(item) {
                return item.command !== 'dgop'
            }).map(function(item) {
                const splitCommand = root.splitCommand(item.command, item.fullCommand)
                return {
                    command: splitCommand[0],
                    args: splitCommand[1],
                    pid: item.pid,
                    value: item.cpu,
                }
            })
            root.updateProcessesByCPU(callbackData)
        })
    }

    property string cursorProcessesByRAM: ""
    function getProcessesByRAM() {
        if (!ready) return null
        return request('/gops/processes', {
            cursor: cursorProcessesByRAM,
            disable_proc_cpu: true,
            sort_by: 'memory',
            limit: 5,
            merge_children: true,
        }, function(data) {
            if (!data) return
            cursorProcessesByRAM = data.cursor
            const callbackData = data.data.map(function(item) {
                const splitCommand = root.splitCommand(item.command, item.fullCommand)
                return {
                    command: splitCommand[0],
                    args: splitCommand[1],
                    pid: item.pid,
                    value: item.memoryKB * 1024,
                }
            })
            root.updateProcessesByRAM(callbackData)
        })
    }

    property string cursorInfoNetwork: ""
    // Network rates in dgop is too spiky. Let's smooth them out by taking
    // the average of the last 3 measurements.
    property int avgWinSizeNetworkRate: 3
    property var rxAvgNetworkRate: Utils.movingAverage(() => avgWinSizeNetworkRate)
    property var txAvgNetworkRate: Utils.movingAverage(() => avgWinSizeNetworkRate)
    function getInfoNetwork(callback) {
        if (!ready) return null
        return request('/gops/net-rate', {
            'cursor': cursorInfoNetwork,
        }, function(data) {
            if (!data) return
            cursorInfoNetwork = data.cursor
            const callbackData = {
                rxrate: rxAvgNetworkRate.push(Math.trunc(data.interfaces[0].rxrate)),
                txrate: txAvgNetworkRate.push(Math.trunc(data.interfaces[0].txrate)),
            }
            root.updateInfoNetwork(callbackData)
        })
    }

    onActiveRequestsChanged: {
        if (scheduledRestart && !activeRequests && !scheduledRestartInProgress) {
            scheduledRestartInProgress = true
            dgopProc.running = false
            // console.log('start: scheduled REAL restart for dgop...')
        }
    }

}
