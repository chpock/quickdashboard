pragma ComponentBehavior: Bound

import QtQuick

QtObject {
    id: root

    property Icon _defaults

    readonly property TextFont font: TextFont {
        _defaults: root._defaults?.font ?? null
    }
    readonly property Padding padding: Padding {
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

    property var style
    default property list<Icon> styles
    property bool _styles_loaded: false

    Component.onCompleted: {
        if (styles.length) {
            const styleMap = {}
            for (let i = 0; i < styles.length; i++) {
                styleMap[styles[i].style] = i
            }
            for (let i = 0; i < styles.length; i++) {
                const styleObj = styles[i]
                const styleName = styleObj.style
                const idx = styleName.lastIndexOf("/")
                if (idx != -1) {
                    const parentStyle = styleName.substring(0, idx)
                    if (parentStyle in styleMap) {
                        styleObj._defaults = styles[styleMap[parentStyle]]
                        continue
                    }
                }
                styleObj._defaults = root
            }
        }
        _styles_loaded = true
    }
}
