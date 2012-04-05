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

Rectangle {
    id: rootPage
    width: UiConstants.PortraitWidth
    height: UiConstants.PortraitHeight
    color: "#aaa"
    clip: true
    property bool shouldOpenNewTab: false

    Image {
        anchors.fill: parent
        source: ":/mobile/app/bg_image"
    }

    PanelToggle {
        id: panelToggle
        anchors {
            top: parent.top
            topMargin: 24
            horizontalCenter: parent.horizontalCenter
        }
        navigationEnabled: navigationPanel.hasOpennedTabs
        onTopSitesSelected: {
            rootPage.state = "favorites";
        }
        onTabsSelected: {
            rootPage.state = "navigation";
        }
    }

    FavoritesPanel {
        id: favoritesPanel
        opacity: 0
        anchors {
            top: panelToggle.bottom
            left: parent.left
            right: parent.right
            bottom: plusButton.top
            topMargin: 24
        }
        onUrlSelected: navigationPanel.openUrl(UrlTools.fromUserInput(url), true)
    }

    NavigationPanel {
        id: navigationPanel
        opacity: 0
        anchors.fill: parent

        onWebViewMaximized: {
            rootPage.state = "navigationFullScreen";
            navigationPanel.setFullScreen(true);
        }
        onWebViewMinimized: {
            rootPage.state = "navigation";
            navigationPanel.setFullScreen(false);
        }

        onUrlInputFocusChanged: {
            if (urlInputFocus)
                rootPage.showUrlInputForCurrentTab()
        }
    }

    Image {
        id: plusButton
        opacity: 0
        source: ":/mobile/nav/btn_plus"
        width: 56
        height: 57

        anchors.bottom: parent.bottom
        anchors.bottomMargin: 24
        anchors.horizontalCenter: rootPage.horizontalCenter

        MouseArea {
            anchors.fill: parent
            onClicked: rootPage.showUrlInputForNewTab()
        }
    }

    Rectangle {
        id: urlArea
        color: "white"
        opacity: 0
        anchors.fill: rootPage

        Item {
            id: urlBarBackground
            height: 100
            anchors {
                bottom: urlArea.bottom
                left: urlArea.left
                right: urlArea.right
            }

            Image {
                source: ":/mobile/url/bg_typing"
                anchors { bottom: parent.bottom; left: parent.left; right: parent.right }
            }

            UrlBar {
                id: urlBar
                anchors {
                    top: parent.top
                    bottom: parent.bottom
                    left: parent.left
                    right: cancelButton.left
                    topMargin: 21
                    bottomMargin: 22
                    leftMargin: UiConstants.DefaultMargin
                    rightMargin: UiConstants.NavBarShortMargin
                }
                verticalAlignment: TextInput.AlignVCenter
                input.focus: false

                onAccepted: {
                    navigationPanel.openUrl(UrlTools.fromUserInput(urlBar.text), rootPage.shouldOpenNewTab)
                }

                Image {
                    source: clearUrlButton.pressed ? ":/mobile/url/btn_erase_pressed" : ":/mobile/url/btn_erase_unpressed"
                    visible: urlBar.text != ""
                    anchors {
                        verticalCenter: parent.verticalCenter
                        right: parent.right
                    }
                    MouseArea {
                        id: clearUrlButton
                        anchors.fill: parent
                        onClicked: urlBar.text = ""
                    }
                }
            }
            Button {
                id: cancelButton
                anchors {
                    right: parent.right
                    topMargin: 21
                    bottomMargin: 22
                    rightMargin: UiConstants.DefaultMargin
                }
                pressedImage: ":/mobile/url/btn_cancel_pressed"
                unpressedImage: ":/mobile/url/btn_cancel_unpressed"
                visible: true
                onClicked: rootPage.state = rootPage.previousState
            }
        }

        UrlSuggestions {
            id: urlSuggestions
            width: rootPage.width
            clip: true
            anchors { top: urlArea.top; bottom: urlBarBackground.top; }
            onSuggestionSelected: {
                navigationPanel.openUrl(UrlTools.fromUserInput(suggestedUrl), rootPage.shouldOpenNewTab)
            }
            onSearchSelected: {
                var searchUrl = "http://www.google.com/search?q=" + urlBar.text.replace(" ", "+")
                navigationPanel.openUrl(searchUrl, rootPage.shouldOpenNewTab)
            }
            opacity: urlBar.text != "" && urlBar.text.length > 0

            Image {
                id: separator
                source: ":/mobile/scrollbar/suggestions_separator"
                anchors { left: parent.left; right: parent.right; bottom: parent.bottom }
            }
        }
    }

    property string previousState: ""
    state: "favorites"
    states: [
        State {
            name: "favorites"
            PropertyChanges { target: plusButton; opacity: 1 }
            PropertyChanges { target: favoritesPanel; opacity: 1 }
        },
        State {
            name: "navigation"
            StateChangeScript { script: panelToggle.resetToTabs() }
            PropertyChanges { target: plusButton; opacity: 1 }
            PropertyChanges { target: navigationPanel; opacity: 1 }
        },
        State {
            name: "navigationFullScreen"
            StateChangeScript { script: panelToggle.resetToTabs() }
            PropertyChanges { target: panelToggle; opacity: 0 }
            PropertyChanges { target: navigationPanel; opacity: 1 }
            AnchorChanges { target: panelToggle; anchors.bottom: parent.top; anchors.top: undefined }
            AnchorChanges { target: plusButton; anchors.bottom: undefined; anchors.top: parent.bottom }
        },
        State {
            name: "typeNewUrl"
            PropertyChanges { target: urlSuggestions; contentY: 0 }
            PropertyChanges { target: urlArea; opacity: 1 }
        }
    ]

    transitions: [
        Transition {
            from: "splash"
            AnchorAnimation { duration: 200; easing.type: Easing.InOutQuad }
        },
        Transition {
            to: "typeNewUrl"
            PropertyAnimation { property: "opacity"; duration: 300 }
            SequentialAnimation {
                AnchorAnimation { duration: 300; easing.type: Easing.InOutQuad }
                PropertyAction { target: urlBar.input; property: "focus"; value: "true" }
            }
        },
        Transition {
            from: "typeNewUrl"
            to: "navigationFullScreen"
            SequentialAnimation {
                PropertyAction { target: urlBar.input; property: "focus"; value: "false" }
                PropertyAnimation { property: "opacity"; duration: 300; easing.type: Easing.InOutQuad }
            }
        },
        Transition {
            from: "navigation"
            to: "navigationFullScreen"
            reversible: true
            SequentialAnimation {
                NumberAnimation { targets: [navigationPanel, panelToggle, plusButton]; property: "opacity"; duration: 200 }
                PropertyAction { target: urlArea; property: "opacity" }
            }
        }
    ]

    function showUrlInputForNewTab() {
        urlBar.text = "";
        rootPage.shouldOpenNewTab = true;
        rootPage.state = "typeNewUrl";
    }

    function showUrlInputForCurrentTab() {
        urlBar.text = navigationPanel.url;
        rootPage.shouldOpenNewTab = false;
        rootPage.previousState = rootPage.state;
        rootPage.state = "typeNewUrl";
    }
}
