/****************************************************************************
**
** Copyright (C) 2017 The Qt Company Ltd.
** Contact: https://www.qt.io/licensing/
**
** This file is part of the examples of the Qt Toolkit.
**
** $QT_BEGIN_LICENSE:BSD$
** Commercial License Usage
** Licensees holding valid commercial Qt licenses may use this file in
** accordance with the commercial license agreement provided with the
** Software or, alternatively, in accordance with the terms contained in
** a written agreement between you and The Qt Company. For licensing terms
** and conditions see https://www.qt.io/terms-conditions. For further
** information use the contact form at https://www.qt.io/contact-us.
**
** BSD License Usage
** Alternatively, you may use this file under the terms of the BSD license
** as follows:
**
** "Redistribution and use in source and binary forms, with or without
** modification, are permitted provided that the following conditions are
** met:
**   * Redistributions of source code must retain the above copyright
**     notice, this list of conditions and the following disclaimer.
**   * Redistributions in binary form must reproduce the above copyright
**     notice, this list of conditions and the following disclaimer in
**     the documentation and/or other materials provided with the
**     distribution.
**   * Neither the name of The Qt Company Ltd nor the names of its
**     contributors may be used to endorse or promote products derived
**     from this software without specific prior written permission.
**
**
** THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
** "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
** LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
** A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
** OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
** SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
** LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
** DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
** THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
** (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
** OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE."
**
** $QT_END_LICENSE$
**
****************************************************************************/


import Weather 1.0
import QtQuick 2.10
import QtQuick.Layouts 1.10
import QtQuick.Controls 2.10

Item {
    id: weatherInfo

    state: "loading"

    AppModel {
        id: model

        onReadyChanged: {
            if (model.ready)
                weatherInfo.state = "ready"
            else
                weatherInfo.state = "loading"
        }
    }

    Item {
        id: waiting

        anchors.fill: parent

        Text {
            text: "Loading weather data..."
            anchors.centerIn: parent
            font.pointSize: 12
        }
    }

    Item {
        id: ready

        anchors.fill: parent

        RowLayout {
            anchors.fill: parent

            RectangularButton {
                id: current

                Layout.leftMargin: parent.width * 0.175
                label: "Current Weather"

                CurrentWeather {
                    id: currentWeather

                    x: parent.width
                    y: -height
                    width: weatherInfo.width
                    height: weatherInfo.height * 2
                }

                onClicked: {
                    currentWeather.open()
                }
            }

            RectangularButton {
                id: forecastButton

                label: "Weather Forecast"

                Forecast {
                    id: weatherForecast
                    model: model

                    x: parent.width
                    y: -height
                    width: weatherInfo.width
                    height: weatherInfo.height * 2
                }

                onClicked: {
                    weatherForecast.open()
                }
            }
        }
    }

    states: [
        State {
            name: "loading"
            PropertyChanges { target: ready; opacity: 0 }
            PropertyChanges { target: waiting; opacity: 1 }
        },
        State {
            name: "ready"
            PropertyChanges { target: ready; opacity: 1 }
            PropertyChanges { target: waiting; opacity: 0 }
        }
    ]
}
