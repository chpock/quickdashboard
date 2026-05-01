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

    provider {
        title {
            _defaults: widget._defaults.text_title
            padding {
                right: '1ch'
            }
        }
        plan {
            _defaults: widget._defaults.text
            overflow: 'elide'
            styles: ({
                error: {
                    color: 'severity/critical',
                    overflow: 'scroll',
                },
            })
        }
    }

    line {
        label {
            _defaults: widget._defaults.text
        }
        duration {
            _defaults: widget._defaults.text
        }
        percent {
            _defaults: widget._defaults.text_percent
            thresholds {
                ignore {
                    value: '<5'
                }
                good {
                    value: '<70'
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
        resets {
            label {
                _defaults: widget._defaults.text
            }
            time {
                _defaults: widget._defaults.text
            }
        }
    }

}
