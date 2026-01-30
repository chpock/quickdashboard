pragma ComponentBehavior: Bound

import QtQuick
import qs.qd.Elements as E
import qs.qd.Providers as P
import qs.qd.Widgets as Widget

Widget.Base {
    id: root
    type: 'clock'
    hierarchy: ['base', type]

    _fragments: Fragments {
        _defaults: Defaults {
            widget: root
        }
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

            text: Qt.formatDateTime(P.SystemClock.dateMinutes, "hh")
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

            text: Qt.formatDateTime(P.SystemClock.dateMinutes, "mm")
            anchors.left: separator.right
            anchors.top: parent.top
        }

    }

}
