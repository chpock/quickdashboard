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

import QtQuick
import qs.qd as QD
import qs.qd.Elements as E
import qs.qd.Config as C
import qs.qd.Providers as Provider
import qs.qd.Widgets as Widget

Widget.Base {
    id: root

    readonly property var providerCalendar: Provider.Calendar.instance
    readonly property var providerSystemClock: Provider.SystemClock.instance

    _fragments: Fragments {
        _defaults: Defaults {
            widget: root
        }
        _custom: root.fragments
        _chain: (root._chain ? root._chain + '.' : '') + root.type + '.fragments'
    }

    property var calendarColors
    property bool loaded: false

    readonly property date currentDate: root.providerSystemClock.dateDays
    readonly property string currentDateString: currentDate.toDateString()

    function changeCalendarColor(calendarId) {

        let colorIdx = calendarId in calendarColors ? calendarColors[calendarId] : -1
        colorIdx += 1
        if (colorIdx >= _theme.palette._names.length) {
            // Re-create an object to trigger changes in bindings
            const calendarColorsNew = Object.assign({}, calendarColors)
            delete calendarColorsNew[calendarId]
            calendarColors = calendarColorsNew
        } else {
            // Re-create an object to trigger changes in bindings
            calendarColors = Object.assign({}, calendarColors, { [calendarId]: colorIdx })
        }

    }

    function changeMonth(direction) {
        if (direction === 0) {
            calendar.activeDate = Qt.binding(() => root.currentDate)
        } else {
            const d = new Date(calendar.activeDate)
            // reset to first day to avoid overflow when we increate month
            d.setDate(1)
            // increment month
            d.setMonth(d.getMonth() + direction)
            // bound to system time if result month/year match current month/year
            if (d.getMonth() === root.currentDate.getMonth() && d.getYear() === root.currentDate.getYear()) {
                changeMonth(0)
            } else {
                calendar.activeDate = d
            }
        }
    }

    component Header: Item {
        id: header

        readonly property var config: root._fragments.calendar.header
        readonly property alias isHovered: hoverHandler.hovered

        implicitHeight: Math.max(
            iconLeft.implicitHeight,
            title.implicitHeight,
            iconCurrent.implicitHeight,
            iconRight.implicitHeight
        )

        HoverHandler {
            id: hoverHandler
        }

        E.Icon {
            id: iconLeft
            theme: root._theme
            config: header.config.icon

            style: 'month_previous'
            anchors.left: parent.left
            visible: parent.isHovered
            onClicked: root.changeMonth(-1)
        }

        E.TextTitle {
            id: title
            theme: root._theme
            config: header.config.title

            text: Qt.formatDate(calendar.activeDate, "MMMM, yyyy")
            anchors.left: parent.left
            anchors.right: parent.right
        }

        E.Icon {
            id: iconCurrent
            theme: root._theme
            config: header.config.icon

            style: 'month_current'
            anchors.right: iconRight.left
            visible: parent.isHovered
            onClicked: root.changeMonth(0)
        }

        E.Icon {
            id: iconRight
            theme: root._theme
            config: header.config.icon

            style: 'month_next'
            anchors.right: parent.right
            visible: parent.isHovered
            onClicked: root.changeMonth(1)
        }

    }

    Header {
        anchors.left: parent.left
        anchors.right: parent.right
    }

    component Calendar: Grid {
        id: calendar

        property date activeDate: root.currentDate
        readonly property var config: root._fragments.calendar
        readonly property int firstDayOfWeek: root.providerSystemClock.firstDayOfWeek
        readonly property date startDate: {
            const monthStartDate = new Date(activeDate.getFullYear(), activeDate.getMonth(), 1)
            let dateDiff = monthStartDate.getDay()
            dateDiff = (dateDiff + 7 - firstDayOfWeek) % 7
            dateDiff = dateDiff == 0 ? 7 : dateDiff
            monthStartDate.setDate(1 - dateDiff)
            return monthStartDate
        }
        property real dayCellWidth: 0

        columns: 7
        rows: 7
        rowSpacing: config.spacing.vertical
        columnSpacing: config.spacing.horizontal

        Repeater {
            model: 49

            Rectangle {
                id: day

                required property int index
                readonly property bool isDayName: index < 7 ? true : false
                readonly property date dayDate: {
                    const date = new Date(calendar.startDate)
                    date.setDate(date.getDate() + index - 7)
                    return date
                }

                readonly property string dayText:
                    isDayName
                        ? calendar.config.weekday_names[(index + calendar.firstDayOfWeek) % 7]
                        : dayDate.getDate()

                readonly property bool isWeekend: dayDate.getDay() % 6 === 0
                readonly property bool isCurrentMonth: dayDate.getMonth() == calendar.activeDate.getMonth()
                readonly property bool isCurrentWeekDay: dayDate.getDay() == calendar.activeDate.getDay()
                readonly property bool isToday: dayDate.toDateString() === root.currentDateString

                readonly property string style:
                    isDayName
                        ? (isCurrentWeekDay
                            ? 'weekday/today'
                            : 'weekday'
                          )
                        : !isCurrentMonth
                            ? 'day/other'
                            : isToday
                                ? 'day/today'
                                : isWeekend
                                    ? 'day/weekend'
                                    : 'day'

                implicitWidth: calendar.dayCellWidth
                implicitHeight: dayText.implicitHeight
                color: 'transparent'
                border.width: hoverHandler.hovered && !isDayName ? calendar.config.hover.border.width : 0
                border.color: root._theme.getColor(calendar.config.hover.border.color)

                HoverHandler {
                    id: hoverHandler
                }

                E.Text {
                    id: dayText
                    theme: root._theme
                    config: calendar.config.cell

                    text: day.dayText
                    style: day.style
                    anchors.fill: parent
                    onImplicitWidthChanged: {
                        if (implicitWidth > calendar.dayCellWidth)
                            calendar.dayCellWidth = implicitWidth
                    }
                }

            }
        }
    }

    Calendar {
        id: calendar
        anchors.horizontalCenter: parent.horizontalCenter
    }

    component EventsHeader: Item {
        id: header

        readonly property var config: root._fragments.events.header
        readonly property alias isHovered: hoverHandler.hovered

        implicitHeight: Math.max(
            title.implicitHeight,
            buttonRefresh.implicitHeight,
            buttonToggleVisibility.implicitHeight,
            buttonPlus.implicitHeight,
            buttonMinus.implicitHeight,
        )

        HoverHandler {
            id: hoverHandler
        }

        E.TextTitle {
            id: title
            theme: root._theme
            config: header.config.title

            anchors.left: parent.left
        }

        E.Icon {
            id: buttonApplication
            theme: root._theme
            config: header.config.button

            style: 'application'
            anchors.right: buttonRefresh.left
            anchors.bottom: title.bottom
            visible: parent.isHovered && root.providerCalendar.calendarApplicationAvailable
            onClicked: root.providerCalendar.runCalendarApplication()
        }

        E.Icon {
            id: buttonRefresh
            theme: root._theme
            config: header.config.button

            style: 'refresh'
            anchors.right: buttonToggleVisibility.left
            anchors.bottom: title.bottom
            visible: parent.isHovered
            onClicked: root.providerCalendar.refresh()
        }

        E.Icon {
            id: buttonToggleVisibility
            theme: root._theme
            config: header.config.button

            style: 'visibility'
            isActive: root.providerCalendar.eventUpcomingShowHidden
            anchors.right: buttonPlus.left
            anchors.bottom: title.bottom
            visible: parent.isHovered
            onClicked: root.providerCalendar.eventsUpcomingToggleVisibility()
        }

        E.Icon {
            id: buttonPlus
            theme: root._theme
            config: header.config.button

            style: 'plus'
            anchors.right: buttonMinus.left
            anchors.bottom: title.bottom
            visible: parent.isHovered
            onClicked: root.providerCalendar.eventsUpcomingChangeAmount(1)
        }

        E.Icon {
            id: buttonMinus
            theme: root._theme
            config: header.config.button

            style: 'minus'
            anchors.right: parent.right
            anchors.bottom: title.bottom
            visible: parent.isHovered
            onClicked: root.providerCalendar.eventsUpcomingChangeAmount(-1)
        }
    }

    EventsHeader {
        anchors.left: parent.left
        anchors.right: parent.right
        visible: root.providerCalendar.running
    }

    component Event: Item {
        id: event

        required property var modelData

        readonly property var config: root._fragments.events
        readonly property var eventTime: event.modelData.start.getTime()
        readonly property var currentTime: root.providerSystemClock.dateSeconds.getTime()
        readonly property int eventTimeDelta: Math.abs((eventTime - currentTime) / 10 ** 3)
        readonly property bool isInProgress: currentTime >= eventTime ? true : false

        readonly property bool isHidden: root.providerCalendar.eventsUpcomingIsHidden(modelData.eventId)
        readonly property bool isEmpty: modelData.eventId === ''

        readonly property bool isSoon: !isInProgress && eventTimeDelta <= config.alarm_offset_seconds
        readonly property bool isFarInFuture:
            !isInProgress &&
            modelData.start.toDateString() !== root.currentDateString &&
            eventTimeDelta > config.far_in_future_offset_seconds

        readonly property var style:
            isInProgress
                ? 'in_progress'
                : isSoon
                    ? 'soon'
                    : isFarInFuture
                        ? 'far_in_future'
                        : undefined

        readonly property alias isHovered: hoverHandler.hovered

        implicitHeight: Math.max(icon.implicitHeight, title.implicitHeight) + leftTime.implicitHeight

        HoverHandler {
            id: hoverHandler
        }

        E.Icon {
            id: icon
            theme: root._theme
            config: event.config.icon

            style: event.style
            anchors.left: parent.left
            visible: !event.isEmpty
        }

        Item {
            id: title

            implicitHeight: Math.max(titleText.implicitHeight, titleIcon.implicitHeight)
            implicitWidth: titleText.implicitWidth + titleIcon.implicitWidth
            anchors.left: icon.right
            anchors.leftMargin: titleText.wordSpacing * 2
            anchors.right: event.isHovered ? buttonHide.left : parent.right
            anchors.rightMargin: event.isHovered ? titleText.wordSpacing : undefined
            anchors.verticalCenter: icon.verticalCenter

            E.Text {
                id: titleText
                theme: root._theme
                config: event.config.title

                text: event.modelData.title
                style: event.isFarInFuture ? 'far_in_future' : undefined
                strikeout: event.isHidden ? true : undefined
                anchors.left: parent.left
                width: Math.min(implicitWidth, parent.width - titleIcon.implicitWidth)
            }

            E.Text {
                id: titleIcon
                theme: root._theme
                config: C.Text {
                    _defaults: event.config.title
                    styles: undefined
                    color:
                        event.modelData.calendarId in root.calendarColors
                            ? root._theme.palette.getByIndex(root.calendarColors[event.modelData.calendarId])
                            : root._theme.getColor('text/primary')
                }

                text:
                    event.isEmpty
                        ? ''
                        : event.modelData.calendarId in root.calendarColors
                            ? " \u25CF "
                            : " \u25CB "
                anchors.left: titleText.right
                anchors.right: parent.right
                visible: (event.modelData.calendarId in root.calendarColors) || event.isHovered
                HoverHandler {
                    enabled: !event.isEmpty
                    acceptedButtons: Qt.NoButton
                    cursorShape: Qt.PointingHandCursor
                }
                TapHandler {
                    onTapped: root.changeCalendarColor(event.modelData.calendarId)
                }
            }

        }

        E.Icon {
            id: buttonHide
            theme: root._theme
            config: event.config.hide

            style: event.isHidden ? 'unhide' : undefined
            anchors.right: parent.right
            visible: event.isHovered && !event.isEmpty
            onClicked: root.providerCalendar.eventsUpcomingToggleEventVisibility(event.modelData.eventId)
        }

        E.Text {
            id: details
            theme: root._theme
            config: event.config.details

            text: {
                if (event.isEmpty) return ''

                function getNiceDate(date, diff) {
                    if (diff === 0) {
                        return "Today"
                    } else if (diff === 1) {
                        return "Tomorrow"
                    } else if (diff === -1) {
                        return "Yesterday"
                    }
                    return date.toLocaleDateString(Qt.locale(), Locale.ShortFormat)
                }

                const today = new Date(
                    root.currentDate.getFullYear(),
                    root.currentDate.getMonth(),
                    root.currentDate.getDate()
                )

                const startDay = new Date(event.modelData.start.getFullYear(),
                    event.modelData.start.getMonth(), event.modelData.start.getDate())
                const startDiff = Math.floor((startDay - today) / 86400000)

                const endDay = new Date(event.modelData.end.getFullYear(),
                    event.modelData.end.getMonth(), event.modelData.end.getDate())
                const endDiff = Math.floor((endDay - today) / 86400000)

                const result = getNiceDate(startDay, startDiff) + ', ' +
                    event.modelData.start.toLocaleTimeString(Qt.locale(), Locale.ShortFormat) +
                    ' - '

                if (startDiff === endDiff) {
                    return result + event.modelData.end.toLocaleTimeString(Qt.locale(), Locale.ShortFormat)
                }

                return result + getNiceDate(endDay, endDiff) + ', ' +
                    event.modelData.end.toLocaleTimeString(Qt.locale(), Locale.ShortFormat)
            }
            strikeout: event.isHidden ? true : undefined
            anchors.left: title.left
            anchors.right: leftTime.left
            anchors.bottom: leftTime.bottom
        }

        E.Text {
            id: leftTime
            theme: root._theme
            config: event.config.timer

            text: {
                if (event.modelData.eventId === '') return ''
                const sign = event.isInProgress && event.eventTimeDelta > 0 ? '-' : ''
                const days = Math.floor(event.eventTimeDelta / 86400)
                const hours = Math.floor((event.eventTimeDelta % 86400) / 3600)
                if (days > 0) {
                    return `${sign}${days}d ${hours}h`
                }
                const minutes = Math.floor((event.eventTimeDelta % 3600) / 60)
                if (hours > 0) {
                    return `${sign}${hours}h ${minutes}m`
                }
                if (minutes > 9) {
                    return `${sign}${minutes}m`
                }
                const seconds = event.eventTimeDelta % 60
                if (minutes > 0) {
                    return `${sign}${minutes}m ${seconds}s`
                }
                return `${sign}${seconds}s`
            }
            style: event.style
            anchors.right: parent.right
            anchors.top: title.bottom
        }
    }

    Repeater {
        model: root.providerCalendar.eventsUpcomingModel

        Event {
            anchors.left: parent?.left
            anchors.right: parent?.right
            visible: root.providerCalendar.running
        }
    }

    Component.onCompleted: {
        try {
            calendarColors = JSON.parse(QD.Settings.stateGet('Widget.Calendar.calendarColors', '{}'))
        }
        catch (e) {
            calendarColors = {}
        }
        loaded = true
    }

    onCalendarColorsChanged: {
        if (!loaded) return
        QD.Settings.stateSet('Widget.Calendar.calendarColors', JSON.stringify(calendarColors))
    }

}
