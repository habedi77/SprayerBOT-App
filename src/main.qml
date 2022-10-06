import QtQuick 2.10
import QtMultimedia 5.10
import QtQuick.Extras 1.4
import QtQuick.Layouts 1.2
import LiveVehicleData 1.0
import QtQuick.Window 2.10
import QtQuick.Controls 2.3
import QtQuick.Controls.Styles 1.4
import QtQuick.Controls.Material 2.3

ApplicationWindow {
    id: root

    readonly property int pr: Screen.devicePixelRatio

    visible: true                                   // Whether the window is visible on the screen.
    minimumWidth: 640                               // Hardcoded minimum window Width
    minimumHeight: 480                              // Hardcoded minimum window Height
    color: "Whitesmoke"
    visibility: "Maximized"                         // Window start Maximized on all platforms
    title: qsTr("SprayerBOT")

    header: ToolBar {
        background: Item {
            id: toolbar

            /* This background item helps keep the ToolBar the same "Whitesmoke"
              color specified for the ApplicationWindow */

            anchors.fill: parent
        }

        RowLayout {
            anchors.fill: parent

            EngineStartStop {
                id: startButton

                Text {
                    id: startText

                    text: qsTr("Start")
                    color: "White"

                    font.pixelSize: 12
                    font.weight: Font.Bold
                    font.letterSpacing: 1.5
                    font.capitalization: Font.AllUppercase

                    anchors.fill: parent
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                }

                onClicked: {
                    if (startButton.active) {
                        startButton.checked = true;
                    }
                }

                onActivated: {
                    /* Change the active property of the EngineStartStop element
                      to true and the main color property to indicate that the
                      start button is active */
                    startButton.active = true;
                    startButton.mainColor = "#17a81a";

                    // play all the videos
                    leftPlayer.play();
                    frontPlayer.play();
                    rightPlayer.play();

                    /* Deactivate emergency stop button by changing the EngineStartStop
                       active and mainColor properties, and the DelayButton checked property.
                       This will be done everytime the stat button is pressed regardless of
                       whether or not the stop button was active prior */
                    stopButton.active = false;
                    stopButton.checked = false;
                    stopButton.mainColor = "Red";

                    coverageMap.active = true           // Activate the map's "navigating" state
                    coverageMap.state = "navigating"

                    //liveValue.startUpdates()          // Start receiving updates from agbotwebserver
                    if (sim.start == false) {
                        sim.start = true                // start simulation
                    }
                    else {
                        sim.pause = false
                        rate1.value = sim.appRate1
                        rate2.value = sim.appRate2
                        speedometer.value = sim.speed
                    }

                    /* Start the mahine with nominal status */
                    notifications.setSpecial("clear")
                }
            }

            EngineStartStop {
                id: stopButton

                //                Layout.topMargin: 5
                //                Layout.leftMargin: -5
                //                Layout.rightMargin: 15
                //                Layout.bottomMargin: 5
                //                Layout.alignment: Qt.AlignRight

                text: ""                            // Clears the default text
                mainColor: "Red"
                activeColor: "#b30000"

                Text {
                    id: buttonLabel1

                    text: qsTr("Emergency")

                    width: parent.width
                    color: "White"
                    font.pixelSize: Math.min(8,  Math.ceil(width / 9.5))
                    font.capitalization: Font.AllUppercase
                    fontSizeMode: Text.HorizontalFit
                    font.weight: Font.Bold
                    anchors.left: parent.left
                    anchors.bottomMargin: 70
                    anchors.right: parent.right
                    anchors.top: buttonLabel2.bottom
                    anchors.bottom: parent.bottom
                    style: Text.Normal
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                }

                Text {
                    id: buttonLabel2

                    text: qsTr("Stop")

                    color: "#ffffff"
                    font.pixelSize: 12
                    font.weight: Font.Bold
                    font.letterSpacing: 1.5
                    font.capitalization: Font.AllUppercase
                    anchors.bottomMargin: 27
                    anchors.leftMargin: 2
                    anchors.topMargin: -5
                    anchors.fill: parent
                    verticalAlignment: Text.AlignBottom
                    horizontalAlignment: Text.AlignHCenter
                }

                onClicked: {
                    if (stopButton.active) {
                        stopButton.checked = true;
                    }
                }

                onActivated: {
                    stopButton.active = true;
                    stopButton.mainColor = "#b30000";

                    leftPlayer.pause();
                    frontPlayer.pause();
                    rightPlayer.pause();

                    startButton.active = false
                    startButton.checked = false
                    startButton.mainColor = "Green";

                    coverageMap.active = false
                    // liveValue.stopUpdates()
                    if (sim.start == true) {
                        sim.pause = true                // pause simulation
                    }

                    notifications.setSpecial("stopped")
                }
            }

            NotificationsBar {
                id: notificationsBar
            }

            ButtonAlertPerceived{
                id: buttonAlertPerceived

                Component.onCompleted: {
                    // TODO check if it works
                    buttonAlertPerceived.activated.connect(statusManager.userOverride)
                }
            }

//            AlertSimpleDisplay {
//                id: alertSimpleDisplay

//            }
        }
    } // End of ToolBar

    Item {
        id: contentItem

        anchors.fill: parent

        ColumnLayout {
            anchors.fill: parent

            Item {
                id: videos

                Layout.preferredWidth: parent.width /3
                Layout.preferredHeight: parent.height * 0.35

                RowLayout {
                    spacing: 7
                    anchors.fill: parent


                    VideoPlayer {
                        id: video1

                        source: leftPlayer          // allows for the creation of multiple videos
                        view: "Left Boom"           // video label

                        MediaPlayer {
                            id: leftPlayer

                            source: "../media/left.mp4"
                            loops: MediaPlayer.Infinite
                            onPlaybackStateChanged: video1.state = "after"
                        }
                    }

                    VideoPlayer {
                        id: video2

                        source: frontPlayer
                        view: "Front View"

                        MediaPlayer {
                            id: frontPlayer

                            source: "../media/front.mp4"
                            loops: MediaPlayer.Infinite
                            onPlaybackStateChanged: video2.state = "after"
                        }
                    }

                    VideoPlayer {
                        id: video3

                        source: rightPlayer
                        view: "Right Boom"

                        MediaPlayer {
                            id: rightPlayer

                            source: "../media/right.mp4"
                            loops: MediaPlayer.Infinite
                            onPlaybackStateChanged: video3.state = "after"
                        }
                    }
                }
            } // End of videos

            Item {
                id: graphicalElements

                Layout.preferredWidth: parent.width
                Layout.preferredHeight: parent.height * 0.55

                RowLayout {
                    anchors.fill: parent

                    Item {
                        id: sprayerElements

                        Layout.preferredHeight: parent.height
                        Layout.preferredWidth: parent.width * 0.7

                        RowLayout {
                            anchors.fill: parent

                            Item {
                                id: sprayerInfoContainer

                                Layout.preferredHeight: parent.height
                                Layout.preferredWidth: parent.width * 0.4

                                ColumnLayout {
                                    anchors.fill: parent

                                    Item {
                                        id: tankContainer

                                        Layout.preferredHeight: parent.height * 0.75
                                        Layout.preferredWidth: parent.width

                                        ColumnLayout {
                                            anchors.fill: parent

                                            Item {
                                                id: tank1Container

                                                Layout.preferredWidth: parent.width
                                                Layout.preferredHeight: parent.height / 2.5

                                                RowLayout {
                                                    spacing: 5
                                                    anchors.fill: parent

                                                    TankLevel {
                                                        id: tank1

                                                        name: "Tank 1"
                                                        maxValue: 25
                                                        tickInterval: 5
                                                        minorTickInterval: 0
                                                        Layout.leftMargin: parent.width * 0.0725
                                                        Layout.topMargin: parent.height * 0.25
                                                        Layout.preferredHeight: parent.height * 0.8
                                                        Layout.preferredWidth: Math.min
                                                                               (67.5, parent.width *
                                                                                0.3)
                                                    }

                                                    ApplicationRate {
                                                        id: rate1

                                                        Layout.topMargin: parent.height * 0.25
                                                        Layout.alignment: Qt.AlignCenter

                                                        onWidthChanged: {
                                                            if (width <= 119) {
                                                                Layout.leftMargin = 30;
                                                            } else {
                                                                Layout.leftMargin = -25
                                                            }
                                                        }
                                                    }
                                                }
                                            }

                                            Item {
                                                id: tank2Container

                                                Layout.preferredWidth: parent.width
                                                Layout.preferredHeight: parent.height / 2.5

                                                RowLayout {
                                                    spacing: 5
                                                    anchors.fill: parent

                                                    TankLevel {
                                                        id: tank2

                                                        name: "Tank 2"
                                                        maxValue: 5
                                                        tickInterval: 1
                                                        minorTickInterval: 0
                                                        Layout.leftMargin: parent.width * 0.0925
                                                        Layout.topMargin: parent.height * 0.25
                                                        Layout.preferredHeight: parent.height * 0.8
                                                        Layout.preferredWidth: Math.min
                                                                               (67.5, parent.width *
                                                                                0.3)
                                                    }

                                                    ApplicationRate {
                                                        id: rate2

                                                        Layout.topMargin: parent.height * 0.25
                                                        Layout.alignment: Qt.AlignCenter

                                                        onWidthChanged: {
                                                            if (width <= 119) {
                                                                Layout.leftMargin = 20;
                                                            } else {
                                                                Layout.leftMargin = -35
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    } // End of tankContainer

                                    Item {
                                        id: weatherContainer

                                        Layout.preferredHeight: parent.height * 0.25
                                        Layout.preferredWidth: parent.width

                                        Weather {
                                            anchors.fill: parent
                                        }
                                    } // End of weatherContainer
                                }
                            } // End of sprayerInfoContainer

                            Item {
                                id: boomContainer

                                Layout.preferredWidth: parent.width * 0.6
                                Layout.preferredHeight: parent.height

                                ColumnLayout {
                                    spacing: 0
                                    anchors.fill: parent

                                    Item {
                                        id: labelContainer

                                        Layout.preferredWidth: parent.width
                                        Layout.preferredHeight: parent.height * 0.15
                                        Layout.topMargin: -7.5

                                        Pane {
                                            id: container

                                            width: parent.width * 0.25
                                            height: Math.max(40, width * 0.45)

                                            Material.elevation: 2

                                            anchors {
                                                verticalCenter: parent.verticalCenter
                                                horizontalCenter: parent.horizontalCenter
                                                verticalCenterOffset: 12.5
                                                horizontalCenterOffset: 7
                                            }

                                            Text {
                                                id: valueText

                                                text: boomHeightElement.boomHeightValue.toFixed(0)

                                                font.pixelSize: Math.max(14, parent.width * 0.25)
                                                font.bold: true
                                                color: "Black"
                                                topPadding: 5

                                                anchors {
                                                    verticalCenter: parent.verticalCenter
                                                    horizontalCenter: parent.horizontalCenter
                                                    verticalCenterOffset: -10
                                                    horizontalCenterOffset: -10
                                                }
                                            }

                                            Text {
                                                id: unitLabel

                                                text: " in"

                                                color: "Black"
                                                font.weight: Font.DemiBold
                                                font.pixelSize: Math.max(12, parent.width * 0.2)
                                                anchors.left: valueText.right
                                                anchors.bottom: valueText.bottom

                                            }

                                            Text {
                                                id: label

                                                text: "Boom Height"

                                                color: "black"
                                                bottomPadding: 3.5
                                                font.letterSpacing: 1.15
                                                font.pixelSize: Math.max(8, parent.width * 0.125)

                                                anchors {
                                                    topMargin: 3.5
                                                    bottom: parent.bottom
                                                    top: valueText.bottom
                                                    horizontalCenter: parent.horizontalCenter
                                                }
                                            }
                                        }
                                    } // End of labelContainer

                                    BoomHeight {
                                        id: boomHeightElement

                                        Layout.topMargin: -25
                                    }
                                }
                            } // End of boomContainer
                        }
                    } // End of sprayerElements

                    Item {
                        id: vehicleElements

                        Layout.preferredHeight: parent.height
                        Layout.preferredWidth: parent.width * 0.3

                        ColumnLayout {
                            spacing: 0
                            anchors.fill: parent

                            Item {
                                id: gauges

                                Layout.preferredWidth: parent.width
                                Layout.preferredHeight: parent.height * 0.45

                                RowLayout {
                                    spacing: 5
                                    anchors.fill: parent

                                    Item {
                                        id: travelSpeed

                                        Layout.preferredWidth: parent.width * 0.45
                                        Layout.preferredHeight: parent.height

                                        CircularGauge {
                                            id: speedometer

                                            readonly property string highSpeedWarning: "The machine is moving too fast!"
                                            readonly property string lowSpeedWarning: "The machine is moving too slow!"

                                            height: parent.height * 0.90
                                            width: parent.width

                                            stepSize: 0.1
                                            maximumValue: 9            // maximum speed
                                            anchors.left: parent.left
                                            anchors.leftMargin: parent.width * 0.02
                                            anchors.verticalCenter: parent.verticalCenter

                                            style: SpeedGaugeStyle {}
                                        }
                                    }

                                    Item {
                                        id: engineSpeed

                                        Layout.preferredWidth: parent.width * 0.45
                                        Layout.preferredHeight: parent.height

                                        CircularGauge {
                                            id: tachometer

                                            height: parent.height * 0.90
                                            width: parent.width

                                            stepSize: 0.1
                                            maximumValue: 8            // maximum rev per min
                                            anchors.left: parent.left
                                            anchors.leftMargin: parent.width * 0.015
                                            anchors.verticalCenter: parent.verticalCenter

                                            style: TachometerStyle {}
                                        }
                                    }
                                }
                            }

                            Item {
                                id: mapArea

                                Layout.preferredHeight: parent.height * 0.55
                                Layout.preferredWidth: parent.width

                                CoverageMap {
                                    id: coverageMap

                                    anchors.fill: parent
                                }
                            }
                        }
                    } // End of vehicleElements
                }
            } // End of graphicalElements
        }
    } // End of contentItem

    AlertSoundEffect {
        id: alertSoundEffect
    }

    PhidgetFeedback {
        id: phidgetFeedback
    }


    QtObject {
        id: notifications

        readonly property string startupInstruction: "To begin, press and hold the START button."
        readonly property string restarInstruction: "Press and hold the START button to start the machine"
        readonly property string allClearMessage: "All systems are normal"

        property NotificationsList list : NotificationsList {

        }


        function setSpecial(mode){
            if (mode === "start") list.setSingle(startupInstruction, "off")
            else if (mode === "stopped") list.setSingle(restarInstruction, "off")
            else if (mode === "clear") list.clear()

            statusManager.checkForNewStatus()
        }


        function addWarning(message) {
            if (list.index(message) === -1) {
                list.add(message, "warning")
                statusManager.checkForNewStatus()
            }
        }

        function removeWarning(message) {
            var res = list.removeIfpresent(message)
            if (res === true)
                statusManager.checkForNewStatus()
        }

        function getUnprocessed(){
            return list.getUnprocessed()
        }

        function setProccessed(message){
            return list.process(message)
        }

    }

    StatusManager{
        id: statusManager
        alertSoundEffect: alertSoundEffect
        phidgetFeedback: phidgetFeedback
        notificationsBar: notificationsBar
        buttonAlertPerceived: buttonAlertPerceived
    }


    Timer {
        id: timer

        triggeredOnStart: true
        interval: 5000
        running: true
        repeat: true

        onTriggered: {
            // statusManager.checkForNewStatus()
        }
    }

    Simulation {
        id: sim

        onSpeedChanged: {
            speedometer.value = speed

            if (speed > 0 && speed <= 3) {
                notifications.addWarning(speedometer.lowSpeedWarning)
                notifications.removeWarning(speedometer.highSpeedWarning)
            } else if (speed > 6) {
                notifications.addWarning(speedometer.highSpeedWarning)
                notifications.removeWarning(speedometer.lowSpeedWarning)
            } else {
                notifications.removeWarning(speedometer.lowSpeedWarning)
                notifications.removeWarning(speedometer.highSpeedWarning)
            }
        }

        onRpmChanged: {
            tachometer.value = sim.rpm
        }

        onBoomHeightChanged: {
            boomHeightElement.val = boomHeight

            if (boomHeight > 28) {
                notifications.addWarning(boomHeightElement.highHeightWarning)
                notifications.removeWarning(boomHeightElement.lowHeightWarning)
            } else if (boomHeight < 22) {
                notifications.addWarning(boomHeightElement.lowHeightWarning)
                notifications.removeWarning(boomHeightElement.highHeightWarning)
            } else {
                notifications.removeWarning(boomHeightElement.highHeightWarning)
                notifications.removeWarning(boomHeightElement.lowHeightWarning)
            }
        }

        onTankLevel1Changed: {
            tank1.level = sim.tankLevel1
        }

        onAppRate1Changed: {
            rate1.value = appRate1
        }

        onTankLevel2Changed: {
            tank2.level = sim.tankLevel2
        }

        onAppRate2Changed: {
            rate2.value = appRate2
        }

        onNozzle1StatusChanged: {
            if (nozzle1Status == "blocked") {
                boomHeightElement.changeNozzle1State("blocked")
            } else if (nozzle1Status == "on") {
                boomHeightElement.changeNozzle1State("on")
            } else {
                boomHeightElement.changeNozzle1State("off")
            }
        }
        onNozzle2StatusChanged: {
            if (nozzle2Status == "blocked") {
                boomHeightElement.changeNozzle2State("blocked")
            } else if (nozzle2Status == "on") {
                boomHeightElement.changeNozzle2State("on")
            } else {
                boomHeightElement.changeNozzle2State("off")
            }
        }
        onNozzle3StatusChanged: {
            if (nozzle3Status == "blocked") {
                boomHeightElement.changeNozzle3State("blocked")
            } else if (nozzle3Status == "on") {
                boomHeightElement.changeNozzle3State("on")
            } else {
                boomHeightElement.changeNozzle3State("off")
            }
        }
        onNozzle4StatusChanged: {
            if (nozzle1Status == "blocked") {
                boomHeightElement.changeNozzle4State("blocked")
            } else if (nozzle1Status == "on") {
                boomHeightElement.changeNozzle4State("on")
            } else {
                boomHeightElement.changeNozzle4State("off")
            }
        }
        onNozzle5StatusChanged: {
            if (nozzle1Status == "blocked") {
                boomHeightElement.changeNozzle5State("blocked")
            } else if (nozzle1Status == "on") {
                boomHeightElement.changeNozzle5State("on")
            } else {
                boomHeightElement.changeNozzle5State("off")
            }
        }
        onNozzle6StatusChanged: {
            if (nozzle1Status == "blocked") {
                boomHeightElement.changeNozzle6State("blocked")
            } else if (nozzle1Status == "on") {
                boomHeightElement.changeNozzle6State("on")
            } else {
                boomHeightElement.changeNozzle6State("off")
            }
        }
    }

    Loader {
        source: "Simulation.qml"
        onLoaded: {
            tank1.level = sim.tankLevel1
            tank2.level = sim.tankLevel2
            rate1.value = sim.appRate1
            rate2.value = sim.appRate2
            speedometer.value = sim.speed
            boomHeightElement.val = sim.boomHeight
        }
    }

    onClosing: {
        leftPlayer.stop()
        frontPlayer.stop()
        rightPlayer.stop()
        sim.start = false
        // liveValue.stopUpdates()
    }
} // End of ApplicationWindow
