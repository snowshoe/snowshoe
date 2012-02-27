/****************************************************************************

 *   Copyright (C) 2011  Instituto Nokia de Tecnologia (INdT)               *
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
    id: rootButton

    property bool disabled

    property string disabledImage
    property string hoveredImage
    property string pressedImage
    property string standardImage

    signal clicked()

    height: buttonImage.height
    width: buttonImage.width

    Image {
        id: buttonImage
        source: {
            if (rootButton.disabled)
                return disabledImage
            if (buttonMouseArea.isPressed)
                return pressedImage
            if (buttonMouseArea.isHovered)
                return hoveredImage
            else
                return standardImage
        }
        MouseArea {
            id: buttonMouseArea
            anchors.fill: parent
            onClicked: rootButton.clicked();
            hoverEnabled: true
            property bool isHovered: false
            property bool isPressed: false
            onEntered: { isHovered = true }
            onExited: { isHovered = false }
            onPressed: { isPressed = true }
            onReleased: { isPressed = false }
        }
    }
}
