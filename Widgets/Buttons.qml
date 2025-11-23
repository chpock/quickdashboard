pragma ComponentBehavior: Bound

import QtQuick
import Quickshell.Io
import qs
import qs.Elements as E

Base {
    id: root

    readonly property var theme: QtObject {
        property int spacing: 8
        property var color: QtObject {
            property color normal: Theme.palette.silver
            property color hover: Theme.palette.belizehole
            property color active: Theme.palette.sunflower
        }
    }

    property var buttons: [
        {
            icon: 'frame_inspect',
            command: 'T="$(mktemp)"; hyprprop >"$T" && alacritty -e fx "$T" || true; rm -f "$T"',
            detached: true,
        },
        {
            icon: 'draw_abstract',
            command: 'wayscriber --active',
        },
    ]


    Row {
        width: parent.width
        spacing: root.theme.spacing

        Repeater {
            model: root.buttons

            Item {
                id: button
                required property var modelData

                implicitWidth: icon.implicitWidth
                implicitHeight: icon.implicitHeight

                E.Icon {
                    id: icon
                    icon: button.modelData.icon
                    color:
                        iconHover.hovered
                            ? root.theme.color.hover
                            : process.running
                                ? root.theme.color.active
                                : root.theme.color.normal

                    HoverHandler {
                        id: iconHover
                        acceptedButtons: Qt.NoButton
                        cursorShape: Qt.PointingHandCursor
                    }
                    TapHandler {
                        onTapped: {
                            if (button.modelData.detached) {
                                process.startDetached()
                            } else {
                                process.running = true
                            }
                        }
                    }
                }

                Process {
                    id: process
                    running: false
                    command: ["sh", "-c", button.modelData.command]
                    // qmllint disable signal-handler-parameters
                    onExited: (exitCode, _) => {
                    // qmllint enable signal-handler-parameters
                        if (exitCode !== 0) {
                            console.warn('[Widgets/Buttons]', 'command exited with code:', exitCode,
                                '; command:', button.modelData.command)
                        }
                    }
                }
            }
        }

    }

}
