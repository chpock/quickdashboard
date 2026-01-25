pragma ComponentBehavior: Bound

import QtQuick

QtObject {
    id: root

    function _reset() {
        // for (var prop in defaults) {
        //     // Skip standard QtObject property (objectName), our internal properties
        //     // (starts with '_') or events (ends with 'Changed')
        //     if (prop === 'objectName' || prop.startsWith('_') || prop.endsWith('Changed')) continue
        //
        //     let targetValue = target[prop]
        //     const targetType = typeof targetValue
        //
        //     // Skip functions
        //     if (targetType === 'function') continue
        //
        //     if (targetType === 'object') {
        //         // console.log("found nested:", prop, typeof targetValue, targetValue.toString())
        //         withDefaults(defaults[prop], target[prop])
        //     } else if (targetType === 'undefined') {
        //         target[prop] = Qt.binding(function() { return defaults[prop] })
        //     } else {
        //         // console.log("found prop:", prop, targetType)
        //     }
        // }
        console.log('Start reset on:', root)
        for (const prop in root) {
            if (prop === 'objectName' || prop.startsWith('_') || prop.endsWith('Changed')) continue
            const value = root[prop]
            const type = typeof value
            if (type === 'function') continue
            if (type === 'object') {
                if (value.hasOwnProperty('_defaults')) {
                    console.log('Call _reset on:', value)
                    value._reset()
                } else {
                    console.warn('Found unknown object in property "' + prop + '":', value)
                }
            } else {
                console.log('Reset property:', prop, type)
            }
        }
        console.log('End reset on:', root)
    }
}
