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
    id: overlayBar
    height: UiConstants.OverlayBarHeight

    property bool favorite: false

    signal showThumbnails()
    signal openNewTab()
    signal favoriteToggled()

    Item {
        id: overlayBarBase
        anchors.fill: parent

        Button {
            id: buttonThumbview
            anchors {
                left: parent.left
                leftMargin: UiConstants.OverlayBarLongMargin
            }
            pressedImage: "qrc:///mobile/overlaybar/btn_thumbview_pressed"
            unpressedImage: "qrc:///mobile/overlaybar/btn_thumbview_unpressed"
            onClicked: overlayBar.showThumbnails()
        }

        Button {
            id: buttonPlus
            anchors.horizontalCenter: parent.horizontalCenter
            pressedImage: "qrc:///mobile/overlaybar/btn_plus_pressed"
            unpressedImage: "qrc:///mobile/overlaybar/btn_plus_unpressed"
            onClicked: overlayBar.openNewTab()
        }

        Button {
            id: buttonFavorites
            anchors {
                right: parent.right
                rightMargin: UiConstants.OverlayBarLongMargin
            }
            pressedImage: favorite ? "qrc:///mobile/overlaybar/btn_favorite_unpressed" : "qrc:///mobile/overlaybar/btn_favorite_pressed"
            unpressedImage: favorite ? "qrc:///mobile/overlaybar/btn_favorite_pressed" : "qrc:///mobile/overlaybar/btn_favorite_unpressed"
            onClicked: overlayBar.favoriteToggled()
        }
    }
}
