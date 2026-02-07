pragma ComponentBehavior: Bound

import qs.qd.Widgets as W
import qs.qd
import QtQuick

Dashboard {

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
        id: b

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
