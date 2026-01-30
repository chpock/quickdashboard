pragma ComponentBehavior: Bound

import Quickshell
import qs.qd.Widgets as W
import qs.qd

import QtQuick
// import Qt.labs.folderlistmodel
// import Quickshell.Io


ShellRoot {

    id: root

    Dashboard {

        // screen: Quickshell.screens[0]
        screen: Quickshell.screens[0]

        align: Dashboard.AlignRight

        W.Calendar {
        }

        W.Memory {
        }

        W.CPU {
        }

        W.Network {
        }

        W.Disk {
        }

        W.Media {
        }

        W.Separator {
        }

        W.Buttons {

            // fragments: ({
            //     button: {
            //         hover: {
            //             color: 'red',
            //         },
            //         color: 'green',
            //     },
            // })

            buttons: [
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

        }

        W.AudioVolume {
        }

        W.Clock {
        }

    }

    // FolderListModel {
    //     id: systemWatcher
    //     showDirs: false
    //     showFiles: true
    //     showDotAndDotDot: false
    //     nameFilters: ['*.qml']
    //     // folder: 'file://home/kot/test-qs'
    //     folder: 'file:///home/kot/test-qs'
    //     showOnlyReadable: true
    //
    //     onCountChanged: {
    //         console.log('folder count:', count)
    //     }
    //
    //     onStatusChanged: console.log('status changed')
    //     // onCountChanged: resyncDebounce.restart()
    //     // onStatusChanged: {
    //     //     if (status === FolderListModel.Ready)
    //     //         resyncDebounce.restart();
    //     // }
    // }

    // FolderListModel {
    //     id: systemWatcher
    //     showDirs: false
    //     showFiles: true
    //     showDotAndDotDot: false
    //     nameFilters: ['*.qml']
    //     folder: 'file:///home/kot/test-qs'
    //     showOnlyReadable: true
    // }
    //
    // Instantiator {
    //     model: systemWatcher
    //
    //     Loader {
    //         id: loader
    //
    //         required property var modelData
    //         // source: modelData.fileUrl + "?reload=" + Date.now()
    //         // source: modelData.fileUrl + "?refresh=" + modelData.fileModified.getTime()
    //         source: modelData.fileUrl
    //
    //         // readonly property var something: {
    //         //     console.log("modified:", JSON.stringify(modelData.fileModified))
    //         // }
    //         //
    //         // readonly property var lastModified: modelData.fileModified
    //         //
    //         // onLastModifiedChanged: {
    //         //     console.log("Файл изменился на диске:", modelData.fileName)
    //         // }
    //         //
    //         // Connections {
    //         //     target: parent.modelData
    //         //     function onFileModifiedChanged() {
    //         //         console.log("bar")
    //         //     }
    //         // }
    //
    //         FileView {
    //             id: afile
    //             path: loader.modelData.filePath
    //             watchChanges: true
    //             blockLoading: false
    //             onFileChanged: {
    //                 console.log("Файл изменился на диске:", loader.modelData.fileName)
    //                 loader.source = loader.modelData.fileUrl + "?reload=" + Date.now()
    //             }
    //         }
    //
    //         // Timer {
    //         //     id: checkTimer
    //         //     interval: 1000 * 10
    //         //     running: true
    //         //     repeat: true
    //         //     onTriggered: {
    //         //         console.log("File:", JSON.stringify([parent.modelData.fileUrl, parent.modelData.fileModified]))
    //         //     }
    //         // }
    //
    //         // readonly property string filePath: modelData.fileUrl.toString().replace("file://", "")
    //         //
    //         // FileSystemWatcher {
    //         //     paths: [parent.filePath]
    //         //
    //         //     onFileChanged: {
    //         //         console.log("File changed, reloading: " + path);
    //         //
    //         //         // // To force a reload, clear the source and reset it
    //         //         // let currentSource = panelLoader.source;
    //         //         // panelLoader.source = "";
    //         //         //
    //         //         // // Use a Timer or nextTick to ensure the engine registers the clear
    //         //         // Qt.callLater(() => {
    //         //         //     panelLoader.source = currentSource;
    //         //         // });
    //         //     }
    //         // }
    //     }
    // }

    // Variants {
    //     model: systemWatcher
    //
    //     Loader {
    //         required property var modelData
    //         source: modelData.fileUrl
    //     }
    // }
    // Repeater {
    //     model: systemWatcher
    //
    //     Loader {
    //         required property var modelData
    //         source: modelData.fileUrl
    //     }
    // }


    // Loader {
    //     source: 'file://home/kot/test-qs/shell.qml'
    // }

}
