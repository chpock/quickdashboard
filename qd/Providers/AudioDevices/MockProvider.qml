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

Provider {
    id: root

    sink: ({
        "objectName":"",
        "id":116,
        "name":"bluez_output.F4:29:67:BA:9A:5E",
        "description":
        "Nokia WHP-101",
        "nickname":"",
        "isSink":true,
        "isStream":false,
        "type":17,
        "properties":{
            "adapt.follower.spa-node":"",
            "audio.position":"[FL, FR]",
            "bluez5.sink-loopback":"true",
            "card.profile.device":"1",
            "client.id":"111",
            "clock.quantum-limit":"8192",
            "device.id":"81",
            "device.routes":"1",
            "factory.id":"12",
            "filter.smart":"true",
            "filter.smart.target":"{\"device.id\":81, \"bluez5.sink-loopback-target\":true, \"bluez5.sink-loopback\":false}",
            "library.name":"audioconvert/libspa-audioconvert",
            "media.class":"Audio/Sink",
            "media.name":"Nokia WHP-101 input",
            "node.autoconnect":"true",
            "node.description":"Nokia WHP-101",
            "node.driver-id":"75",
            "node.group":"loopback-2414-22",
            "node.link-group":"loopback-2414-22",
            "node.loop.name":"data-loop.0",
            "node.name":"bluez_output.F4:29:67:BA:9A:5E",
            "node.virtual":"false",
            "node.want-driver":"true",
            "object.id":"116",
            "object.register":"false",
            "object.serial":"3386",
            "port.group":"stream.0",
            "priority.session":"2010",
            "resample.disable":"true",
            "resample.prefill":"true",
            "stream.is-live":"true"
        },
        "audio":{
            "objectName":"",
            "muted":false,
            "volume":0.8503938317298889,
            "channels":[3,4],
            "volumes":[0.8503938317298889,0.8503938317298889]
        },
        "ready":true
    })

    source: ({
        "objectName":"",
        "id":52,
        "name":"alsa_input.pci-0000_00_1f.3-platform-skl_hda_dsp_generic.HiFi__Mic1__source",
        "description":"Meteor Lake-P HD Audio Controller Digital Microphone",
        "nickname":"Digital Microphone",
        "isSink":false,
        "isStream":false,
        "type":9,
        "properties":{
            "alsa.card":"0",
            "alsa.card_name":"sof-hda-dsp",
            "alsa.class":"generic",
            "alsa.components":"HDA:10ec0256,1d722309,00100002 cfg-dmics:4 iec61937-pcm:5,4,3",
            "alsa.device":"6",
            "alsa.driver_name":"snd_soc_skl_hda_dsp",
            "alsa.id":"sofhdadsp",
            "alsa.long_card_name":"XIAOMI-RedmiBookPro162024--TM2309",
            "alsa.mixer_device":"_ucm0001.hw:sofhdadsp",
            "alsa.mixer_name":"Realtek ALC256",
            "alsa.name":"",
            "alsa.resolution_bits":"32",
            "alsa.subclass":"generic-mix",
            "alsa.subdevice":"0",
            "alsa.subdevice_name":"subdevice #0",
            "alsa.sync.id":"00000000:00000000:00000000:00000000",
            "api.alsa.card.longname":"XIAOMI-RedmiBookPro162024--TM2309",
            "api.alsa.card.name":"sof-hda-dsp",
            "api.alsa.open.ucm":"true",
            "api.alsa.path":"hw:sofhdadsp,6",
            "api.alsa.pcm.card":"0",
            "api.alsa.pcm.stream":"capture",
            "audio.channels":"4",
            "audio.position":"FL,FR,RL,RR",
            "card.profile.device":"2",
            "client.id":"41",
            "clock.quantum-limit":"8192",
            "device.api":"alsa",
            "device.bus":"pci",
            "device.class":"sound",
            "device.icon-name":"audio-card-analog",
            "device.icon_name":"audio-input-microphone",
            "device.id":"43",
            "device.profile.description":"Digital Microphone",
            "device.profile.name":"HiFi: Mic1: source",
            "device.routes":"1",
            "factory.id":"19",
            "factory.name":"api.alsa.pcm.source",
            "library.name":"audioconvert/libspa-audioconvert",
            "media.class":"Audio/Source",
            "node.description":"Meteor Lake-P HD Audio Controller Digital Microphone",
            "node.driver":"true",
            "node.loop.name":"data-loop.0",
            "node.name":"alsa_input.pci-0000_00_1f.3-platform-skl_hda_dsp_generic.HiFi__Mic1__source",
            "node.nick":"Digital Microphone",
            "node.pause-on-idle":"false",
            "object.id":"52",
            "object.path":"alsa:acp:sofhdadsp:2:capture",
            "object.serial":"52",
            "port.group":"capture",
            "priority.driver":"1648",
            "priority.session":"1648"
        },
        "audio":{
            "objectName":"",
            "muted":false,
            "volume":0.5921478271484375,
            "channels":[3,4,12,13],
            "volumes":[0.5921478271484375,0.5921478271484375,0.5921478271484375,0.5921478271484375]
        },
        "ready":true
    })

}
