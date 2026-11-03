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
import "qd/Helpers/helpers.js" as Helpers

TestCase {
    id: tests
    name: "Bar"
    visible: true
    width: 240
    height: 64

    readonly property string activeColor: "#0000ff"
    readonly property string inactiveColor: "#404040"
    readonly property string aboveColor: "#ff0000"
    readonly property string belowColor: "#00ff00"
    readonly property string backgroundColor: "#010203"
    property var bar

    Rectangle {
        anchors.fill: parent
        z: -1
        color: tests.backgroundColor
    }

    C.Bar {
        id: barConfig
        _defaults: QD.Defaults.defaults.bar
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

    Component {
        id: configComponent
        C.Bar {}
    }

    function init() {
        barConfig._custom = {
            height: 8,
            padding: { left: 5, right: 5, top: 3, bottom: 3 },
            color: { active: activeColor, inactive: inactiveColor },
            target: {
                height: 1,
                padding: { top: 1, bottom: 0, left: 0, right: 0 },
                color: { above: aboveColor, below: belowColor },
            },
        }
        bar = createTemporaryObject(barComponent, tests)
        verify(bar !== null)
    }

    function cleanup() {
        console.log(qtest_results.failed ? "FAIL" : "PASS",
                    qtest_results.functionName, qtest_results.dataTag)
    }

    function checkPixel(image, scale, x, y, color) {
        const actual = image.pixel(Math.floor((x + 0.5) * scale), Math.floor((y + 0.5) * scale))
        const expected = Qt.color(color)
        if (!Qt.colorEqual(actual, expected)) {
            console.error("Bar pixel mismatch:", x, y, actual, expected,
                          "value:", bar.value, "target:", bar.valueTarget, "width:", bar.width)
        }
        compare(actual, expected)
    }

    function rectangles(item) {
        let result = []
        for (const child of item.children) {
            if ("color" in child) result.push(child)
            result = result.concat(rectangles(child))
        }
        return result
    }

    function checkRendering(filledPercent, expectedHeight, marker = null) {
        compare(bar.implicitHeight, expectedHeight)
        const items = rectangles(bar)
        const fill = items.find(item => Qt.colorEqual(item.color, activeColor))
        const inactive = items.find(item => Qt.colorEqual(item.color, inactiveColor))
        const target = items.find(item => item !== fill && item !== inactive)
        verify(fill !== undefined && inactive !== undefined && target !== undefined)
        const mainWidth = Math.max(0, bar.width - 10)
        const filledWidth = mainWidth * filledPercent / 100
        compare(fill.x, 5)
        compare(fill.y, 3)
        compare(fill.height, 8)
        fuzzyCompare(fill.width, filledWidth, 0.000001)
        fuzzyCompare(inactive.x, 5 + filledWidth, 0.000001)
        compare(inactive.y, 3)
        compare(inactive.height, 8)
        fuzzyCompare(inactive.width, mainWidth - filledWidth, 0.000001)
        compare(target.visible, marker !== null)
        if (marker !== null) {
            const point = target.mapToItem(bar, 0, 0)
            fuzzyCompare(point.x, marker.left, 0.000001)
            fuzzyCompare(point.y, marker.top, 0.000001)
            fuzzyCompare(target.width, marker.right - marker.left, 0.000001)
            compare(target.height, marker.height)
            compare(target.color, Qt.color(marker.color))
        }

        verify(waitForRendering(bar))
        const image = grabImage(tests)
        const scale = image.width / tests.width
        // Sample interiors: fractional-edge rasterization belongs to Qt.
        if (filledWidth > 0) checkPixel(image, scale, 5 + filledWidth / 2, 6, activeColor)
        if (filledWidth < mainWidth) {
            checkPixel(image, scale, 5 + filledWidth + (mainWidth - filledWidth) / 2, 6, inactiveColor)
        }
        if (marker !== null) {
            const x = (marker.left + marker.right) / 2
            checkPixel(image, scale, x, marker.top, marker.color)
            checkPixel(image, scale, x, marker.top - 1, backgroundColor)
        }
    }

    function marker(left, right, color, top = 12, height = 1) {
        return { left: left, right: right, color: color, top: top, height: height }
    }

    function test_target_data() {
        return [
            { tag: "default", omit: true, value: 60, height: 14 },
            { tag: "null", target: null, value: 60, height: 14 },
            { tag: "undefined", target: undefined, value: 60, height: 14 },
            { tag: "seven-percent", target: null, value: 7, height: 14 },
            { tag: "seven-to-fourteen", target: 14, value: 7, height: 16, marker: marker(19, 33, belowColor) },
            { tag: "seven-to-fourteen-normalized", maximum: 1, target: 0.14, value: 0.07, fill: 7,
              height: 16, marker: marker(19, 33, belowColor) },
            { tag: "above", target: 40, value: 60, height: 16, marker: marker(85, 125, aboveColor) },
            { tag: "below", target: 60, value: 40, height: 16, marker: marker(85, 125, belowColor) },
            { tag: "equal", target: 60, value: 60, height: 16 },
            { tag: "zero-target", target: 0, value: 60, height: 16, marker: marker(5, 125, aboveColor) },
            { tag: "zero-value", target: 60, value: 0, height: 16, marker: marker(5, 125, belowColor) },
            { tag: "full-target", target: 100, value: 60, height: 16, marker: marker(125, 205, belowColor) },
            { tag: "full-value", target: 60, value: 100, height: 16, marker: marker(125, 205, aboveColor) },
            { tag: "both-zero", target: 0, value: 0, height: 16 },
            { tag: "both-full", target: 100, value: 100, height: 16 },
        ]
    }

    function test_target(data) {
        bar.valueMax = data.maximum ?? 100
        bar.value = data.value
        if (data.omit) compare(bar.valueTarget, null)
        else bar.valueTarget = data.target
        checkRendering(data.fill ?? data.value, data.height, data.marker ?? null)
    }

    function test_liveChanges() {
        bar.valueMax = 1
        bar.value = 0.6
        bar.valueTarget = 0.4
        checkRendering(60, 16, marker(85, 125, aboveColor))
        bar.valueTarget = 0.8
        checkRendering(60, 16, marker(125, 165, belowColor))
        bar.value = 0.8
        checkRendering(80, 16)
        bar.valueTarget = 0.6
        checkRendering(80, 16, marker(125, 165, aboveColor))
        bar.value = 0.6
        checkRendering(60, 16)
        bar.valueTarget = null
        checkRendering(60, 14)
        bar.valueTarget = 0
        bar.width = 110
        checkRendering(60, 16, marker(5, 65, aboveColor))
        bar.valueTarget = undefined
        checkRendering(60, 14)
    }

    function test_nonPositiveMaximum_data() {
        return [{ tag: "zero", maximum: 0 }, { tag: "negative", maximum: -1 }]
    }

    function test_nonPositiveMaximum(data) {
        bar.value = 60
        bar.valueTarget = 40
        bar.valueMax = data.maximum
        checkRendering(0, 16)
    }

    function test_targetGeometryAndColors_data() {
        return [{ tag: "above", value: 60, target: 40, color: "#ff00ff" },
                { tag: "below", value: 40, target: 60, color: "#00ffff" }]
    }

    function test_targetGeometryAndColors(data) {
        barConfig.target._custom = {
            height: 3,
            padding: { top: 2, bottom: 4, left: 10, right: 20 },
            color: { above: "#ff00ff", below: "#00ffff" },
        }
        bar.value = data.value
        bar.valueTarget = data.target
        checkRendering(data.value, 23, marker(85, 125, data.color, 13, 3))
    }

    function test_insufficientWidth() {
        bar.value = 60
        bar.valueTarget = 40
        bar.width = 8
        compare(bar.effectiveWidth, 0)
        checkRendering(60, 16)
        bar.width = 210
        barConfig.target.padding._custom = { left: 120, right: 120 }
        checkRendering(60, 16, marker(85, 125, aboveColor))
    }

    function test_targetInheritance() {
        const inherited = createTemporaryObject(configComponent, tests, { _defaults: barConfig })
        verify(inherited !== null)
        compare(inherited.target.height, 1)
        compare(inherited.target.padding.top, 1)
        compare(inherited.target.color.above, aboveColor)
        compare(inherited.target.color.below, belowColor)
        inherited._custom = {
            target: { height: 3, padding: { top: 2 }, color: { above: "#ff00ff" } },
        }
        compare(inherited.target.height, 3)
        compare(inherited.target.padding.top, 2)
        compare(inherited.target.padding.left, 0)
        compare(inherited.target.color.above, "#ff00ff")
        compare(inherited.target.color.below, belowColor)
        inherited._custom = undefined
        compare(inherited.target.height, 1)
        compare(inherited.target.padding.top, 1)
        compare(inherited.target.color.above, aboveColor)
        compare(inherited.target.color.below, belowColor)
    }

    function test_defaultConfig() {
        const config = QD.Defaults.defaults.bar
        compare(config.target.height, 1)
        compare(config.target.padding.top, 1)
        compare(config.target.padding.bottom, 0)
        compare(config.target.padding.left, 0)
        compare(config.target.padding.right, 0)
        compare(config.target.color.above, "severity/critical")
        compare(config.target.color.below, "severity/good")
        compare(Object.keys(Helpers.toPlainValue(config.color)).sort(), ["active", "inactive"])
    }

    onCompletedChanged: {
        if (completed) {
            console.log("Bar results:", qtest_results.passCount, "passed,",
                        qtest_results.failCount, "failed")
            Qt.exit(qtest_results.failCount > 0 ? 1 : 0)
        }
    }
}
