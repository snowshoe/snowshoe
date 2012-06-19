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
Item {
    id : root
    property Flickable flickableItem
    property int hideTimeout: 600
    property real size: 4

    anchors.fill: flickableItem

    Item {
        id: verticalIndicator
        opacity: 0
        width: root.size
        height: flickableItem.height - size

        anchors.right: root.right

        Rectangle {
            x: 0
            y: Math.min(parent.height - height, Math.max(0, flickableItem.visibleArea.yPosition * verticalIndicator.height))

            radius: 10
            color: "black"
            border.color: "gray"
            border.width: 1
            opacity: 0.5
            smooth: true;

            width: root.size
            height: flickableItem.visibleArea.heightRatio * verticalIndicator.height;
        }

        states: [
            State {
                name: "active"
                when: flickableItem.movingVertically
                PropertyChanges {
                    target: verticalIndicator
                    opacity: 1
                }
            }
        ]

        transitions: [
            Transition {
                NumberAnimation {
                    target: verticalIndicator
                    properties: "opacity"
                    duration: hideTimeout
                }
            }
        ]
    }

}
