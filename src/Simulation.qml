import QtQuick 2.12

Item {
    id: valueSource

    property real rpm: 0
    property real speed: 0
    property bool start: false  // starts the animation, if true
    property bool pause: false  // pauses the animation, if true
    property real boomHeight: 20

    // application rate control
    property int appRate1: 0
    property int appRate2: 0

    // tank level control
    property real tankLevel2: 5
    property real tankLevel1: 25

    // nozzle state control
    property string nozzle1Status: "off"
    property string nozzle2Status: "off"
    property string nozzle3Status: "off"
    property string nozzle4Status: "off"
    property string nozzle5Status: "off"
    property string nozzle6Status: "off"

    property real timeInState: 120

    state: "warmup"
    states: [
        State {
            name: "warmup"
            PropertyChanges { target: valueSource; timeInState: 120 }
        },
        State {
            name: "tutorial"
            PropertyChanges { target: valueSource; timeInState: 60 }
        },

        // State {
        //     name: "tutorial_clear"
        //     PropertyChanges { target: valueSource; timeInState: 120 }
        // },
        // State {
        //     name: "tutorial_visual"
        //     PropertyChanges { target: valueSource; timeInState: 120 }
        // },
        // State {
        //     name: "tutorial_auditory"
        //     PropertyChanges { target: valueSource; timeInState: 120 }
        // },
        // State {
        //     name: "tutorial_tactile"
        //     PropertyChanges { target: valueSource; timeInState: 120 }
        // },
        State {
            name: "experminets"
            PropertyChanges { target: valueSource; timeInState: 300 }
        },
        State {
            name: "finished"
            PropertyChanges { target: valueSource; timeInState: 9000 }
        }
    ]

    Timer {
        interval: timeInState * 1000;
        running: true; repeat: true
        onTriggered: changeState()
    }

    function changeState() {
        if (state === "warmup")
            state = "tutorial"
        else if (state === "tutorial")
            state = "experminets"
        else if (state === "experminets")
            state = "finished"
    }

    Component.onCompleted: {
        var endTime = 120

        var speedAlerts = [
                    {"value": 1,   "duration": 2,  "time": 7},
                    {"value": 2.4, "duration": 1,  "time": 20},
                    {"value": 7,   "duration": 10, "time": 36},
                ]


        var rpmAlerts = [
                    {"value": 7,   "duration": 3,  "time": 12},
                    {"value": 10,  "duration": 6,  "time": 27},
                    {"value": 6.5, "duration": 3,  "time": 40},
                ]


        var broomAlerts = [
                    {"value": 20,  "duration": 2,  "time": 38},
                    {"value": 28,  "duration": 6,  "time": 45},
                ]



        setCompAnimation(speedAlerts, wobbleSpeed, "speed", speedAnim, endTime)
        setCompAnimation(rpmAlerts, wobbleRpm, "rpm", rpmAnim, endTime)

         setCompAnimation(broomAlerts, wobbleBroom, "boomHeight", broomAnim, endTime)
        // setCompAnimation(appRate1lerts, wobbleAppRate1, "appRate1", appRate1Anim, endTime)
        // setCompAnimation(appRate2Alerts, wobbleAppRate2, "appRate2", appRate2Anim, endTime)

        setNozzelAnimation(endTime)

    }

    function setNozzelAnimation(endTime){

        var nozzel1Alerts = [
                    {"value": "blocked",  "duration": 5,  "time": 25},
                    {"value": "blocked",  "duration": 5,  "time": 55},
                ]

        var nozzel2Alerts = [
                    {"value": "blocked",  "duration": 5,  "time": 35},
                ]

        var nozzel3Alerts = []
        var nozzel4Alerts = []
        var nozzel5Alerts = []
        var nozzel6Alerts = []

        nozzelAnim1.animations = makeNozzelAnimation(nozzel1Alerts, endTime, "nozzle1Status")
        nozzelAnim2.animations = makeNozzelAnimation(nozzel2Alerts, endTime, "nozzle2Status")
        nozzelAnim3.animations = makeNozzelAnimation(nozzel3Alerts, endTime, "nozzle3Status")
        nozzelAnim4.animations = makeNozzelAnimation(nozzel4Alerts, endTime, "nozzle4Status")
        nozzelAnim5.animations = makeNozzelAnimation(nozzel5Alerts, endTime, "nozzle5Status")
        nozzelAnim6.animations = makeNozzelAnimation(nozzel6Alerts, endTime, "nozzle6Status")
    }

    QtObject {
        id: dynamicContainer
        // A dummy object to add new objects to
    }

    ParallelAnimation {
        id: parAnim

        SequentialAnimation
        {
            id: speedAnim
        }

        SequentialAnimation
        {
            id: rpmAnim
        }

        SequentialAnimation
        {
            id: broomAnim
        }

        SequentialAnimation
        {
            id: appRate1Anim
        }

        SequentialAnimation
        {
            id: appRate2Anim
        }

        SequentialAnimation
        {
            id: nozzelAnim1
        }

        SequentialAnimation
        {
            id: nozzelAnim2
        }

        SequentialAnimation
        {
            id: nozzelAnim3
        }

        SequentialAnimation
        {
            id: nozzelAnim4
        }

        SequentialAnimation
        {
            id: nozzelAnim5
        }

        SequentialAnimation
        {
            id: nozzelAnim6
        }

        running: valueSource.start
        paused: valueSource.pause
        loops: Animation.Infinite

        onPausedChanged: {
            if (valueSource.pause == true) {
                appRate1 = 0
                appRate2 = 0
                speed = 0
                rpm = 0
                nozzle1Status = "off"
                nozzle2Status = "off"
                nozzle3Status = "off"
                nozzle4Status = "off"
                nozzle5Status = "off"
                nozzle6Status = "off"
            }
            else {
                nozzle1Status = "on"
                nozzle2Status = "on"
                nozzle3Status = "on"
                nozzle4Status = "on"
                nozzle5Status = "on"
                nozzle6Status = "on"
            }
        }
    }

    Component
    {
        id: compSmoothAnim

        SmoothedAnimation {
            //target: gauge
            //property: "value";
            //to: 0
            //duration: 0
            velocity: -1
            alwaysRunToEnd: true
        }
    }

    Component
    {
        id: comptPauseAnim
        PauseAnimation {
            //duration: 200
            alwaysRunToEnd: true
        }
    }

    Component
    {
        id: comptPropAnim
        PropertyAnimation {
            // target: valueSource
            // property: "nozzle1Status"
            // to: "on"
        }
    }



    function makeNozzelAnimation(alerts, endTime, nozzelName){
        // valueArrayFromAlert
        var filled_time = 0
        var values = [];

        alerts.sort(function(a, b) { return a.time - b.time; })

        for (var i = 0; i < alerts.length; i++) {
            var alert = alerts[i]

            // set to "on" until alert time
            if (filled_time < alert.time) {
                values.push({ value: "on", duration: 0, pause: false })
                values.push({ value: "on", duration: alert.time - filled_time, pause: true})
                filled_time = alert.time
            }

            // set to alert value for duration
            values.push({ value: alert.value, duration: 0, pause: false })
            values.push({ value: alert.value, duration: alert.duration, pause: true })
        }

        // fill until endTime with "on"
        if (filled_time < endTime) {
            values.push({ value: "on", duration: 0, pause: false })
            values.push({ value: "on", duration: endTime - filled_time, pause: true })
            filled_time = endTime
        }

        //createListOfAnimation(values, valueSource, propName)
        var listAnim = []
        for(i = 0; i < values.length; i++) {
            var item = values[i]
            var obj

            if (item.pause === true){
                obj = comptPauseAnim.createObject(dynamicContainer, {
                                                      "duration": item.duration * 1000
                                                  })
            } else {
                obj = comptPropAnim.createObject(dynamicContainer, {
                                                      "target": valueSource,
                                                      "property": nozzelName,
                                                      "to": item.value,
                                                  })
            }
            print(`${item.value} in ${item.duration * 1000} | ${item.pause} ${nozzelName}`)
            listAnim.push(obj)
        }

        return listAnim
    }

    function setCompAnimation(alerts, wobbleFunction, propName, animComponent, endTime){
        var values = valueArrayFromAlert(alerts, endTime, wobbleFunction)
        var anims= createListOfAnimation(values, valueSource, propName)
        animComponent.animations = anims
    }

    function createListOfAnimation(valueArray, targetObj, targetProp) {
        var listAnim = []

        for(var i = 0; i < valueArray.length; i++) {
            var item = valueArray[i]
            var obj

            if (item.pause === true){
                obj = comptPauseAnim.createObject(dynamicContainer, {
                                                      "duration": item.duration * 1000
                                                  })
            } else {
                obj = compSmoothAnim.createObject(dynamicContainer, {
                                                      "target": targetObj,
                                                      "property": targetProp,
                                                      "to": item.value,
                                                      "duration": item.duration * 1000
                                                  })
            }

            listAnim.push(obj)
            print(`${item.value} in ${item.duration * 1000} | ${item.pause} ${targetProp}`)
        }

        return listAnim
    }

    function valueArrayFromAlert(listAlerts, endTime, wobbleFunction) {
        var trans_time = 1.2
        var pasue_time = 0.5

        var filled_time = 0
        var result = [];
        var tmp

        listAlerts.sort(function(a, b) { return a.time - b.time; })

        for (var i = 0; i < listAlerts.length; i++) {
            var alert = listAlerts[i]

            // fill with wobble until alert time
            while (filled_time < alert.time){
                filled_time += trans_time + pasue_time
                tmp = wobbleFunction()
                result.push({ value: tmp, duration: trans_time, pause: false})
                result.push({ value: tmp, duration: pasue_time, pause: true })
            }

            // tranistion to alert and stay for duration
            filled_time += trans_time + alert.duration
            result.push({ value: alert.value, duration: trans_time, pause: false })
            result.push({ value: alert.value, duration: alert.duration, pause: true })
        }

        // fill until endTime with wobble
        while (filled_time < endTime){
            filled_time += trans_time + pasue_time
            tmp = wobbleFunction()
            result.push({ value: tmp, duration: trans_time, pause: false})
            result.push({ value: tmp, duration: pasue_time, pause: true })
        }

        return result
    }

    function randomNum(min, max, div){
        var offset = max - min + 1
        var val = Math.floor(Math.random() * offset) + min

        return val / div
    }

    function wobbleSpeed(){
        // green zone: 3-6
        // wobble around 3.9
        return randomNum(32, 46, 10)
    }

    function wobbleRpm(){
        // green zone: 0-6
        // wobble around 2.3
        return randomNum(20, 26, 10)
    }

    function wobbleBroom(){
        // green zone: 22-8
        // wobble around 25
        return randomNum(24, 26, 1)
    }

    function wobbleAppRate1(){
        // wobble around 23
        return randomNum(20, 26, 1)
    }

    function wobbleAppRate2(){
        // wobble around 20
        return randomNum(17, 26, 1)
    }
}
