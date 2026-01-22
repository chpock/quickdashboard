pragma ComponentBehavior: Bound

import QtQuick
// import qs
import qs.Config as C

Rectangle {
    id: root
    property string type: "base"
    property var hierarchy: [type]

    default property alias content: content.data

    property var config: ({})
    property var fragments: ({})
    property QtObject configFragments: null

    FontLoader {
        id: symbolsFont
        source: Qt.resolvedUrl("../assets/fonts/material-design-icons/MaterialSymbolsSharp[FILL,GRAD,opsz,wght].ttf")
    }

    FontLoader {
        id: generalFont
        source: Qt.resolvedUrl("../assets/fonts/noto/NotoSans-Regular.ttf")
    }

    component ConfigWidget: C.ConfigWidget {
        border {
            color: '#33FFFFFF'
            width: 1
        }
        background {
            color: '#ED1F2428'
        }
        padding {
            top:    8
            bottom: 8
            left:   8
            right:  8
        }
        spacing {
            vertical:   5
            horizontal: 15
        }
    }

    component Theme: C.Theme {
        palette {
            cyan_bright:    '#1abc9c' // turquoise
            cyan:           '#16a085' // greensea
            green_bright:   '#2ecc71' // emerland
            green:          '#27ae60' // nephritis
            blue_bright:    '#3498db' // peterriver
            blue:           '#2980b9' // belizehole
            megenta_bright: '#9b59b6' // amethyst
            megenta:        '#8e44ad' // wisteria
            yellow_bright:  '#f1c40f' // sunflower
            yellow:         '#f39c12' // orange
            orange_bright:  '#e67e22' // carrot
            orange:         '#d35400' // pumpkin
            red_bright:     '#e74c3c' // alizarin
            red:            '#c0392b' // pomegranate
            white_bright:   '#ecf0f1' // clouds
            white:          '#bdc3c7' // silver
            gray_bright:    '#95a5a6' // concrete
            gray:           '#7f8c8d' // asbestos

            names: [
               'cyan_bright',
                'cyan',
                'green_bright',
                'green',
                'blue_bright',
                'blue',
                'megenta_bright',
                'megenta',
                'yellow_bright',
                'yellow',
                'orange_bright',
                'orange',
                'red_bright',
                'red',
                'white_bright',
                'white',
                'gray_bright',
                'gray',
            ]
        }
        color {
            text {
                primary:    root._config.theme.palette.white_bright
                secondary:  root._config.theme.palette.gray_bright
                title:      root._config.theme.palette.megenta_bright
                hightlight: root._config.theme.palette.yellow
            }
            info {
                primary:   root._config.theme.palette.blue
                secondary: root._config.theme.palette.cyan
                accent:    root._config.theme.palette.orange
            }
            severity {
                ignore:   root._config.theme.palette.gray
                good:     root._config.theme.palette.green
                warning:  root._config.theme.palette.yellow_bright
                critical: root._config.theme.palette.red_bright
            }
        }
        font {
            family {
                general: generalFont.name
                symbols: symbolsFont.name
            }
            size {
                normal: 14
                small:  12
            }
            weight {
                normal:    Font.Normal
                medium:    Font.Medium
                bold:      Font.Bold
                extraBold: Font.ExtraBold
                black:     Font.Black
            }
        }
    }

    component ConfigDefaults: QtObject {
        readonly property C.Slider slider: C.Slider {
            bar {
                color {
                    active:   'blue'
                    inactive: '#26FFFFFF'
                }
                height: 4
            }
            thumb {
                color:  'blue'
                height: 8
                width:  4
                gap:    2
            }
            padding {
                left:   0
                right:  0
                top:    0
                bottom: 0
            }
        }
        readonly property C.Bar bar: C.Bar {
            color {
                active:   'blue'
                inactive: '#26FFFFFF'
            }
            padding {
                left:   0
                right:  0
                top:    0
                bottom: 0
            }
            height: 4
        }
        readonly property C.Text text: C.Text {
            id: text
            font {
                size:      'normal'
                weight:    'normal'
                family:    'general'
                strikeout: false
            }
            padding {
                left:   0
                right:  0
                top:    0
                bottom: 0
            }
            scroll {
                duration:   7
                pauseStart: 6000
                pauseEnd:   2000
            }
            alignment {
                horizontal: 'left'
                vertical:   'center'
            }
            hover {
                enabled: false
            }
            color:      'white_bright'
            background: 'transparent'
            overflow:   'none'
            heightMode: 'normal'
            text:       '?'
        }
        readonly property C.TextTitle text_title: C.TextTitle {
            text {
                _defaults: text
                font {
                    weight: 'medium'
                }
                color: 'megenta_bright'
            }
            separator {
                enabled: true
                color:   'gray'
                text:    ':'
            }
        }
        readonly property C.TextTemperature text_temperature: C.TextTemperature {
            text {
                _defaults: text
            }
            thresholds {
                ignore {
                    color: 'severity/ignore'
                    value: 'none'
                }
                good {
                    color: 'severity/good'
                    value: 'none'
                }
                warning {
                    color: 'severity/warning'
                    value: 'none'
                }
                critical {
                    color: 'severity/critical'
                    value: 'none'
                }
                enabled: true
            }
        }
        readonly property C.TextPercent text_percent: C.TextPercent {
            text {
                _defaults: text
            }
            thresholds {
                ignore {
                    color: 'severity/ignore'
                    value: 'none'
                }
                good {
                    color: 'severity/good'
                    value: 'none'
                }
                warning {
                    color: 'severity/warning'
                    value: 'none'
                }
                critical {
                    color: 'severity/critical'
                    value: 'none'
                }
                enabled: true
            }
        }
        readonly property C.TextSeverity text_severity: C.TextSeverity {
            text {
                _defaults: text
            }
            thresholds {
                ignore {
                    color: 'severity/ignore'
                    value: 'none'
                }
                good {
                    color: 'severity/good'
                    value: 'none'
                }
                warning {
                    color: 'severity/warning'
                    value: 'none'
                }
                critical {
                    color: 'severity/critical'
                    value: 'none'
                }
                enabled: true
            }
        }
        readonly property C.TextBytes text_bytes: C.TextBytes {
            text {
                _defaults: text
            }
            precision: 4
            prefix:    ''
        }
        readonly property C.Icon icon: C.Icon {
            font {
                size:      'normal'
                weight:    'normal'
                family:    'symbols'
                strikeout: false
            }
            padding {
                left:   0
                right:  0
                top:    0
                bottom: 0
            }
            hover {
                enabled: false
                color:   'blue'
            }
            active {
                color:   'yellow'
            }
            word_spacing_font_family: 'general'
            color:       'white_bright'
            background:  'transparent'
            filled:      false
            grade:       200
            weight:      400
            opticalSize: 24
        }
        readonly property C.GraphTimeseries graph_timeseries: C.GraphTimeseries {
            stroke {
                width: 1
                color: 'info/primary'
            }
            axisY {
                max:    100.0
                min:    0.0
                extend: false
            }
            border {
                width: 1
                color: 'info/primary'
            }
            padding {
                left:   0
                right:  0
                top:    0
                bottom: 0
            }
            fill:  'info/primary%30'
            points: 50
            height: 40
        }
        readonly property C.GraphBars graph_bars: C.GraphBars {
            border {
                width: 1
                color: 'info/primary'
            }
            padding {
                left:   0
                right:  0
                top:    0
                bottom: 0
            }
            thresholds {
                ignore {
                    color: 'severity/ignore'
                    value: '<=10'
                }
                good {
                    color: 'severity/good'
                    value: '<=70'
                }
                warning {
                    color: 'severity/warning'
                    value: '<=95'
                }
                critical {
                    color: 'severity/critical'
                    value: '<=Inf'
                }
                enabled: true
            }
            height: 40
        }
        readonly property C.ProcessList process_list: C.ProcessList {
            id: process_list
            common {
                _defaults: text
                font {
                    size: 'small'
                }
            }
            command {
                _defaults: process_list.common
                padding {
                    right: '2ch'
                }
                overflow: 'elide'
            }
            args {
                _defaults: process_list.common
                padding {
                    right: '2ch'
                }
                color:    'text/secondary'
                overflow: 'elide'
            }
            value {
                _defaults: process_list.common
                alignment {
                    horizontal: 'right'
                }
            }
            spacing {
                horizontal: 3
            }
            padding {
                left:   0
                right:  0
                top:    0
                bottom: 0
            }
        }
    }

    Component {
        id: configWidget
        ConfigWidget {}
    }

    Component {
        id: theme
        Theme {}
    }

    Component {
        id: configDefaults
        ConfigDefaults {}
    }

    readonly property var _config: QtObject {
        property C.ConfigWidget widget: ConfigWidget {}
        property C.Theme theme: Theme {}
        property ConfigDefaults defaults: ConfigDefaults {}
        property QtObject fragments: root.configFragments
    }

    border {
        color: _config.widget.border.color
        width: _config.widget.border.width
    }

    color: _config.widget.background.color

    width: parent.width
    implicitHeight: content.implicitHeight
        + _config.widget.padding.top + _config.widget.padding.bottom
        + _config.widget.border.width * 2

    HoverHandler {
        id: hh
    }

    readonly property bool isHovered: hh.hovered

    Column {
        id: content
        readonly property alias _config: root._config
        y:             _config.widget.padding.left + _config.widget.border.width
        spacing:       _config.widget.spacing.vertical
        width:         parent.width
        anchors.left:  parent.left
        anchors.right: parent.right
        anchors.leftMargin:   _config.widget.padding.left   + _config.widget.border.width
        anchors.rightMargin:  _config.widget.padding.right  + _config.widget.border.width
        anchors.topMargin:    _config.widget.padding.top    + _config.widget.border.width
        anchors.bottomMargin: _config.widget.padding.bottom + _config.widget.border.width
    }

    function recreateConfig() {
        _config.widget.destroy()
        _config.widget = configWidget.createObject(_config)
        _config.theme.destroy()
        _config.theme = theme.createObject(_config)
        _config.defaults.destroy()
        _config.defaults = configDefaults.createObject(_config)
        if (configFragments) configFragments.destroy()
        recreateConfigFragments()
    }

    function recreateConfigFragments() {
        _config.fragments = null
    }

    function applyConfig(target, source, path) {
        Object.entries(source).forEach(([key, value]) => {
            if (target[key] === undefined) {
                console.warn('Config property "' + path + key + '" does not exist on the target widget.')
                return
            }
            if (typeof value === 'object' && value !== null && !Array.isArray(value)) {
                applyConfig(target[key], value, path + key + '.')
            } else {
                try {
                    target[key] = value;
                } catch (e) {
                    console.error('Failed to set config property "' + path + key + '": ' + e.message);
                }
            }
        })
    }

    Component.onCompleted: {
        // console.log("base completed!")
        recreateConfig()
        // console.log("apply config!")
        if (_config.fragments) {
            applyConfig(_config.fragments, fragments, '.')
        }
        applyConfig(_config, config, '.')
        // console.log("complete - done")
    }
}
