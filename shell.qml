pragma ComponentBehavior: Bound

import Quickshell
import qs.Widgets as W

ShellRoot {

    id: root

    W.Dashboard {

        screen: Quickshell.screens[0]

        align: W.Dashboard.AlignRight

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
        }

        W.AudioVolume {
        }

        W.Clock {
        }

    }

}
