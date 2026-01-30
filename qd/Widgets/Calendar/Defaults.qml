pragma ComponentBehavior: Bound

import qs.qd.Config as C
import qs.qd.Widgets as Widget

Fragments {
    id: fragments

    property Widget.Base widget

    calendar {

        header {

            icon {
                _defaults: widget._defaults.icon
                color: 'white'
                hover {
                    enabled: true
                    color:   'blue'
                }
                padding {
                    right: '1ch'
                }
                weight: 700
            }

            title {
                _defaults: widget._defaults.text_title
                text {
                    alignment {
                        horizontal: 'center'
                    }
                }
                separator {
                    enabled: false
                }
            }

        }

        spacing {
            horizontal: 3
            vertical:   3
        }

        cell {
            _defaults: widget._defaults.text
            font {
                size: 'small'
            }
            padding {
                left:   3
                right:  3
                top:    3
                bottom: 3
            }

            styles: [
                C.Text {
                    style: 'weekday'
                    color: 'blue'
                    alignment {
                        horizontal: 'center'
                    }
                },
                C.Text {
                    style: 'weekday/today'
                    font {
                        weight: 'bold'
                    }
                },
                C.Text {
                    style: 'day'
                    color: 'text/primary'
                    heightMode: 'capitals'
                    alignment {
                        horizontal: 'right'
                    }
                },
                C.Text {
                    style: 'day/today'
                    font {
                        weight: 'bold'
                    }
                    background: 'blue'
                },
                C.Text {
                    style: 'day/weekend'
                    color: 'red'
                },
                C.Text {
                    style: 'day/other'
                    color: 'text/secondary'
                },
            ]
        }

        weekday_names: ['Su', 'Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa']

        hover {
            border {
                width: 1
                color: 'blue'
            }
        }

    }

    events {

        header {

            title {
                _defaults: widget._defaults.text_title
                text {
                    padding {
                        top:    2
                        bottom: 2
                    }
                }
            }

            button {
                _defaults: widget._defaults.icon
                color: 'white'
                hover {
                    enabled: true
                    color:   'blue'
                }
                padding {
                    bottom: 3
                }

                styles: [
                    C.Icon {
                        style: 'application'
                        padding {
                            right: '2ch'
                        }
                    },
                    C.Icon {
                        style: 'refresh'
                        padding {
                            right: '2ch'
                        }
                    },
                    C.Icon {
                        style: 'visibility'
                        padding {
                            right: '2ch'
                        }
                    },
                    C.Icon {
                        style: 'plus'
                        padding {
                            right: '1ch'
                        }
                    },
                    C.Icon {
                        style: 'minus'
                    },
                ]
            }

        }

        icon {
            _defaults: widget._defaults.icon
            grade:  -25
            filled: true
            weight: 400
            styles: [
                C.Icon {
                    style: 'soon'
                    color: 'info/accent'
                },
                C.Icon {
                    style: 'in_progress'
                    color: 'severity/critical'
                },
                C.Icon {
                    style: 'far_in_future'
                    color: 'severity/ignore'
                },
            ]
        }

        title {
            _defaults: widget._defaults.text
            overflow: 'elide'
            styles: [
                C.Text {
                    style: 'far_in_future'
                    color: 'severity/ignore'
                },
            ]
        }

        marker {
            _defaults: widget._defaults.text
        }

        hide {
            _defaults: widget._defaults.icon
            color: 'white'
            hover {
                enabled: true
                color:   'blue'
            }
        }

        details {
            _defaults: widget._defaults.text
            font {
                size: 'small'
            }
            padding {
                right: '1ch'
            }
            color:    'text/secondary'
            overflow: 'elide'
        }

        timer {
            _defaults: widget._defaults.text
            padding {
                top: 2
            }

            styles: [
                C.Text {
                    style: 'soon'
                    color: 'info/accent'
                },
                C.Text {
                    style: 'in_progress'
                    color: 'severity/critical'
                },
                C.Text {
                    style: 'far_in_future'
                    color: 'severity/ignore'
                },
            ]
        }

        alarm_offset_seconds: 600
        far_in_future_offset_seconds: 14400

    }

}
