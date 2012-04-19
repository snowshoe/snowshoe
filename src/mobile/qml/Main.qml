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

    Image {
        anchors.fill: parent
        source: ":/mobile/app/bg_image"
    }

    PanelToggle {
        id: panelToggle
        anchors {
            top: parent.top
            topMargin: 32
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

    TopSitesPanel {
        id: topSitesPanel
        opacity: 0
        anchors {
            top: panelToggle.bottom
            left: parent.left
            right: parent.right
            topMargin: 32
        }
        onUrlSelected: navigationPanel.openUrlInNewTab(UrlTools.fromUserInput(url))
    }

    NavigationPanel {
        id: navigationPanel
        opacity: 0
        anchors.fill: parent

        onNewTabRequested: urlInputPanel.showForNewTab()
        onUrlInputRequested: urlInputPanel.showForCurrentTab()

        onWebViewMaximized: {
            rootPage.state = "navigationFullScreen";
        }
        onWebViewMinimized: {
            rootPage.state = "navigation";
        }
    }

    Image {
        id: plusButton
        opacity: 0
        source: plusButtonMouseArea.pressed ? ":/mobile/nav/btn_plus_pressed" : ":/mobile/nav/btn_plus_unpressed"

        anchors.top: topSitesPanel.bottom
        anchors.topMargin: 27
        anchors.horizontalCenter: rootPage.horizontalCenter

        MouseArea {
            id: plusButtonMouseArea
            anchors.fill: parent
            onClicked: urlInputPanel.showForNewTab()
        }
    }

    UrlInputPanel {
        id: urlInputPanel

        property bool shouldOpenNewTab: false

        function showForNewTab() {
            shouldOpenNewTab = true;
            _show();
        }

        function showForCurrentTab() {
            shouldOpenNewTab = false;
            _show();
        }

        function _show() {
            text = shouldOpenNewTab ? "" : navigationPanel.url;
            rootPage.previousState = rootPage.state;
            rootPage.state = "typeNewUrl";
        }

        anchors.fill: parent
        opacity: 0
        onUrlRequested: {
            urlInputPanel.unfocusUrlBar();
            navigationPanel.state = "";
            if (shouldOpenNewTab)
                navigationPanel.openUrlInNewTab(url);
            else
                navigationPanel.openUrl(url);
        }
        onCancelRequested: {
            urlInputPanel.unfocusUrlBar();
            rootPage.state = rootPage.previousState;
        }
    }

    property string previousState: ""
    state: "favorites"
    states: [
        State {
            name: "favorites"
            PropertyChanges { target: plusButton; opacity: 1 }
            PropertyChanges { target: topSitesPanel; opacity: 1 }
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
            PropertyChanges { target: urlInputPanel; opacity: 1 }
            PropertyChanges { target: panelToggle; opacity: 0 }
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
                ScriptAction { script: urlInputPanel.focusUrlBar() }
            }
        },
        Transition {
            from: "typeNewUrl"
            to: "navigationFullScreen"
            PropertyAnimation { property: "opacity"; duration: 300; easing.type: Easing.InOutQuad }
        },
        Transition {
            from: "navigation"
            to: "navigationFullScreen"
            reversible: true
            NumberAnimation { targets: [navigationPanel, panelToggle, plusButton]; property: "opacity"; duration: 200 }
        }
    ]
}
