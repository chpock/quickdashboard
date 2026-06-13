//@ pragma AppId org.quickdashboard

pragma ComponentBehavior: Bound

import Quickshell
import qs.qd

import QtQuick

QuickDashboard {
    id: root

    // theme: "debug-theme.json"

    DashboardDefault {
        // screen: Quickshell.screens[0]
        screen: Quickshell.screens[0]
        align: Dashboard.AlignRight
    }

}
