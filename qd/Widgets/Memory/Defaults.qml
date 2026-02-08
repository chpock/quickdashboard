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
    id: fragments

    property Widget.Base widget

    meter {

        title {
            _defaults: widget._defaults.text_title
            padding {
                right: '2ch'
            }

            styles: ({
                ram: {
                    text: 'RAM',
                },
                swap: {
                    text: 'Swap',
                },
            })
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
            color: 'text/secondary'
            precision: 3
            prefix: '  / '
        }

        percent {
            _defaults: widget._defaults.text_percent
            thresholds {
                good {
                    value: '<60'
                }
                warning {
                    value: '<90'
                }
                critical {
                    value: 'any'
                }
            }
        }

        bar {
            _defaults: widget._defaults.bar
            padding {
                top:    3
                bottom: 2
            }
        }

    }

    processes {
        list {
            _defaults: widget._defaults.process_list
            padding {
                top: 2
            }
        }
        value {
            _defaults: widget._defaults.text_bytes
            alignment {
                horizontal: 'right'
            }
            font {
                size: 'small'
            }
            precision: 3
        }
    }

}
