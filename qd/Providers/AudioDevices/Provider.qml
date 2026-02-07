pragma ComponentBehavior: Bound

import Quickshell
import QtQuick
import Quickshell.Services.Pipewire

Scope {
    id: root

    readonly property PwNode sink: Pipewire.defaultAudioSink
    readonly property PwNode source: Pipewire.defaultAudioSource

    PwObjectTracker {
        objects: Pipewire.nodes.values.filter(node => node.audio && !node.isStream)
    }

}
