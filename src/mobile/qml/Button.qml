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

    property string disabledImage
    property string pressedImage
    property string standardImage

    signal clicked()
    anchors.verticalCenter: parent.verticalCenter
    height: navigationBar.navBarButtonHeight // Use buttonImage.height when the new icons get ready!
    width: navigationBar.navBarButtonWidthPortrait // Use buttonImage.width when the new icons get ready!

    Image {
        id: buttonImage
        anchors.fill: parent
        source: {
            if (rootButton.disabled)
                return disabledImage
            if (buttonMouseArea.isPressed)
                return pressedImage
            else
                return standardImage
        }
    }
    MouseArea {
        id: buttonMouseArea
        anchors.fill: parent
        onClicked: rootButton.clicked();
        property bool isPressed: false
        onPressed: { isPressed = true }
        onReleased: { isPressed = false }
    }
}
