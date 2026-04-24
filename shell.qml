pragma ComponentBehavior: Bound

import Quickshell
import qs.qd

import QtQuick

QuickDashboard {
    id: root

    // theme: "debug-theme.json"

    DashboardMain {
        // screen: Quickshell.screens[0]
        screen: Quickshell.screens[0]
        align: Dashboard.AlignRight
    }

}
