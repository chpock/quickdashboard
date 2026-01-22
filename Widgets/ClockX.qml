pragma ComponentBehavior: Bound

import Quickshell
import QtQuick
import qs.Elements as E
import qs.Config as C

Base {
    id: root
    type: 'clock'
    hierarchy: ['base', type]

    component ConfigFragments: QtObject {

        readonly property C.Text hours: C.Text {
            _defaults: root._config.defaults.text
            font {
                size:   40
                weight: 'bold'
            }
            heightMode: 'capitals'
        }

        readonly property C.Text separator: C.Text {
            _defaults: root._config.defaults.text
            font {
                size: 40
            }
            padding {
                top:   -3
                left:  5
                right: 5
            }
            heightMode: 'capitals'
        }

        readonly property C.Text minutes: C.Text {
            _defaults: root._config.defaults.text
            font {
                size: 40
            }
            heightMode: 'capitals'
        }

    }

    configFragments: ConfigFragments {}

    Component {
        id: configFragmentsComponent
        ConfigFragments {}
    }

    function recreateConfigFragments() {
        configFragments = configFragmentsComponent.createObject(_config)
    }

    SystemClock {
        id: systemClock
        precision: SystemClock.Minutes
    }

    Item {
        id: clock

        readonly property var config: root._config.fragments

        implicitHeight: Math.max(hours.implicitHeight, separator.implicitHeight, minutes.implicitHeight)
        implicitWidth: hours.implicitWidth + separator.implicitWidth + minutes.implicitWidth
        anchors.horizontalCenter: parent.horizontalCenter

        E.TextX {
            id: hours
            theme: root._config.theme
            config: clock.config.hours

            text: Qt.formatDateTime(systemClock.date, "hh")
            anchors.left: parent.left
            anchors.top: parent.top
        }

        E.TextX {
            id: separator
            theme: root._config.theme
            config: clock.config.separator

            text: ':'
            anchors.left: hours.right
            anchors.top: parent.top
        }

        E.TextX {
            id: minutes
            theme: root._config.theme
            config: clock.config.minutes

            text: Qt.formatDateTime(systemClock.date, "mm")
            anchors.left: separator.right
            anchors.top: parent.top
        }

    }

}
