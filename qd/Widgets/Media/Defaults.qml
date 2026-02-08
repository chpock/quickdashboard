/*
    This file is a part of quickdashboard: https://github.com/chpock/quickdashboard

    Copyright (C) 2025-2026 Kostiantyn Kushnir <chpock@gmail.com>

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <https://www.gnu.org/licenses/>.
*/

pragma ComponentBehavior: Bound

import qs.qd.Widgets as Widget

Fragments {

    property Widget.Base widget

    album_art {

        padding {
            top:    0
            bottom: 0
            left:   0
            right:  10
        }

        size {
            width:  45
            height: 45
        }

        border {
            width: 1
            color: 'text/secondary'
        }

        no_art {
            _defaults: widget._defaults.icon
            font {
                size: 35
            }
            color: 'gray'
            icon:  'question_mark'
        }

    }

    player {

        status {
            _defaults: widget._defaults.text
            overflow:  'elide'

            styles: ({
                unavailable: {
                    color: 'severity/ignore',
                    text:  'No players',
                },
                playing: {
                    color: 'severity/good',
                    text:  'Playing',
                },
                paused: {
                    color: 'info/accent',
                    text:  'Paused',
                },
                stopped: {
                    color: 'severity/critical',
                    text:  'Stopped',
                },
                unknown: {
                    color: 'severity/critical',
                    text:  'Unknown status',
                },
            })
        }

        time {
            _defaults: widget._defaults.text
        }

        control {

            button {
                _defaults: widget._defaults.icon
                hover {
                    enabled: true
                }
                color:  'white'
                filled: true
                weight: 700

                styles: ({
                    previous: {
                        icon: 'skip_previous',
                    },
                    next: {
                        icon: 'skip_next',
                    },
                    toggle: {
                        styles: {
                            resume: {
                                icon: 'resume',
                            },
                            play: {
                                icon: 'play_arrow',
                            },
                            pause: {
                                icon: 'pause',
                            },
                            stop: {
                                icon: 'stop',
                            },
                        },
                    },
                })
            }

            spacing {
                horizontal: 4
            }

            padding {
                top:    1
                bottom: 0
                left:   0
                right:  0
            }

        }

        slider {
            _defaults: widget._defaults.slider
            padding {
                top: 3
            }
        }

        track {
            _defaults: widget._defaults.text
            overflow:  'scroll'
            padding {
                top: 3
            }
        }

        artist {
            _defaults: widget._defaults.text
            font {
                size: 'small'
            }
            padding {
                top: 3
            }
            color:     'text/secondary'
            overflow:  'scroll'
        }

    }

}
