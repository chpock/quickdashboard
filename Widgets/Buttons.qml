pragma ComponentBehavior: Bound

import QtQuick
import Quickshell.Io
import qs.Elements as E
import qs.Config as C

Base {
    id: root
    type: 'buttons'
    hierarchy: ['base', type]

    component ConfigFragments: QtObject {

        readonly property C.Icon button: C.Icon {
            _defaults: root._config.defaults.icon
            color: 'white'
            hover {
                enabled: true
            }
            active {
                color: 'info/accent'
            }
        }

        readonly property C.Spacing spacing: C.Spacing {
            horizontal: 8
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

    property var buttons: []

    Row {
        anchors.left: parent.left
        anchors.right: parent.right
        spacing: root._config.fragments.spacing.horizontal

        Repeater {
            model: root.buttons

            Item {
                id: container
                required property var modelData

                implicitWidth: button.implicitWidth
                implicitHeight: button.implicitHeight

                E.Icon {
                    id: button
                    theme: root._config.theme
                    config: root._config.fragments.button

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

}
