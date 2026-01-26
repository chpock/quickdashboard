pragma ComponentBehavior: Bound
pragma Singleton

import Quickshell
import qs.Services as Service

Singleton {
    id: root

    readonly property date dateSeconds: Service.SystemClock.dateSeconds
    readonly property date dateMinutes: Service.SystemClock.dateMinutes
    readonly property date dateHours: Service.SystemClock.dateHours
    readonly property date dateDays: Service.SystemClock.dateHours

    readonly property int seconds: dateSeconds.getSeconds()
    readonly property int minutes: dateMinutes.getMinutes()
    readonly property int hours: dateHours.getHours()
}
