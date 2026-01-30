pragma ComponentBehavior: Bound

import qs.qd.Widgets as Widget

Fragments {
    id: fragments

    property Widget.Base widget

    hours {
        _defaults: widget._defaults.text
        font {
            size:   40
            weight: 'bold'
        }
        heightMode: 'capitals'
    }

    separator {
        _defaults: widget._defaults.text
        font {
            size: 40
        }
        padding {
            top:   -3
            left:  5
            right: 5
        }
        heightMode: 'capitals'
    }

    minutes {
        _defaults: widget._defaults.text
        font {
            size: 40
        }
        heightMode: 'capitals'
    }

}
