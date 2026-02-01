pragma ComponentBehavior: Bound

import QtQuick

QtObject {
    id: root

    property var _custom
    property string _chain
    property bool _is_customized: false

    function _reset() {

        function reportWrongCustom(message: string, prop: string) {
            console.error(message + ':', _chain + '.' + prop + ':', JSON.stringify(_custom[prop]))
        }

        function reportWrongCustomType(prop: string, typeActual: string, typeExpected: string) {
            reportWrongCustom(`The property has invalid type '${typeActual}'` +
                ` where '${typeExpected}' is expected`, prop)
        }

        function validateStyles(targetStyles: var, customStyles: var, parentName: string): var {
            const returnStyles = {}
            for (const styleName in customStyles) {

                const styleNameFull = parentName + styleName

                if (!targetStyles.hasOwnProperty(styleName)) {
                    const knownStyles = Object.keys(targetStyles)
                    const errmsg =
                        'known style name' +
                        (
                            knownStyles.length === 1
                                ? " is '" + knownStyles[0] + "'"
                                : knownStyles.length === 2
                                    ? "s are '" + knownStyles[0] + "' and '" + knownStyles[1] + "'"
                                    : "s are '" + knownStyles.slice(0, -1).join("', '") + "' and '" + knownStyles[knownStyles.length - 1] + "'"
                        )
                    reportWrongCustom(`Unknown style name '${styleNameFull}', ${errmsg}`, 'styles')
                    continue
                }

                const styleObject = customStyles[styleName]
                const resultStyleObject = Object.assign({}, styleObject)
                const childrenStyles = styleObject.styles

                if (styleObject.hasOwnProperty('styles')) {

                    delete resultStyleObject['styles']

                    const childrenStyles = styleObject.styles
                    if (childrenStyles !== undefined && childrenStyles !== null) {

                        if (!targetStyles[styleName].hasOwnProperty('styles')) {
                            reportWrongCustom(`Style '${styleNameFull}' has unexpected children styles`, 'styles')
                        } else if (typeof childrenStyles !== 'object' || Array.isArray(childrenStyles)) {
                            reportWrongCustom(`Style '${styleNameFull}' has children styles as not an object`, 'styles')
                        } else {
                            const resultChildrenStyles = validateStyles(targetStyles[styleName].styles, childrenStyles, styleNameFull + '/')
                            if (Object.keys(resultChildrenStyles)) {
                                resultStyleObject.styles = resultChildrenStyles
                            }
                        }
                    }
                }

                returnStyles[styleName] = resultStyleObject

            }
            return returnStyles
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
                if (prop === 'styles') {
                    const key = '_styles_custom'
                    if (Object.keys(root[key]).length === 0) {
                        // console.log('Reset property to defaults (don\'t touch):', prop)
                    } else {
                        console.log('Reset styles to defaults:', prop)
                        root[key] = {}
                    }
                } else {
                    // console.log('Reset property to defaults:', prop)
                    const def = '_defaults'
                    root[prop] = Qt.binding(function() { return root[def] ? root[def][prop] : undefined })
                }
                continue
            }

            if (prop === 'styles') {
                if (customType !== 'object') {
                    reportWrongCustomType(prop, customType, 'object')
                    continue
                }
                // console.log("styles:", targetValue, typeof targetValue, root)
                if (!targetValue) {
                    reportWrongCustom('Unable to apply styles, this object has no styles defined', prop)
                    continue
                }
                // applyStyles(targetValue, customValue)
                const key = '_styles_custom'
                root[key] = validateStyles(targetValue, customValue, '')
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
        if (!_is_customized && isCustomEmpty) {
            return
        }
        // console.log("Custom changed on:", root, !(!_custom), typeof _custom)
        _reset()
        _is_customized = !isCustomEmpty
    }

}
