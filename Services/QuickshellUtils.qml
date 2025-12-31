pragma ComponentBehavior: Bound
pragma Singleton

import Quickshell
import Quickshell.Wayland
import QtQuick

// Dashboards should be anchored to the left or right edge. Usually, dashboards
// also occupy the entire height. However, there may be other panels or bars
// on the screen. These other panels should be taken into account and given
// higher priority than dashboards.
//
// Unfortunately, Quickshell does not have a concept of priorities.
// The window that appears/loads first will occupy the entire height/width.
//
// In order to emulate priorities in some way, we create a full-screen window here.
// When new panels appear, the size of this window will change. We will catch
// this event and restart the dashboards so that they give up their occupied
// space and recalculate their position taking into account the new panels
// that have appeared.
//
// But this invisible window will react to attempts by the dashboards themselves
// to take up space on the screen. So we try to use magic here and detect
// that the size change was related to the appearance of a dashboard,
// not an external panel. In this case, we will not restart the dashboards.

Singleton {
    id: root

    property var usedScreens: ({})

    function registerDelta(type, screen, delta) {
        watchers.instances.forEach(watcher => {
            if (watcher.screen.name === screen) {
                watcher.delta[type] = watcher.delta[type] + delta
                // console.log("Register delta:", type, screen, delta, "new delta:", watcher.delta[type])
            }
        })
        root.usedScreens[screen] = 1
    }

    Variants {
        id: watchers

        model: Quickshell.screens

        PanelWindow {

            id: watcher

            property var modelData
            screen: modelData

            property var delta: ({
                width: 0,
                height: 0
            })
            property var previous: ({
                width: -1,
                height: -1,
            })

            WlrLayershell.layer: WlrLayer.Background
            exclusionMode: ExclusionMode.Normal

            anchors {
                left: true
                right: true
                top: true
                bottom: true
            }

            color: 'transparent'

            onHeightChanged: {
                if (height) {
                    if (previous.height === -1) {
                        // console.log("H loaded:", height)
                        previous.height = height
                    } else if (previous.height !== height) {
                        if (height - previous.height === delta.height) {
                            // console.log("H supressed(by known delta):", height, "delta:", height - previous.height, "have delta:", delta.height)
                            delta.width = 0
                        } else if (!root.usedScreens.hasOwnProperty(screen.name)) {
                            // console.log("H supressed(no screen):", height, "delta:", height - previous.height, "have delta:", delta.height)
                            delta.width = 0
                        } else {
                            reloadTimer.restart()
                            // console.log("H triggered:", height, "delta:", height - previous.height, "have delta:", delta.height)
                        }
                        previous.height = height
                        delta.height = 0
                    } else {
                        // console.log("H same:", height)
                    }
                } else {
                    // console.log("H zero:", height)
                }
            }

            onWidthChanged: {
                if (width) {
                    if (previous.width === -1) {
                        // console.log("W loaded:", width)
                        previous.width = width
                    } else if (previous.width !== width) {
                        if (width - previous.width === delta.width) {
                            // console.log("W supressed(by known delta):", width, "delta:", width - previous.width, "have delta:", delta.width)
                            delta.height = 0
                        } else if (!root.usedScreens.hasOwnProperty(screen.name)) {
                            // console.log("W supressed(by screen):", width, "delta:", width - previous.width, "have delta:", delta.width)
                            delta.height = 0
                        } else {
                            reloadTimer.restart()
                            // console.log("W triggered:", width, "delta:", width - previous.width, "have delta:", delta.width)
                        }
                        previous.width = width
                        delta.width = 0
                    } else {
                        // console.log("W same:", width)
                    }
                } else {
                    // console.log("W zero:", width)
                }
            }
        }

    }

    Timer {
        id: reloadTimer
        interval: 500
        running: false
        repeat: false
        onTriggered: {
            Quickshell.reload(true)
        }
    }

    // Connections {
    //     target: Quickshell
    //     function onReloadCompleted() {
    //         console.log("reload completed")
    //     }
    // }

}
