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
import qs.qd.Providers as Provider
import qs.qd.Widgets.AIUsageLimits as AIUsageLimits

TestCase {
    id: tests
    name: "AIUsageLimits"
    visible: true
    width: 480
    height: 800

    readonly property date now: new Date("2026-01-01T12:00:00Z")
    property var clock
    property var usage

    Component {
        id: widgetComponent
        AIUsageLimits.Widget {
            variant: 0
        }
    }

    SignalSpy {
        id: modelChanges
        signalName: "dataChanged"
    }

    function initTestCase() {
        QD.Settings.isDemo = true
        clock = Provider.SystemClock.instance
        usage = Provider.AIUsageLimits.instance
        verify(clock !== null)
        verify(usage !== null)
        // Let the mock provider finish its deferred initial population.
        tryVerify(() => usage.providersModel.count > 0)
    }

    function init() {
        clock.dateSeconds = now
        clock.dateMinutes = now
        usage.syncProvidersState({ data: [], notice: null })
    }

    function cleanup() {
        modelChanges.target = null
        console.log(qtest_results.failed ? "FAIL" : "PASS",
                    qtest_results.functionName, qtest_results.dataTag)
    }

    function limit(period, remaining, percent, label = "Session") {
        return {
            label: label,
            periodDurationSeconds: period,
            percent: percent,
            resetsAt: remaining === null ? new Date(0) : new Date(now.getTime() + remaining * 1000),
        }
    }

    function setLines(lines) {
        usage.syncProvidersState({
            notice: null,
            data: [{
                id: "test",
                displayName: "Test",
                plan: "Plan",
                account: { id: "test", name: "Test", isActive: true },
                lines: lines,
            }],
        })
    }

    function bars(item) {
        let result = []
        for (const child of item.children) {
            if ("valueTarget" in child && "valueMax" in child) result.push(child)
            result = result.concat(bars(child))
        }
        return result
    }

    function createWidget(variant = 0) {
        const widget = createTemporaryObject(widgetComponent, tests, { variant: variant })
        verify(widget !== null)
        tryVerify(() => bars(widget).length === usage.providersModel.get(0).lines.count)
        return widget
    }

    function compareTarget(bar, expected) {
        compare(bar.valueMax, 1)
        verify(Number.isFinite(bar.valueTarget))
        fuzzyCompare(bar.valueTarget, expected, 0.000000001)
    }

    function test_target_data() {
        return [
            { tag: "above", period: 3600, remaining: 1800, percent: 0.6, expected: 0.5 },
            { tag: "below", period: 3600, remaining: 1800, percent: 0.4, expected: 0.5 },
            { tag: "equal", period: 3600, remaining: 1800, percent: 0.5, expected: 0.5 },
            { tag: "start", period: 3600, remaining: 3600, percent: 0.2, expected: 0 },
            { tag: "reset", period: 3600, remaining: 0, percent: 0.2, expected: 1 },
            { tag: "past-reset", period: 3600, remaining: -60, percent: 0.2, expected: 1 },
            { tag: "before-start", period: 3600, remaining: 7200, percent: 0.2, expected: 0 },
            { tag: "unknown-reset", period: 3600, remaining: null, percent: 0.6, expected: 0.6 },
            { tag: "unknown-period", period: 0, remaining: 1800, percent: 0.6, expected: 0.6 },
            { tag: "negative-period", period: -1, remaining: 1800, percent: 0.6, expected: 0.6 },
            { tag: "uninitialized", period: 3600, remaining: 1800, percent: -1, expected: 0 },
            { tag: "unknown-reset-zero-usage", period: 3600, remaining: null, percent: 0, expected: 0 },
            { tag: "unknown-reset-full-usage", period: 3600, remaining: null, percent: 1, expected: 1 },
            { tag: "weekly", period: 604800, remaining: 151200, percent: 0.6, expected: 0.75 },
            { tag: "monthly", period: 2592000, remaining: 1296000, percent: 0.6, expected: 0.5 },
            { tag: "fractional-second-period", period: 0.5, remaining: 0.25, percent: 0.6, expected: 0.5 },
            { tag: "zero-usage", period: 3600, remaining: 1800, percent: 0, expected: 0.5 },
            { tag: "full-usage", period: 3600, remaining: 1800, percent: 1, expected: 0.5 },
        ]
    }

    function test_target(data) {
        setLines([limit(data.period, data.remaining, data.percent)])
        const bar = bars(createWidget())[0]
        compareTarget(bar, data.expected)
        compare(bar.value, data.percent < 0 ? 0 : data.percent)
    }

    function test_rendering_data() {
        const rows = []
        for (const mode of ["normal", "compact", "details"]) {
            rows.push({ tag: mode + "-above", mode: mode, percent: 0.6,
                        fill: [[0.25, "active"], [0.55, "active"], [0.8, "inactive"]],
                        target: [[0.25, null], [0.55, "above"], [0.8, null]] })
            rows.push({ tag: mode + "-below", mode: mode, percent: 0.4,
                        fill: [[0.2, "active"], [0.45, "inactive"], [0.75, "inactive"]],
                        target: [[0.2, null], [0.45, "below"], [0.75, null]] })
        }
        return rows
    }

    function test_rendering(data) {
        setLines([limit(3600, 1800, data.percent)])
        let widget = createWidget(data.mode === "normal" ? 0 : 1)
        if (data.mode === "details") {
            widget = createTemporaryObject(widget._details, tests)
            verify(widget !== null)
        }
        const bar = bars(widget)[0]
        compareTarget(bar, 0.5)
        verify(bar.visible)
        verify(waitForRendering(bar))
        // Capture the full scene so samples include the widget background.
        const image = grabImage(tests)
        const scale = image.width / tests.width
        const layers = [
            { samples: data.fill, colors: bar.config.color,
              y: bar.config.padding.top + bar.config.height / 2 },
            { samples: data.target, colors: bar.config.target.color,
              y: bar.config.padding.top + bar.config.height + bar.config.target.padding.top + bar.config.target.height / 2 },
            { samples: [[0.2, null], [0.45, null], [0.55, null], [0.8, null]], colors: null,
              y: bar.config.padding.top + bar.config.height + 0.5 },
        ]
        for (const layer of layers) {
            for (const sample of layer.samples) {
                const point = bar.mapToItem(tests,
                    bar.config.padding.left + sample[0] * bar.effectiveWidth, layer.y)
                const color = Qt.color(bar.theme.getColor(sample[1] === null ? "transparent" : layer.colors[sample[1]]))
                const background = widget.color
                const expected = Qt.rgba(
                    color.r * color.a + background.r * (1 - color.a),
                    color.g * color.a + background.g * (1 - color.a),
                    color.b * color.a + background.b * (1 - color.a), 1)
                fuzzyCompare(image.pixel(Math.floor(point.x * scale), Math.floor(point.y * scale)), expected, 1)
            }
        }
    }

    function test_minuteUpdatesWithoutProviderUpdates() {
        setLines([limit(3600, 1800, 0.6)])
        const bar = bars(createWidget())[0]
        modelChanges.target = usage.providersModel.get(0).lines
        verify(modelChanges.valid)
        modelChanges.clear()
        compareTarget(bar, 0.5)

        clock.dateSeconds = new Date(now.getTime() + 30000)
        compareTarget(bar, 0.5)
        clock.dateMinutes = new Date(now.getTime() + 60000)
        compareTarget(bar, 31 / 60)
        clock.dateSeconds = new Date(now.getTime() + 90000)
        compareTarget(bar, 31 / 60)
        clock.dateMinutes = new Date(now.getTime() + 120000)
        compareTarget(bar, 32 / 60)
        compare(modelChanges.count, 0)
    }

    function test_providerUpdates() {
        setLines([limit(3600, 1800, 0.6)])
        const widget = createWidget()
        compareTarget(bars(widget)[0], 0.5)
        setLines([limit(3600, 900, 0.7)])
        compareTarget(bars(widget)[0], 0.75)
        compare(bars(widget)[0].value, 0.7)
        setLines([limit(1800, 900, 0.7)])
        compareTarget(bars(widget)[0], 0.5)
        setLines([limit(1800, null, 0.7)])
        compareTarget(bars(widget)[0], 0.7)
        setLines([limit(1800, 900, 0.7)])
        compareTarget(bars(widget)[0], 0.5)
    }

    function test_stableHeight_data() {
        return [{ tag: "normal", mode: "normal" },
                { tag: "compact", mode: "compact" },
                { tag: "details", mode: "details" }]
    }

    function test_stableHeight(data) {
        setLines([limit(3600, 1800, 0.6)])
        let widget = createWidget(data.mode === "normal" ? 0 : 1)
        if (data.mode === "details") {
            widget = createTemporaryObject(widget._details, tests)
            verify(widget !== null)
        }
        const bar = bars(widget)[0]
        verify(waitForRendering(bar))
        const barHeight = bar.implicitHeight
        const widgetHeight = widget.implicitHeight
        const actualWidgetHeight = widget.height
        for (const row of [
            { period: 3600, remaining: null, percent: 0.6, target: 0.6 },
            { period: 3600, remaining: null, percent: 0.7, target: 0.7 },
            { period: 3600, remaining: 1800, percent: 0.7, target: 0.5 },
            { period: 0, remaining: 1800, percent: 0.7, target: 0.7 },
            { period: -1, remaining: 1800, percent: 0.7, target: 0.7 },
            { period: 3600, remaining: 1800, percent: -1, target: 0 },
            { period: 3600, remaining: null, percent: 0, target: 0 },
            { period: 3600, remaining: 1800, percent: 0.6, target: 0.5 },
        ]) {
            setLines([limit(row.period, row.remaining, row.percent)])
            verify(waitForRendering(bar))
            compare(bar.implicitHeight, barHeight)
            compare(widget.implicitHeight, widgetHeight)
            compare(widget.height, actualWidgetHeight)
            compareTarget(bar, row.target)
        }
    }

    function test_multiplePeriods_data() {
        return [{ tag: "normal", variant: 0 }, { tag: "compact", variant: 1 }]
    }

    function test_multiplePeriods(data) {
        setLines([
            limit(3600, 1800, 0.6, "Session"),
            limit(604800, 453600, 0.3, "Weekly"),
            limit(2592000, null, 0.2, "Monthly"),
        ])
        const items = bars(createWidget(data.variant))
        compareTarget(items[0], 0.5)
        compareTarget(items[1], 0.25)
        compareTarget(items[2], 0.2)
        compare(items.filter(item => item.visible).length, data.variant === 0 ? 3 : 1)
    }

    onCompletedChanged: {
        if (completed) {
            console.log("AIUsageLimits results:", qtest_results.passCount, "passed,",
                        qtest_results.failCount, "failed")
            Qt.exit(qtest_results.failCount > 0 ? 1 : 0)
        }
    }
}
