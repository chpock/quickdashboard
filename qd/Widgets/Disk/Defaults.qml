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

    mount {

        point {
            _defaults: widget._defaults.text_title
            separator {
                enabled: false
            }
        }

        used {
            _defaults: widget._defaults.text_percent
            thresholds {
                good {
                    value: '<80'
                }
                warning {
                    value: '<95'
                }
                critical {
                    value: 'any'
                }
            }
        }

        details {
            _defaults: widget._defaults.text
            font {
                size: 'small'
            }
            color: 'text/secondary'
        }

        free {
            _defaults: widget._defaults.text_bytes
            precision: 3
        }

        total {
            _defaults: widget._defaults.text_bytes
            font {
                size: 'small'
            }
            color:     'text/secondary'
            precision: 3
            prefix:    '  / '
        }

        bar {
            _defaults: widget._defaults.bar
            padding {
                top:    3
                bottom: 2
            }
        }

    }

    rate {

        read {

            label {
                _defaults: widget._defaults.text
                color: 'info/primary'
                text:  'R:'
            }

            rate {
                _defaults: widget._defaults.text_bytes
                font {
                    size: 'small'
                }
                color: 'text/secondary'
            }

            graph {
                _defaults: widget._defaults.graph_timeseries
                stroke {
                    color: 'info/primary'
                }
                axisY {
                    max:    1024 * 10
                    extend: true
                }
                border {
                    color: 'info/primary'
                }
                padding {
                    top: 2
                }
                fill: 'info/primary%30'
            }

        }

        write {

            label {
                _defaults: widget._defaults.text
                color: 'info/secondary'
                text:  'W:'
            }

            rate {
                _defaults: widget._defaults.text_bytes
                font {
                    size: 'small'
                }
                color: 'text/secondary'
            }

            graph {
                _defaults: widget._defaults.graph_timeseries
                stroke {
                    color: 'info/secondary'
                }
                axisY {
                    max:    1024 * 10
                    extend: true
                }
                border {
                    color: 'info/secondary'
                }
                padding {
                    top: 2
                }
                fill: 'info/secondary%30'
            }

        }

    }

}
