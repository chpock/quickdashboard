pragma ComponentBehavior: Bound

import QtQuick
import qs.Config as C

Base {
    id: root

    property C.Text _defaults

    enum HeightMode {
        HeightNormal = 0,
        HeightCapitals = 1,
        HeightContent = 2
    }

    enum Overflow {
        OverflowNone = 0,
        OverflowElide = 1,
        OverflowScroll = 2
    }

    readonly property TextFont font: TextFont {
        _defaults: root._defaults?.font ?? null
    }
    readonly property Padding padding: Padding {
        _defaults: root._defaults?.padding ?? null
    }
    readonly property TextScroll scroll: TextScroll {
        _defaults: root._defaults?.scroll ?? null
    }
    readonly property TextAlignment alignment: TextAlignment {
        _defaults: root._defaults?.alignment ?? null
    }
    readonly property TextHover hover: TextHover {
        _defaults: root._defaults?.hover ?? null
    }
    property var color:                 _defaults?.color
    property var background:            _defaults?.background
    property var overflow:              _defaults?.overflow
    property var heightMode:            _defaults?.heightMode
    property var word_spacing_font_family: _defaults?.word_spacing_font_family
    property var text:                  _defaults?.text

    readonly property int _overflow:
        overflow === 'none'   ? 0 :
        overflow === 'elide'  ? 1 :
        overflow === 'scroll' ? 2 :
        overflow

    readonly property int _heightMode:
        heightMode === 'normal'   ? 0 :
        heightMode === 'capitals' ? 1 :
        heightMode === 'content'  ? 2 :
        heightMode


    property var style
    default property list<C.Text> styles
    property bool _styles_loaded: false

    function getStyle(style) {
        for (var i = 0; i < styles.length; ++i) {
            if (styles[i].style === style) {
                return styles[i]
            }
        }
        return _defaults ? _defaults.getStyle(style) : null
    }

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
