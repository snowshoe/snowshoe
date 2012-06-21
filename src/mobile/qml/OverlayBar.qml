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

    property bool pin: false

    signal showThumbnails()
    signal openNewTab()
    signal pinToggled()

    Item {
        id: overlayBarBase
        anchors.fill: parent

        Button {
            id: buttonThumbview
            anchors {
                left: parent.left
                leftMargin: UiConstants.OverlayBarSideMargin
            }
            pressedImage: "qrc:///mobile/overlaybar/btn_thumbview_pressed"
            unpressedImage: "qrc:///mobile/overlaybar/btn_thumbview_unpressed"
            onClicked: overlayBar.showThumbnails()
        }

        Button {
            id: buttonShare
            anchors {
                left: buttonThumbview.right
                leftMargin: UiConstants.OverlayBarInsideMargin
            }
            pressedImage: "qrc:///mobile/overlaybar/btn_share_pressed"
            unpressedImage: "qrc:///mobile/overlaybar/btn_share_unpressed"
            onClicked: null
        }

        Button {
            id: buttonPlus
            anchors {
                left: buttonShare.right
                right: buttonPin.left
            }
            pressedImage: "qrc:///mobile/overlaybar/btn_plus_pressed"
            unpressedImage: "qrc:///mobile/overlaybar/btn_plus_unpressed"
            onClicked: overlayBar.openNewTab()
        }

        Button {
            id: buttonPin
            anchors {
                right: buttonSettings.left
                rightMargin: UiConstants.OverlayBarInsideMargin
            }
            pressedImage: pin ? "qrc:///mobile/overlaybar/btn_pin_unpressed" : "qrc:///mobile/overlaybar/btn_pin_pressed"
            unpressedImage: pin ? "qrc:///mobile/overlaybar/btn_pin_pressed" : "qrc:///mobile/overlaybar/btn_pin_unpressed"
            onClicked: {
                pin = !pin;
                overlayBar.pinToggled();
            }
        }

        Button {
            id: buttonSettings
            anchors {
                right: parent.right
                rightMargin: UiConstants.OverlayBarSideMargin
            }
            pressedImage: "qrc:///mobile/overlaybar/btn_settings_pressed"
            unpressedImage: "qrc:///mobile/overlaybar/btn_settings_unpressed"
            onClicked: null
        }
    }
}
