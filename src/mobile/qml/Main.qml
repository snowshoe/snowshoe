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
        source: "qrc:///mobile/app/bg_image"
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

    TabsPanel {
        id: tabsPanel
        opacity: 0
        anchors {
            top: panelToggle.bottom
            left: parent.left
            right: parent.right
            topMargin: 32
        }
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
        source: "qrc:///mobile/app/side_shadow"
        z: 99
        anchors {
            left: parent.left
            verticalCenter: parent.verticalCenter
        }
    }
    Image {
        source: "qrc:///mobile/app/side_shadow"
        z: 99
        mirror: true
        anchors {
            right: parent.right
            verticalCenter: parent.verticalCenter
        }
    }


    Image {
        id: plusButton
        opacity: 0
        source: plusButtonMouseArea.pressed ? "qrc:///mobile/nav/btn_plus_pressed" : "qrc:///mobile/nav/btn_plus_unpressed"

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
            if (rootPage.state !== "typeNewUrl")
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
//  BUG: Qml behaves wrong on n9,it sets panelToggle.topsites.visible to false
//       then to true on start up causing a cascade misbehaviour, the workaround
//       is to set the state of the root element on Component.onCompleted.
//  state: "favorites"
    Component.onCompleted: state = "favorites"

    states: [
        State {
            name: "favorites"
            PropertyChanges { target: panelToggle; topSitesButtonSelected: true }
            PropertyChanges { target: plusButton; opacity: 1 }
            PropertyChanges { target: panelToggle; opacity: 1 }
            PropertyChanges { target: topSitesPanel; opacity: 1 }
            PropertyChanges { target: tabsPanel; opacity: 0 }
            PropertyChanges { target: navigationPanel; opacity: 0 }
        },
        State {
            name: "navigation"
            PropertyChanges { target: panelToggle; topSitesButtonSelected: false }
            PropertyChanges { target: plusButton; opacity: 1 }
            PropertyChanges { target: panelToggle; opacity: 1 }
            PropertyChanges { target: topSitesPanel; opacity: 0 }
            PropertyChanges { target: tabsPanel; opacity: 1 }
            PropertyChanges { target: navigationPanel; opacity: 0 }
        },
        State {
            name: "navigationFullScreen"
            PropertyChanges { target: panelToggle; topSitesButtonSelected: false }
            PropertyChanges { target: plusButton; opacity: 0 }
            PropertyChanges { target: panelToggle; opacity: 0 }
            PropertyChanges { target: topSitesPanel; opacity: 0 }
            PropertyChanges { target: tabsPanel; opacity: 0 }
            PropertyChanges { target: navigationPanel; opacity: 1 }
        },
        State {
            name: "typeNewUrl"
            PropertyChanges { target: urlInputPanel; opacity: 1 }
            PropertyChanges { target: plusButton; opacity: 0 }
            PropertyChanges { target: panelToggle; opacity: 0 }
            PropertyChanges { target: topSitesPanel; opacity: 0 }
            PropertyChanges { target: tabsPanel; opacity: 0 }
            PropertyChanges { target: navigationPanel; opacity: 0 }
        }
    ]

    transitions: [
        Transition {
            from: "splash"
            AnchorAnimation { duration: 200; easing.type: Easing.InOutQuad }
        },
        Transition {
            to: "typeNewUrl"
            PropertyAnimation { property: "opacity"; duration: 200; easing.type: Easing.InCubic }
            SequentialAnimation {
                PauseAnimation { duration: 300 }
                ScriptAction { script: urlInputPanel.focusUrlBar() }
            }
        },
        Transition {
            from: "typeNewUrl"
            SequentialAnimation {
                PauseAnimation { duration: 300 }
                PropertyAnimation { property: "opacity"; duration: 200; easing.type: Easing.InCubic }
            }
        },
        Transition {
            from: "navigation"
            to: "navigationFullScreen"
            reversible: true
            NumberAnimation { targets: [navigationPanel, panelToggle, plusButton]; property: "opacity"; duration: 200 }
        }
    ]
}
