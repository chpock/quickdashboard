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

                styles: ({
                    month_previous: {
                        icon: 'keyboard_double_arrow_left',
                    },
                    month_current: {
                        icon: 'today',
                    },
                    month_next: {
                        icon: 'keyboard_double_arrow_right',
                    },
                })
            }

            title {
                _defaults: widget._defaults.text_title
                alignment {
                    horizontal: 'center'
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
                padding {
                    top:    2
                    bottom: 2
                }
                text: 'Events'
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
                        icon: 'edit_calendar',
                        padding: {
                            right: '2ch',
                        },
                    },
                    refresh: {
                        icon: 'refresh',
                        padding: {
                            right: '2ch',
                        },
                    },
                    visibility: {
                        icon: 'visibility_lock',
                        padding: {
                            right: '2ch',
                        },
                    },
                    plus: {
                        icon: 'add_circle',
                        padding: {
                            right: '1ch',
                        },
                    },
                    minus: {
                        icon: 'remove_circle',
                    },
                })
            }

        }

        icon {
            _defaults: widget._defaults.icon
            grade:  -25
            filled: true
            weight: 400
            icon: 'event'

            styles: ({
                soon: {
                    icon:  'alarm',
                    color: 'info/accent',
                },
                in_progress: {
                    icon:  'event_upcoming',
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
            icon: 'visibility_off'

            styles: ({
                unhide: {
                    icon: 'visibility',
                },
            })
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
