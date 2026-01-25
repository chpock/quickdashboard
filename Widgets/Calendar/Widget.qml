pragma ComponentBehavior: Bound

import Quickshell
import QtQuick
import qs
import qs.Elements as E
import qs.Config as C
import qs.Providers as Provider
import qs.Widgets as Widget

Widget.Base {
    id: root
    type: 'calendar'
    hierarchy: ['base', type]

    _fragments: Fragments {
        _defaults: Defaults {
            widget: root
        }
    }

    property var calendarColors
    property bool loaded: false

    readonly property int firstDayOfWeek: {
        return Qt.locale().firstDayOfWeek % 7
    }

    function changeCalendarColor(calendarId) {

        let colorIdx = calendarId in calendarColors ? calendarColors[calendarId] : -1
        colorIdx += 1
        if (colorIdx >= _theme.palette.names.length) {
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
            calendar.currentDate = Qt.binding(() => systemClockDate.date)
        } else {
            const d = new Date(calendar.currentDate)
            // reset to first day to avoid overflow when we increate month
            d.setDate(1)
            // increment month
            d.setMonth(d.getMonth() + direction)
            // bound to system time if result month/year match current month/year
            if (d.getMonth() === systemClockDate.date.getMonth() && d.getYear() === systemClockDate.date.getYear()) {
                changeMonth(0)
            } else {
                calendar.currentDate = d
            }
        }
    }

    SystemClock {
        id: systemClockDate
        precision: SystemClock.Hours
        readonly property string dateString: date.toDateString()
    }

    SystemClock {
        id: systemClockTimeMinutes
        precision: SystemClock.Minutes
        enabled: Provider.Calendar.running
    }

    SystemClock {
        id: systemClockTimeSeconds
        precision: SystemClock.Seconds
        // This is a hack to fix a bug in quickshell where SystemClock with
        // SystemClock.Minutes/SystemClock.Hours resolution does not update when
        // exiting from suspended state and remains as the old value for some time.
        onMinutesChanged: {
            systemClockTimeMinutes.precision =
                systemClockTimeMinutes.enabled && systemClockTimeSeconds.minutes !== systemClockTimeMinutes.minutes
                    ? SystemClock.Seconds
                    : SystemClock.Minutes
        }
        onHoursChanged: {
            systemClockDate.precision =
                systemClockDate.enabled && systemClockTimeSeconds.hours !== systemClockDate.hours
                    ? SystemClock.Seconds
                    : SystemClock.Hours
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

            icon: 'keyboard_double_arrow_left'
            anchors.left: parent.left
            visible: parent.isHovered
            onClicked: root.changeMonth(-1)
        }

        E.TextTitle {
            id: title
            theme: root._theme
            config: header.config.title

            text: Qt.formatDate(calendar.currentDate, "MMMM, yyyy")
            anchors.left: parent.left
            anchors.right: parent.right
        }

        E.Icon {
            id: iconCurrent
            theme: root._theme
            config: header.config.icon

            icon: 'today'
            anchors.right: iconRight.left
            visible: parent.isHovered
            onClicked: root.changeMonth(0)
        }

        E.Icon {
            id: iconRight
            theme: root._theme
            config: header.config.icon

            icon: 'keyboard_double_arrow_right'
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

        readonly property var config: root._fragments.calendar
        property date currentDate: systemClockDate.date
        readonly property date startDate: {
            const monthStartDate = new Date(currentDate.getFullYear(), currentDate.getMonth(), 1)
            let dateDiff = monthStartDate.getDay()
            dateDiff = (dateDiff + 7 - root.firstDayOfWeek) % 7
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
                        ? calendar.config.weekday_names[(index + root.firstDayOfWeek) % 7]
                        : dayDate.getDate()

                readonly property bool isWeekend: dayDate.getDay() % 6 === 0
                readonly property bool isCurrentMonth: dayDate.getMonth() == calendar.currentDate.getMonth()
                readonly property bool isCurrentWeekDay: dayDate.getDay() == calendar.currentDate.getDay()
                readonly property bool isToday: dayDate.toDateString() === systemClockDate.dateString

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

            text: 'Events'
            anchors.left: parent.left
        }

        E.Icon {
            id: buttonApplication
            theme: root._theme
            config: header.config.button

            icon: 'edit_calendar'
            style: 'application'
            anchors.right: buttonRefresh.left
            anchors.bottom: title.bottom
            visible: parent.isHovered && Provider.Calendar.calendarApplicationAvailable
            onClicked: Provider.Calendar.runCalendarApplication()
        }

        E.Icon {
            id: buttonRefresh
            theme: root._theme
            config: header.config.button

            icon: 'refresh'
            style: 'refresh'
            anchors.right: buttonToggleVisibility.left
            anchors.bottom: title.bottom
            visible: parent.isHovered
            onClicked: Provider.Calendar.refresh()
        }

        E.Icon {
            id: buttonToggleVisibility
            theme: root._theme
            config: header.config.button

            icon: 'visibility_lock'
            style: 'visibility'
            isActive: Provider.Calendar.eventUpcomingShowHidden
            anchors.right: buttonPlus.left
            anchors.bottom: title.bottom
            visible: parent.isHovered
            onClicked: Provider.Calendar.eventsUpcomingToggleVisibility()
        }

        E.Icon {
            id: buttonPlus
            theme: root._theme
            config: header.config.button

            icon: 'add_circle'
            style: 'plus'
            anchors.right: buttonMinus.left
            anchors.bottom: title.bottom
            visible: parent.isHovered
            onClicked: Provider.Calendar.eventsUpcomingChangeAmount(1)
        }

        E.Icon {
            id: buttonMinus
            theme: root._theme
            config: header.config.button

            icon: 'remove_circle'
            style: 'minus'
            anchors.right: parent.right
            anchors.bottom: title.bottom
            visible: parent.isHovered
            onClicked: Provider.Calendar.eventsUpcomingChangeAmount(-1)
        }
    }

    EventsHeader {
        anchors.left: parent.left
        anchors.right: parent.right
        visible: Provider.Calendar.running
    }

    component Event: Item {
        id: event

        required property var modelData

        readonly property var config: root._fragments.events
        readonly property var eventTime: event.modelData.start.getTime()
        readonly property var currentTime: systemClockTimeSeconds.date.getTime()
        readonly property int eventTimeDelta: Math.abs((eventTime - currentTime) / 10 ** 3)
        readonly property bool isInProgress: currentTime >= eventTime ? true : false

        readonly property bool isHidden: Provider.Calendar.eventsUpcomingIsHidden(modelData.eventId)
        readonly property bool isEmpty: modelData.eventId === ''

        readonly property bool isSoon: !isInProgress && eventTimeDelta <= config.alarm_offset_seconds
        readonly property bool isFarInFuture:
            !isInProgress &&
            modelData.start.toDateString() !== systemClockDate.dateString &&
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

            icon:
                event.isInProgress
                    ? 'event_upcoming'
                    : event.isSoon
                        ? 'alarm'
                        : 'event'
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

            icon: event.isHidden ? 'visibility' : 'visibility_off'
            anchors.right: parent.right
            visible: event.isHovered && !event.isEmpty
            onClicked: Provider.Calendar.eventsUpcomingToggleEventVisibility(event.modelData.eventId)
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

                const today = new Date(systemClockDate.date.getFullYear(),
                systemClockDate.date.getMonth(), systemClockDate.date.getDate())

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
        model: Provider.Calendar.eventsUpcomingModel

        Event {
            anchors.left: parent?.left
            anchors.right: parent?.right
            visible: Provider.Calendar.running
        }
    }

    Component.onCompleted: {
        try {
            calendarColors = JSON.parse(SettingsData.stateGet('Widget.Calendar.calendarColors', '{}'))
        }
        catch (e) {
            calendarColors = {}
        }
        loaded = true
    }

    onCalendarColorsChanged: {
        if (!loaded) return
        SettingsData.stateSet('Widget.Calendar.calendarColors', JSON.stringify(calendarColors))
    }

}
