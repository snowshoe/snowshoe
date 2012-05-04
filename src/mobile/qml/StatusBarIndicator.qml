/****************************************************************************
 *   Copyright (C) 2012  Instituto Nokia de Tecnologia (INdT)               *
 *                                                                          *
 *   This file may be used under the terms of the GNU Lesser                *
 *   General Public License version 2.1 as published by the Free Software   *
 *   Foundation and appearing in the file LICENSE.LGPL included in the      *
 *   packaging of this file.  Please review the following information to    *
 *   ensure the GNU Lesser General Public License version 2.1 requirements  *
 *   will be met: http://www.gnu.org/licenses/old-licenses/lgpl-2.1.html.   *
 *                                                                          *
 *   This program is distributed in the hope that it will be useful,        *
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of         *
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the          *
 *   GNU Lesser General Public License for more details.                    *
 ****************************************************************************/

import QtQuick 2.0

Image {
    z: 1
    property bool active: true
    property int loadProgress

    source: active ? "qrc:///mobile/indicator/loading_active" : "qrc:///mobile/indicator/loading_inactive"

    Image {
        id: progressIndicator
        anchors.fill: parent
        visible: loadProgress > 0
        source: "qrc:///mobile/indicator/loading_" + loadProgress

        states: [
            State {
                name: "hideProgress"; when: loadProgress === 100
                PropertyChanges { target: progressIndicator; opacity: 0 }
            }
        ]

        transitions: Transition {
            from: ""; to: "hideProgress"
            PropertyAnimation { target: progressIndicator; properties: "opacity"; duration: 200 }
        }

    }
}

