/*
    This file is a part of quickdashboard: https://github.com/chpock/quickdashboard

    Copyright (C) 2025-2026 Kostiantyn Kushnir <chpock@gmail.com>

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <https://www.gnu.org/licenses/>.
*/

pragma ComponentBehavior: Bound

import QtQuick
import Quickshell.Io
import qs.qd.Elements as E
import qs.qd.Widgets as Widget

Widget.Base {
    id: root

    _fragments: Fragments {
        _defaults: Defaults {
            widget: root
        }
        _custom: root.fragments
        _chain: (root._chain ? root._chain + '.' : '') + root.type + '.fragments'
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

}
