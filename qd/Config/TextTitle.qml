pragma ComponentBehavior: Bound

import QtQuick

Base {
    id: root

    property TextTitle _defaults

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
    readonly property TextTitleSeparator separator: TextTitleSeparator {
        _defaults: root._defaults?.separator ?? null
    }
    property var color:                 _defaults?.color
    property var background:            _defaults?.background
    property var heightMode:            _defaults?.heightMode
    property var word_spacing_font_family: _defaults?.word_spacing_font_family
    property var text:                  _defaults?.text
}
