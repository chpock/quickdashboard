pragma ComponentBehavior: Bound

import QtQuick

Base {
    property TextAlignment _defaults

    property var horizontal: _defaults?.horizontal
    property var vertical:   _defaults?.vertical

    readonly property var _horizontal:
        horizontal === 'left'    ? Text.AlignLeft    :
        horizontal === 'center'  ? Text.AlignHCenter :
        horizontal === 'right'   ? Text.AlignRight   :
        horizontal === 'justify' ? Text.AlignJustify :
        horizontal

    readonly property var _vertical:
        vertical === 'top'    ? Text.AlignTop     :
        vertical === 'center' ? Text.AlignVCenter :
        vertical === 'bottom' ? Text.AlignBottom  :
        vertical
}
