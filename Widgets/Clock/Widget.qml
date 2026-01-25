pragma ComponentBehavior: Bound

import Quickshell
import QtQuick
import qs.Elements as E
import qs.Widgets as Widget

Widget.Base {
    id: root
    type: 'clock'
    hierarchy: ['base', type]

    _fragments: Fragments {
        _defaults: Defaults {
            widget: root
        }
    }

    // This is a hack to fix a bug in quickshell where SystemClock with
    // SystemClock.Minutes/SystemClock.Hours resolution does not update when
    // exiting from suspended state and remains as the old value for some time.
    SystemClock {
        id: systemClockSync
        precision: SystemClock.Seconds
        onMinutesChanged: {
            systemClock.precision =
                systemClock.enabled && systemClockSync.minutes !== systemClock.minutes
                    ? SystemClock.Seconds
                    : SystemClock.Minutes
        }
    }

    SystemClock {
        id: systemClock
        precision: SystemClock.Minutes
    }

    Item {
        id: clock

        readonly property var config: root._fragments

        implicitHeight: Math.max(hours.implicitHeight, separator.implicitHeight, minutes.implicitHeight)
        implicitWidth: hours.implicitWidth + separator.implicitWidth + minutes.implicitWidth
        anchors.horizontalCenter: parent.horizontalCenter

        E.Text {
            id: hours
            theme: root._theme
            config: clock.config.hours

            text: Qt.formatDateTime(systemClock.date, "hh")
            anchors.left: parent.left
            anchors.top: parent.top
        }

        E.Text {
            id: separator
            theme: root._theme
            config: clock.config.separator

            text: ':'
            anchors.left: hours.right
            anchors.top: parent.top
        }

        E.Text {
            id: minutes
            theme: root._theme
            config: clock.config.minutes

            text: Qt.formatDateTime(systemClock.date, "mm")
            anchors.left: separator.right
            anchors.top: parent.top
        }

    }

}
