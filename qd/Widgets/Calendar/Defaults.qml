pragma ComponentBehavior: Bound

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

            styles: ({
                weekday: {
                    color: 'blue',
                    alignment: {
                        horizontal: 'center',
                    },
                    styles: {
                        today: {
                            font: {
                                weight: 'bold',
                            },
                        },
                    },
                },
                day: {
                    color: 'text/primary',
                    heightMode: 'capitals',
                    alignment: {
                        horizontal: 'right',
                    },
                    styles: {
                        today: {
                            font: {
                                weight: 'bold',
                            },
                            background: 'blue',
                        },
                        weekend: {
                            color: 'red',
                        },
                        other: {
                            color: 'text/secondary',
                        },
                    },
                }
            })
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

                styles: ({
                    application: {
                        padding: {
                            right: '2ch',
                        },
                    },
                    refresh: {
                        padding: {
                            right: '2ch',
                        },
                    },
                    visibility: {
                        padding: {
                            right: '2ch',
                        },
                    },
                    plus: {
                        padding: {
                            right: '1ch',
                        },
                    },
                    minus: {
                    },
                })
            }

        }

        icon {
            _defaults: widget._defaults.icon
            grade:  -25
            filled: true
            weight: 400

            styles: ({
                soon: {
                    color: 'info/accent',
                },
                in_progress: {
                    color: 'severity/critical',
                },
                far_in_future: {
                    color: 'severity/ignore',
                },
            })
        }

        title {
            _defaults: widget._defaults.text
            overflow: 'elide'

            styles: ({
                far_in_future: {
                    color: 'severity/ignore',
                },
            })
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

            styles: ({
                soon: {
                    color: 'info/accent',
                },
                in_progress: {
                    color: 'severity/critical',
                },
                far_in_future: {
                    color: 'severity/ignore',
                },
            })
        }

        alarm_offset_seconds: 600
        far_in_future_offset_seconds: 14400

    }

}
