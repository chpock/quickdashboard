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

    icon {
        _defaults: widget._defaults.icon
        color: 'text/title'

        styles: ({
            output: {
                icon: 'volume_up',
                styles: {
                    muted: {
                        icon:  'volume_off',
                        color: 'severity/critical',
                    },
                    unavailable: {
                        color: 'severity/critical',
                    },
                },
            },
            input: {
                icon: 'mic',
                styles: {
                    muted: {
                        icon:  'mic_off',
                        color: 'severity/critical',
                    },
                    unavailable: {
                        color: 'severity/critical',
                    },
                },
            },
        })
    }

    indicator {
        _defaults: widget._defaults.icon
        color: 'info/accent'
        padding {
            left: '1ch'
        }

        styles: ({
            output: {
                styles: {
                    headset: {
                        icon:  'headphones',
                    },
                    hdmi: {
                        icon:  'connected_tv',
                    },
                },
            },
            input: {
                styles: {
                    headset: {
                        icon:  'headset_mic',
                    },
                    hdmi: {
                        icon:  'connected_tv',
                    },
                },
            },
        })
    }

    device {
        _defaults: widget._defaults.text
        font {
            size: 'small'
        }
        padding {
            left:  '1ch'
            right: '1ch'
        }
        overflow: 'elide'
        color: 'text/secondary'

        styles: ({
            unavailable: {
                color: 'severity/critical',
            },
            hover: {
                color: 'text/primary',
            },
        })
    }

    percent {
        _defaults: widget._defaults.text_percent
        thresholds {
            enabled: false
        }
    }

    slider {
        _defaults: widget._defaults.slider
        padding {
            top: 2
        }
    }

}
