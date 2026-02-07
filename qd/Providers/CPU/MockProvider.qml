pragma ComponentBehavior: Bound

import QtQuick

Provider {
    id: root

    hasService: false

    model: "Unknown"
    cores: _coresUsage.length
    frequency: 1790.873
    usage: _usage[_usage.length - 1]
    temperature: 57

    readonly property var _coresUsage: [
        13.131313130914805,
        3.0303030305368766,
        8.08080808130918,
        3.0303030303983784,
        3.030303029824202,
        0,
        11.111111110825298,
        1.0101010103014496,
        1.0204081627349886,
        25.0000000000436557,
        71.0309278352603368,
        5.0000000000873115,
        2.0408163269397144,
        1.0000000002037268,
        99.0101010095739282,
        1.0101010103014496,
        0.9900990101007028,
        0,
    ]

    readonly property var _usage: [
        12.4, 14.1, 13.5, 15.9, 18.2, 17.5, 14.8, 12.2, 13.6, 15.2,
        15.8, 18.2, 22.4, 28.7, 35.1, 33.4, 42.9, 55.6, 62.3, 58.1,
        42.1, 88.5, 92.3, 75.6, 45.2, 32.1, 28.4, 24.5, 21.8, 19.3,
        18.2, 16.9, 14.5, 12.1, 13.4, 15.8, 18.9, 22.1, 20.4, 17.7,
        16.5, 14.2, 13.8, 15.1, 19.4, 25.6, 38.7, 42.1, 35.5, 22.8,
    ]

    Component.onCompleted: {
        Qt.callLater(() => {
            root.updateCoresUsage(root._coresUsage)
            for (const value of root._usage) {
                root.updateUsage({
                    frequency: root.frequency,
                    temperature: root.temperature,
                    usage: value,
                })
            }
        })
    }
}
