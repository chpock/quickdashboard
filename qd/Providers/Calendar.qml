pragma ComponentBehavior: Bound
pragma Singleton

import Quickshell
import QtQuick

// This is required for quickshell hot reload to work.
// qmllint disable unused-imports
import qs.qd.Providers.Calendar
// qmllint enable unused-imports

Singleton {

    property alias instance: loader.item

    Loader {
        id: loader

        source: "Calendar/Provider.qml"
    }
}
