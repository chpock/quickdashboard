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
pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: root

    // This host has 10 seconds TTL. See:
    //     https://digwebinterface.com/?hostnames=host.ping-us-east-1.prod.ring.net.&type=&ns=resolver&useresolver=1.1.1.1&nameservers=ns-1599.awsdns-07.co.uk.
    // Thus, we can be sure that it should be renewed each 10 seconds.
    // This way, we can attempt DNS resolution every 12 seconds, and be sure that
    // a new DNS resolution is being performed, rather than returning a previously
    // resolved value from the cache. Some domains and their TTL can be found here:
    //     https://gist.github.com/jpmens/29950104b066e7eeda7aabf9ef4f7706
    // However, this list is too old and many domains currently have another TTL values.
    property string dnsCheckHost: 'host.ping-us-east-1.prod.ring.net.'
    // See the comment about about choosen interval
    property int dnsCheckInterval: 12000
    property int dnsCheckTimeout: 10000

    property real dnsCheckTime: Infinity

    function dnsCheckRun() {
        if (dnsCheckProc.running) return
        dnsCheckElapsedTimer.restartMs()
        dnsCheckProc.running = true
        dnsCheckTimeoutTimer.restart()
    }

    Timer {
        id: dnsCheckStartupTimer
        interval: 500
        running: true
        repeat: false
        onTriggered: root.dnsCheckRun()
    }

    Process {
        id: dnsCheckProc
        property real time: Infinity
        command: ['getent', 'hosts', root.dnsCheckHost]
        running: false
        stderr: SplitParser {
            splitMarker: "\n"
            onRead: line => {
                console.warn('[Services/Getent@dnsCheckProc]', '[getent stderr]', line)
            }
        }
        stdout: SplitParser {
            splitMarker: "\n"
            onRead: line => {
                // We got our new line. Let's capture this moment.
                if (Number.isFinite(dnsCheckProc.time)) return
                dnsCheckProc.time = dnsCheckElapsedTimer.elapsedMs()
            }
        }
        // qmllint disable signal-handler-parameters
        onExited: (exitCode, _) => {
        // qmllint enable signal-handler-parameters
            dnsCheckTimeoutTimer.stop()
            if (exitCode !== 0) {
                console.warn('[Services/Getent@dnsCheckProc]', 'exited with code:', exitCode)
                dnsCheckProc.time = Infinity
            }
            root.dnsCheckTime = dnsCheckProc.time
            dnsCheckProc.time = Infinity
            dnsCheckRestartTimer.start()
        }
    }

    ElapsedTimer {
        id: dnsCheckElapsedTimer
    }

    Timer {
        id: dnsCheckRestartTimer
        interval: root.dnsCheckInterval
        running: false
        repeat: false
        onTriggered: root.dnsCheckRun()
    }

    Timer {
        id: dnsCheckTimeoutTimer
        interval: root.dnsCheckTimeout
        running: false
        repeat: false
        onTriggered: {
            console.warn('[Services/Getent@dnsCheckTimeoutTimer]', 'timeout reached')
            root.dnsCheckTime = Infinity
        }
    }

}
