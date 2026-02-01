pragma ComponentBehavior: Bound

import QtQuick

Base {
    property TextPadding _defaults

    property var top:    _defaults?.top
    property var bottom: _defaults?.bottom
    property var left:   _defaults?.left
    property var right:  _defaults?.right

    _validation: ({
        top:    ['string', 'number'],
        bottom: ['string', 'number'],
        left:   ['string', 'number'],
        right:  ['string', 'number'],
    })
}
