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
import "UiConstants.js" as UiConstants

Item {
    id: rootButton

    property bool disabled

    property string pressedImage
    property string unpressedImage

    signal clicked()
    anchors.verticalCenter: parent.verticalCenter
    height: 57
    width: 56

    Image {
        id: buttonImage
        anchors.centerIn: parent
        source: {
            if (buttonMouseArea.isPressed)
                return pressedImage
            else
                return unpressedImage
        }
    }

    MouseArea {
        id: buttonMouseArea
        anchors.fill: buttonImage
        onClicked: rootButton.clicked();
        property bool isPressed: false
        onPressed: { isPressed = true }
        onReleased: { isPressed = false }
    }
}
