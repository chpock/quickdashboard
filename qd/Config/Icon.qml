pragma ComponentBehavior: Bound

import QtQuick

BaseStyled {
    id: root

    property Icon _defaults

    readonly property TextFont font: TextFont {
        _defaults: root._defaults?.font ?? null
    }
    readonly property TextPadding padding: TextPadding {
        _defaults: root._defaults?.padding ?? null
    }
    readonly property IconHover hover: IconHover {
        _defaults: root._defaults?.hover ?? null
    }
    readonly property IconActive active: IconActive {
        _defaults: root._defaults?.active ?? null
    }
    property var word_spacing_font_family: _defaults?.word_spacing_font_family
    property var color:       _defaults?.color
    property var background:  _defaults?.background
    property var filled:      _defaults?.filled
    property var grade:       _defaults?.grade
    property var weight:      _defaults?.weight
    property var opticalSize: _defaults?.opticalSize

    styles: _defaults?.styles

    function getStyleComponent() {
        return Qt.createComponent("Icon.qml")
    }

}
