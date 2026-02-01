pragma ComponentBehavior: Bound

import QtQuick

Base {
    id: root

    property TextBytes _defaults

    readonly property TextFont font: TextFont {
        _defaults: root._defaults?.font ?? null
    }
    readonly property TextPadding padding: TextPadding {
        _defaults: root._defaults?.padding ?? null
    }
    readonly property TextAlignment alignment: TextAlignment {
        _defaults: root._defaults?.alignment ?? null
    }
    readonly property TextHover hover: TextHover {
        _defaults: root._defaults?.hover ?? null
    }
    property var word_spacing_font_family: _defaults?.word_spacing_font_family
    property var heightMode: _defaults?.heightMode
    property var color:      _defaults?.color
    property var background: _defaults?.background
    property var text:       _defaults?.text
    property var precision:  _defaults?.precision
    property var prefix:     _defaults?.prefix
}
