/*
    This file is a part of quickdashboard: https://github.com/chpock/quickdashboard

    Copyright (C) 2026 Kostiantyn Kushnir <chpock@gmail.com>

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

import QtQuick
import QtTest
import qs.qd as QD
import qs.qd.Config as C
import qs.qd.Elements as E

TestCase {
    id: tests
    name: "Bar"
    visible: true
    width: 240
    height: 40

    readonly property string activeColor: "#0000ff"
    readonly property string inactiveColor: "#404040"
    readonly property string aboveColor: "#ff0000"
    readonly property string belowColor: "#00ff00"
    property var bar

    C.Bar {
        id: barConfig
        _defaults: QD.Defaults.defaults.bar
        _custom: ({
            height: 8,
            padding: { left: 5, right: 5, top: 3, bottom: 3 },
            color: {
                active: tests.activeColor,
                inactive: tests.inactiveColor,
                aboveReference: tests.aboveColor,
                belowReference: tests.belowColor,
            },
        })
    }

    C.Theme {
        id: barTheme
        _defaults: QD.Defaults.theme
    }

    Component {
        id: barComponent
        E.Bar {
            theme: barTheme
            config: barConfig
            width: 210
        }
    }

    function init() {
        bar = createTemporaryObject(barComponent, tests)
        verify(bar !== null)
    }

    function cleanup() {
        console.log(qtest_results.failed ? "FAIL" : "PASS",
                    qtest_results.functionName, qtest_results.dataTag)
    }

    function checkSegments(expected) {
        const segments = Array.from(bar.children)
            .filter(child => child.visible && child.width > 0 && child.height > 0)
            .sort((a, b) => a.x - b.x)
        compare(segments.length, expected.length)
        let x = barConfig.padding.left
        for (let i = 0; i < segments.length; ++i) {
            const segment = segments[i]
            const width = expected[i][0] * bar.effectiveWidth / 100
            fuzzyCompare(segment.x, x, 0.000001)
            fuzzyCompare(segment.width, width, 0.000001)
            compare(segment.y, barConfig.padding.top)
            compare(segment.height, barConfig.height)
            compare(segment.color, Qt.color(expected[i][1]))
            x += width
        }
        fuzzyCompare(x, bar.width - barConfig.padding.right, 0.000001)
    }

    function test_reference_data() {
        return [
            { tag: "default", omit: true, value: 60,
              segments: [[60, activeColor], [40, inactiveColor]] },
            { tag: "null", reference: null, value: 60,
              segments: [[60, activeColor], [40, inactiveColor]] },
            { tag: "undefined", reference: undefined, value: 60,
              segments: [[60, activeColor], [40, inactiveColor]] },
            { tag: "above", reference: 40, value: 60,
              segments: [[40, activeColor], [20, aboveColor], [40, inactiveColor]] },
            { tag: "below", reference: 60, value: 40,
              segments: [[40, activeColor], [20, belowColor], [40, inactiveColor]] },
            { tag: "equal", reference: 60, value: 60,
              segments: [[60, activeColor], [40, inactiveColor]] },
            { tag: "zero-reference", reference: 0, value: 60,
              segments: [[60, aboveColor], [40, inactiveColor]] },
            { tag: "zero-value", reference: 60, value: 0,
              segments: [[60, belowColor], [40, inactiveColor]] },
            { tag: "full-reference", reference: 100, value: 60,
              segments: [[60, activeColor], [40, belowColor]] },
            { tag: "full-value", reference: 60, value: 100,
              segments: [[60, activeColor], [40, aboveColor]] },
            { tag: "both-zero", reference: 0, value: 0,
              segments: [[100, inactiveColor]] },
            { tag: "both-full", reference: 100, value: 100,
              segments: [[100, activeColor]] },
        ]
    }

    function test_reference(data) {
        bar.value = data.value
        if (!data.omit) bar.valueReference = data.reference
        compare(bar.implicitHeight, 14)
        checkSegments(data.segments)

        verify(waitForRendering(bar))
        const image = grabImage(bar)
        let x = barConfig.padding.left
        for (const segment of data.segments) {
            const width = segment[0] * bar.effectiveWidth / 100
            compare(image.pixel(Math.floor(x + width / 2), 6), Qt.color(segment[1]))
            x += width
        }
    }

    function test_liveChanges() {
        bar.valueMax = 1
        bar.value = 0.6
        bar.valueReference = 0.4
        checkSegments([[40, activeColor], [20, aboveColor], [40, inactiveColor]])
        bar.valueReference = 0.8
        checkSegments([[60, activeColor], [20, belowColor], [20, inactiveColor]])
        bar.value = 0.8
        checkSegments([[80, activeColor], [20, inactiveColor]])
        bar.valueReference = null
        checkSegments([[80, activeColor], [20, inactiveColor]])
        bar.valueReference = 0
        bar.width = 110
        checkSegments([[80, aboveColor], [20, inactiveColor]])
        bar.valueReference = undefined
        checkSegments([[80, activeColor], [20, inactiveColor]])
    }

    function test_nonPositiveMaximum_data() {
        return [{ tag: "zero", maximum: 0 }, { tag: "negative", maximum: -1 }]
    }

    function test_nonPositiveMaximum(data) {
        bar.value = 60
        bar.valueReference = 40
        bar.valueMax = data.maximum
        checkSegments([[100, inactiveColor]])
    }

    function test_colorInheritance() {
        const inherited = Qt.createQmlObject(
            'import qs.qd.Config as C; C.BarColor {}', tests)
        inherited._defaults = barConfig.color
        compare(inherited.aboveReference, aboveColor)
        compare(inherited.belowReference, belowColor)
        inherited._custom = { aboveReference: "severity/good", belowReference: "severity/warning" }
        compare(barTheme.getColor(inherited.aboveReference), barTheme.getColor("severity/good"))
        compare(barTheme.getColor(inherited.belowReference), barTheme.getColor("severity/warning"))
        inherited._custom = undefined
        compare(inherited.aboveReference, aboveColor)
        compare(inherited.belowReference, belowColor)
        inherited.destroy()
    }

    function test_defaultColors() {
        compare(QD.Defaults.defaults.bar.color.aboveReference, "severity/warning")
        compare(QD.Defaults.defaults.bar.color.belowReference, "severity/good")
    }

    onCompletedChanged: {
        if (completed) {
            console.log("Bar results:", qtest_results.passCount, "passed,",
                        qtest_results.failCount, "failed")
            Qt.exit(qtest_results.failCount > 0 ? 1 : 0)
        }
    }
}
