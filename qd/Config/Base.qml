pragma ComponentBehavior: Bound

import QtQuick

QtObject {
    id: root

    property var _custom
    property string _chain
    property bool _isCustomized: false

    function _reset() {

        function reportWrongCustom(message: string, prop: string) {
            console.error(message + ':', _chain + '.' + prop + ':', JSON.stringify(_custom[prop]))
        }

        function reportWrongCustomType(prop: string, typeActual: string, typeExpected: string) {
            reportWrongCustom(`The property has invalid type '${typeActual}'` +
                ` where '${typeExpected}' is expected`, prop)
        }

        function applyStyles(targetStyles: var, customStyles: var) {

            const targetStylesMap = {}
            for (let i = 0; i < targetStyles.length; ++i) {
                const style = targetStyles[i]
                targetStylesMap[style.style] = style
            }

            const customStylesMap = {}
            for (let i = 0; i < customStyles.length; ++i) {

                const styleValue = customStyles[i]
                const styleType = Array.isArray(styleValue) ? 'array' : typeof styleValue

                if (styleType !== 'object') {
                    console.error(`The style has invalid type '${styleType}'` +
                        " where 'object' is expected:", _chain + '.styles[' + i + ']')
                    continue
                }

                if (!styleValue.hasOwnProperty('style')) {
                    console.error("The style does not have a mandatory property 'style':",
                        _chain + '.styles[' + i + ']')
                    continue
                }

                const styleName = styleValue.style
                const styleNameType = Array.isArray(styleName) ? 'array' : typeof styleName

                if (styleNameType !== 'string') {
                    console.error("The 'style' property of the style has invalid type" +
                        ` '${styleNameType}' where 'string' is expected:`,
                        _chain + '.styles[' + i + '].style:', JSON.stringify(styleName))
                    continue
                }

                if (!targetStylesMap.hasOwnProperty(styleName)) {
                    const knownStyleNamesList = Object.keys(targetStylesMap)
                    const knownStyleNamesText =
                        'known style name' +
                        (
                            knownStyleNamesList.length === 1
                                ? `is '${knownStyleNamesList[0]}'`
                                : `are '${knownStyleNamesList.join("', '")}'`
                        )
                    console.error("The 'style' property in the style object has unknown style name,",
                        knownStyleNamesText, _chain + '.styles[' + i + '].style:', JSON.stringify(styleName))
                    continue
                }

                customStylesMap[styleName] = styleValue

            }

        }

        // console.log('Start reset on:', root, 'chain:', _chain)

        if (_custom) {
            for (const prop in _custom) {
                if (prop === 'objectName' || prop.startsWith('_') || prop.endsWith('Changed')) {
                    reportWrongCustom('Unsuported property found', prop)
                } else if (!root.hasOwnProperty(prop)) {
                    reportWrongCustom('Unknown property found', prop)
                }
            }
        }

        for (const prop in root) {

            if (prop === 'objectName' || prop.startsWith('_') || prop.endsWith('Changed')) continue

            const targetValue = root[prop]
            const targetType = Array.isArray(targetValue) ? 'array' : typeof targetValue
            const customValue = _custom?.[prop]
            const hasCustom = customValue !== undefined && customValue !== null
            const customType = Array.isArray(customValue) ? 'array' : typeof customValue

            if (targetType === 'function') {
                if (hasCustom) {
                    reportWrongCustom('Unsuported property found', prop)
                }
                continue
            }

            if (targetType === 'object' && targetValue.hasOwnProperty('_custom') && targetValue.hasOwnProperty('_chain')) {
                // console.log('Call _reset on:', targetValue)
                targetValue._chain = _chain + '.' + prop
                if (hasCustom && customType !== 'object') {
                    reportWrongCustomType(prop, customType, 'object')
                    targetValue._custom = undefined
                } else {
                    targetValue._custom = customValue
                }
                continue
            }

            if (!hasCustom) {
                if (prop === 'style' || prop === 'styles') {
                    // console.log('Reset property to defaults (don\'t touch):', prop)
                } else {
                    // console.log('Reset property to defaults:', prop)
                    const def = '_defaults'
                    root[prop] = Qt.binding(function() { return root[def] ? root[def][prop] : undefined })
                }
                continue
            }

            if (prop === 'styles') {
                if (customType !== 'array') {
                    reportWrongCustomType(prop, customType, 'array')
                    continue
                }
                console.log("styles:", targetValue, typeof targetValue, root)
                if (!targetValue.styles) {
                    reportWrongCustom('Unable to apply styles, this object has no styles defined', prop)
                    continue
                }
                applyStyles(targetValue, customValue)
                continue
            }

            if (customType !== targetType) {
                reportWrongCustomType(prop, customType, targetType)
                continue
            }

            // console.log('Set custom value for prop:', prop, 'type:', targetType, 'value:', JSON.stringify(customValue))
            root[prop] = customValue
        }

        // console.log('End reset on:', root)

    }

    on_CustomChanged: {
        let isCustomEmpty = !_custom || (typeof _custom === 'object' && Object.keys(_custom).length === 0)
        if (!_isCustomized && isCustomEmpty) {
            return
        }
        // console.log("Custom changed on:", root, !(!_custom), typeof _custom)
        _reset()
        _isCustomized = !isCustomEmpty
    }

}
