pragma ComponentBehavior: Bound

import QtQuick
import Quickshell.Io
import qs.Elements as E
import qs.Widgets as Widget

Widget.Base {
    id: root
    type: 'buttons'
    hierarchy: ['base', type]

    _fragments: Fragments {
        _defaults: Defaults {
            widget: root
        }
    }

    property var buttons: []

    Row {
        anchors.left: parent.left
        anchors.right: parent.right
        spacing: root._fragments.spacing.horizontal

        Repeater {
            model: root.buttons

            Item {
                id: container
                required property var modelData

                implicitWidth: button.implicitWidth
                implicitHeight: button.implicitHeight

                E.Icon {
                    id: button
                    theme: root._theme
                    config: root._fragments.button

                    icon: container.modelData.icon
                    isActive: process.running

                    onClicked: {
                        if (container.modelData.detached) {
                            process.startDetached()
                        } else {
                            process.running = true
                        }
                    }
                }

                Process {
                    id: process
                    running: false
                    command: ["sh", "-c", container.modelData.command]
                    // qmllint disable signal-handler-parameters
                    onExited: (exitCode, _) => {
                    // qmllint enable signal-handler-parameters
                        if (exitCode !== 0) {
                            console.warn('[Widgets/Buttons]', 'command exited with code:', exitCode,
                                '; command:', container.modelData.command)
                        }
                    }
                }
            }
        }

    }

    // Timer {
    //     id: testTimer
    //     interval: 3000
    //     running: true
    //     repeat: false
    //     onTriggered: {
    //         root._config._reset()
    //     }
    // }

}
