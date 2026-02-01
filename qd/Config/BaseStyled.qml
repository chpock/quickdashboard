pragma ComponentBehavior: Bound

import QtQuick

Base {
    id: root

    // property var styles: _defaults?.styles
    property var styles
    readonly property var _styles: ({})
    property var _styles_custom: ({})
    property var _style_component

    property bool _styles_loaded: false

    function getStyle(style) {
        return _styles[style] ?? null
    }

    function getStyleComponent() {
        return null
    }

    function mergeStyles(target: var, source: var): var {
        // console.log('Merge', JSON.stringify(target), 'with', JSON.stringify(source))
        if (source) {
            for (const key in source) {

                if (key === 'styles') {
                    continue
                }

                const value = source[key]

                if (value !== null && typeof value === 'object' && !Array.isArray(value)) {
                    if (!target.hasOwnProperty(key)) {
                        target[key] = {}
                    }
                    mergeStyles(target[key], value)
                } else {
                    target[key] = value
                }
            }
        }
        return target
    }

    function generateStyles(styles: var, parent: var, parentName: string): void {
        for (const styleName in styles) {

            const styleNameFull = parentName + styleName

            const styleObject = _style_component.createObject(root, {
                _defaults: parent,
                styles: undefined,
            })

            _styles[styleNameFull] = styleObject

            if (styles[styleName].styles) {
                generateStyles(styles[styleName].styles, styleObject, styleNameFull + '/')
            }

        }
    }

    function updateStyles(styles: var, _styles_custom: var, parent: var, parentName: string): void {
        for (const styleName in styles) {

            const styleNameFull = parentName + styleName
            const styleObject = _styles[styleNameFull]

            const stylePropertiesCustom = _styles_custom?.[styleName]

            const styleProperties = Object.assign({}, styles[styleName])
            delete styleProperties['styles']
            styleObject._custom = mergeStyles(styleProperties, stylePropertiesCustom)

            if (styles[styleName].styles) {
                updateStyles(styles[styleName].styles, stylePropertiesCustom?.styles, styleObject, styleNameFull + '/')
            }

        }

    }

    on_Styles_customChanged: {
        if (!_styles_loaded) {
            return
        }
        if (styles) {
            updateStyles(styles, _styles_custom, root, '')
        }
    }

    function cleanupStyles(): void {
        for (const styleName in _styles) {
            _styles[styleName].destroy()
            delete _styles[styleName]
        }
    }

    Component.onCompleted: {
        if (styles) {
            cleanupStyles()
            if (!_style_component) {
                _style_component = getStyleComponent()
            }
            generateStyles(styles, root, '')
            updateStyles(styles, _styles_custom, root, '')
        }
        _styles_loaded = true
    }

    Component.onDestruction: {
        cleanupStyles()
    }

}
