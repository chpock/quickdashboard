pragma ComponentBehavior: Bound
pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick
import qs.Services as Service
import qs

Singleton {
    id: root

    property bool running: false
    readonly property alias eventsUpcomingModel: eventsUpcomingModelObj
    readonly property alias eventsTodayModel: eventsTodayModelObj

    property var eventsAll: []
    property var sampleData: {
        'calendarId': '',
        'eventId':    '',
        'title':      '',
        'start':      new Date(),
        'end':        new Date(),
    }
    property var eventsUpcomingHiddenItems: []
    property bool eventUpcomingShowHidden: false

    SystemClock {
        id: systemClock
        precision: SystemClock.Minutes
        onMinutesChanged: {
            root.updateModels()
        }
    }

    Connections {
        target: Service.Khal
        function onUpdateEvents(data) {
            root.eventsAll = data
            root.updateModels()
        }
        function onAvailable() {
            root.running = true
        }
        function onUnavailable() {
            root.running = false
        }
    }

    function refresh() {
        return Service.Khal.refresh()
    }

    function updateModels() {
        const currentDateObj = systemClock.date
        const currentDate = currentDateObj.toDateString()
        const currentTime = currentDateObj.getTime()
        let idxEventUpcoming = 0
        let idxEventToday = 0
        for (let event of eventsAll) {
            if (event.start.toDateString() === currentDate || event.end.toDateString() === currentDate) {
                if (idxEventToday >= eventsTodayModel.count) {
                    eventsTodayModel.append(event)
                } else {
                    if (eventsTodayModel.get(idxEventToday).eventId !== event.eventId) {
                        eventsTodayModel.set(idxEventToday, event)
                    }
                }
                idxEventToday++
            }
            if (idxEventUpcoming < eventsUpcomingModel.count) {
                const isActive = event.start.getTime() >= currentTime || event.end.getTime() > currentTime
                const isHidden = !root.eventUpcomingShowHidden && root.eventsUpcomingHiddenItems.includes(event.eventId)
                if (isActive && !isHidden) {
                    if (eventsUpcomingModel.get(idxEventUpcoming).eventId !== event.eventId) {
                        eventsUpcomingModel.set(idxEventUpcoming, event)
                    }
                    idxEventUpcoming++
                }
            }
        }
        while (idxEventUpcoming < eventsUpcomingModel.count) {
            eventsUpcomingModel.set(idxEventUpcoming++, sampleData)
        }
        if (eventsTodayModel.count > idxEventToday) {
            eventsTodayModel.remove(idxEventToday, eventsTodayModel.count - idxEventToday)
        }
    }

    function eventsUpcomingChangeAmount(direction) {
        if (direction < 0) {
            if (eventsUpcomingModel.count > 0) {
                eventsUpcomingModel.remove(eventsUpcomingModel.count - 1, 1)
            }
        } else if (direction > 0 && eventsUpcomingModel.count < 10) {
            eventsUpcomingModel.append(sampleData)
            updateModels()
        }
    }

    function eventsUpcomingToggleEventVisibility(eventId) {
        let index = root.eventsUpcomingHiddenItems.indexOf(eventId)
        if (index === -1) {
            root.eventsUpcomingHiddenItems.push(eventId)
        } else {
            root.eventsUpcomingHiddenItems.splice(index, 1)
        }
        // Refresh event render by unsetting its eventId
        for (let i = 0; i < eventsUpcomingModel.count; ++i) {
            if (eventsUpcomingModel.get(i).eventId === eventId) {
                eventsUpcomingModel.setProperty(i, 'eventId', '')
                break
            }
        }
        updateModels()
    }

    function eventsUpcomingToggleVisibility() {
        root.eventUpcomingShowHidden = !root.eventUpcomingShowHidden
        updateModels()
    }

    function eventsUpcomingIsHidden(eventId) {
        return root.eventsUpcomingHiddenItems.indexOf(eventId) !== -1
    }

    ListModel {
        id: eventsUpcomingModelObj
        Component.onCompleted: {
            let stateCount = SettingsData.stateGet('Provider.Calendar.ListModel.count', 3)
            while (stateCount-- > 0) {
                append(sampleData)
            }
        }
        onCountChanged: {
            SettingsData.stateSet('Provider.Calendar.ListModel.count', count)
        }
    }

    ListModel {
        id: eventsTodayModelObj
    }

    Component.onCompleted: {
        running = SettingsData.stateGet('Provider.Calendar.running', false)
    }

    onRunningChanged: {
        SettingsData.stateSet('Provider.Calendar.running', running)
    }

    // Everything related to calendar application is below. Move it to a service?

    property bool calendarApplicationAvailable: false

    function runCalendarApplication() {
        calendarApplicationProc.running = true
    }

    function refreshCalendarApplication() {
        let calendarApplication = DesktopEntries.applications.values.find(function(entry) {
            return entry.name === 'Google Calendar'
        })
        if (calendarApplication) {
            calendarApplicationAvailable = true
            calendarApplicationProc.command = [
                Quickshell.shellPath('bin/chrome-wait.sh'),
                ...calendarApplication.command
            ]
        } else {
            calendarApplicationAvailable = false
        }
    }

    Timer {
        id: initCalendarApplicationTimer
        interval: 500
        running: true
        repeat: false
        onTriggered: root.refreshCalendarApplication()
    }

    Timer {
        id: refreshCalendarApplicationTimer
        interval: 1000 * 60 * 5
        running: true
        repeat: true
        onTriggered: root.refreshCalendarApplication()
    }

    Process {
        id: calendarApplicationProc
        running: false
        // qmllint disable signal-handler-parameters
        onExited: (exitCode, _) => {
        // qmllint enable signal-handler-parameters
            if (exitCode !== 0) {
                console.error('[Provider.Calendar/calendarApplicationProc]', 'finished with exit code:', exitCode)
            }
            root.refresh()
        }
    }

}
