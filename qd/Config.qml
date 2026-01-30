pragma ComponentBehavior: Bound
pragma Singleton

import Quickshell
import QtQuick
import qs.qd.Config as C
// import QtCore

Singleton {
    id: root

    // readonly property alias widget: widget
    // readonly property alias theme: theme
    // readonly property alias defaults: defaults
    readonly property alias config: config

    FontLoader {
        id: symbolsFont
        source: Qt.resolvedUrl("./assets/fonts/material-design-icons/MaterialSymbolsSharp[FILL,GRAD,opsz,wght].ttf")
    }

    FontLoader {
        id: generalFont
        source: Qt.resolvedUrl("./assets/fonts/noto/NotoSans-Regular.ttf")
    }

    C.Config {
        id: config

        widget {
            _defaults: widget
        }
        theme {
            _defaults: theme
        }
        defaults {
            _defaults: defaults
        }
    }

    C.Widget {
        id: widget

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

    C.Theme {
        id: theme

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
                primary:    theme.palette.white_bright
                secondary:  theme.palette.gray_bright
                title:      theme.palette.megenta_bright
                hightlight: theme.palette.yellow
            }
            info {
                primary:   theme.palette.blue
                secondary: theme.palette.cyan
                accent:    theme.palette.orange
            }
            severity {
                ignore:   theme.palette.gray
                good:     theme.palette.green
                warning:  theme.palette.yellow_bright
                critical: theme.palette.red_bright
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
                normal:     Font.Normal
                medium:     Font.Medium
                bold:       Font.Bold
                extra_bold: Font.ExtraBold
                black:      Font.Black
            }
        }
    }

    C.Defaults {
        id: defaults

        slider {
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
        bar {
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
        text {
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
            word_spacing_font_family: ''
            color:      'white_bright'
            background: 'transparent'
            overflow:   'none'
            heightMode: 'normal'
            text:       '?'
        }
        text_title {
            text {
                _defaults: defaults.text
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
        text_temperature {
            text {
                _defaults: defaults.text
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
        text_percent {
            text {
                _defaults: defaults.text
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
        text_severity {
            text {
                _defaults: defaults.text
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
        text_bytes {
            text {
                _defaults: defaults.text
            }
            precision: 4
            prefix:    ''
        }
        icon {
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
        graph_timeseries {
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
        graph_bars {
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
        process_list {
            common {
                _defaults: defaults.text
                font {
                    size: 'small'
                }
            }
            command {
                _defaults: defaults.process_list.common
                padding {
                    right: '2ch'
                }
                overflow: 'elide'
            }
            args {
                _defaults: defaults.process_list.common
                padding {
                    right: '2ch'
                }
                color:    'text/secondary'
                overflow: 'elide'
            }
            value {
                _defaults: defaults.process_list.common
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
}
