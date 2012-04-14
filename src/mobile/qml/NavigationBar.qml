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
    id: navigationBar

    property QtObject currentWebView: null
    property string url: currentWebView ? currentWebView.url : ""

    signal urlInputRequested()
    signal backRequested()
    signal forwardRequested()
    signal stopRequested()
    signal reloadRequested()

    height: urlBar.height
    anchors {
        left: parent.left
        right: parent.right
    }

    Button {
        id: buttonBack
        anchors {
            left: parent.left
            leftMargin: UiConstants.NavBarLongMargin
        }
        pressedImage: ":/mobile/navbar/btn_nav_back_pressed"
        unpressedImage: ":/mobile/navbar/btn_nav_back_unpressed"
        visible: { currentWebView ? currentWebView.canGoBack : false }
        onClicked: {
            currentWebView.goBack()
            backRequested()
        }
    }

    Button {
        id: buttonNext
        anchors {
            left: { buttonBack.visible ? buttonBack.right : parent.left }
            leftMargin: buttonBack.visible ? UiConstants.NavBarShortMargin : UiConstants.NavBarLongMargin
        }
        pressedImage: ":/mobile/navbar/btn_nav_forward_pressed"
        unpressedImage: ":/mobile/navbar/btn_nav_forward_unpressed"
        visible: { currentWebView ? currentWebView.canGoForward : false }
        onClicked: {
            currentWebView.goForward()
            forwardRequested()
        }
    }

    BorderImage {
        id: urlBar
        border { left: 26; top: 26; right: 26; bottom: 26 }
        horizontalTileMode: BorderImage.Repeat
        verticalTileMode: BorderImage.Repeat
        anchors {
            left: { buttonNext.visible ? buttonNext.right : (buttonBack.visible ? buttonBack.right : parent.left) }
            leftMargin: buttonNext.visible || buttonBack.visible ? UiConstants.NavBarShortMargin : UiConstants.NavBarLongMargin
            verticalCenter: parent.verticalCenter
            right: parent.right
            rightMargin: UiConstants.NavBarLongMargin
        }
        source: ":/mobile/navbar/url_input"
        Item {
            anchors {
                fill: parent
                rightMargin: reloadStopButton.width
            }
            clip: true
            Text {
                id: input
                anchors {
                    fill: parent
                    topMargin: 15
                    leftMargin: 15
                    verticalCenter: parent.verticalCenter
                }
                font.pixelSize: UiConstants.DefaultFontSize
                font.family: UiConstants.DefaultFontFamily
                color: UiConstants.PrimaryColor
                text: navigationBar.url
            }
            MouseArea {
                anchors.fill: parent
                onPressed: navigationBar.urlInputRequested()
            }
        }
        Button {
            id: reloadStopButton
            property bool loading: { currentWebView ? currentWebView.loading : false }
            anchors.right: parent.right
            pressedImage: { loading ? ":/mobile/navbar/btn_nav_stop_pressed" : ":/mobile/navbar/btn_nav_reload_pressed" }
            unpressedImage: { loading ? ":/mobile/navbar/btn_nav_stop_unpressed" : ":/mobile/navbar/btn_nav_reload_unpressed" }
            onClicked: {
                if (loading) {
                    currentWebView.stop();
                    stopRequested();
                } else {
                    currentWebView.reload();
                    reloadRequested();
                }
            }
        }
    }
}
