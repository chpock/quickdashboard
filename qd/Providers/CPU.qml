pragma ComponentBehavior: Bound
pragma Singleton

import Quickshell
import QtQuick
import qs.qd as QD

// This is required for quickshell hot reload to work.
// qmllint disable unused-imports
import qs.qd.Providers.CPU
// qmllint enable unused-imports

Singleton {

    property alias instance: loader.item

    Loader {
        id: loader

        source: 'CPU/' + (QD.Settings.isDemo ? 'Mock' : '') + 'Provider.qml'
    }
}
