pragma ComponentBehavior: Bound

import QtQuick
import qs.qd.Config as C

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

    property var styles: _defaults?.styles
    readonly property var _styles: ({})

    property bool _styles_loaded: false

    function getStyle(style) {
        return _styles[style] ?? null
    }

    function generateStyles(styles: var, parent: var, parentName: string): void {

        if (!styles) {
            return
        }

        const styleComponent = Qt.createComponent("Text.qml")

        for (let styleName in styles) {

            const styleNameFull = parentName + styleName
            // console.log('create style:', styleNameFull)

            const styleObject = styleComponent.createObject(root, {
                _defaults: parent,
                styles: undefined,
            })

            const styleProperties = Object.assign({}, styles[styleName])
            delete styleProperties['styles']
            styleObject._custom = styleProperties

            _styles[styleNameFull] = styleObject

            generateStyles(styles[styleName].styles, styleObject, styleNameFull + '/')

        }

    }

    function cleanupStyles(): void {
        for (const styleName in _styles) {
            _styles[styleName].destroy()
            delete _styles[styleName]
        }
    }

    Component.onCompleted: {
        cleanupStyles()
        generateStyles(styles, root, '')
        _styles_loaded = true
    }

    Component.onDestruction: {
        cleanupStyles()
    }

}
