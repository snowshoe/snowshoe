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
import QtWebKit 3.0
// What to do on Qt5 !?
import "UiConstants.js" as UiConstants
import "tabmanager.js" as TabManager

Item {
    id: navigationPanel
    property bool hasOpennedTabs: false
    signal webViewMaximized()
    signal webViewMinimized()
    property alias urlInputFocus: navigationBar.urlInputFocus
    property alias url: navigationBar.url
    property QtObject visibleTab: null

    Connections {
        target: visibleTab
        onLoadingChanged: {
            if (navigationPanel.state !== "withNavigationBar")
                return;
            navigationBarHidingTimer.updateStateForCurrentTab();
        }
    }

    NavigationOverlay {
        id: overlay
        visible: false
        anchors {
            top: parent.top
            bottom: tabBar.top
            left: parent.left
            right: parent.right
        }

        onShowThumbnails: {
            navigationPanel.state = "";
            navigationPanel.webViewMinimized();
        }

        onCloseTab: {
            closeCurrentTab();
            navigationPanel.state = "";
        }

        onDismissOverlay: {
            navigationPanel.state = "";
        }

        onGoToNextTab: {
            TabManager.goToNextTab();
            visibleTab = TabManager.getCurrentTab();
        }

        onGoToPreviousTab: {
            TabManager.goToPreviousTab();
            visibleTab = TabManager.getCurrentTab();
        }
    }

    NavigationBar {
        id: navigationBar
        currentWebView: navigationPanel.visibleTab
        anchors.top: parent.bottom

        Timer {
            id: navigationBarHidingTimer
            interval: 2000
            onTriggered: {
                navigationPanel.state = "";
            }

            function updateStateForCurrentTab() {
                if (navigationPanel.visibleTab.loading) {
                    navigationPanel.state = "withNavigationBar";
                    stop();
                } else
                    restart();
            }
        }
    }

    Item {
        id: tabBar
        width: UiConstants.PortraitWidth
        height: UiConstants.TabBarHeight
        anchors.bottom: navigationBar.top
        anchors.left: parent.left
        anchors.right: parent.right

        Image {
            source: ":/mobile/tabs/bg_image"
            anchors.fill: parent
        }

        Row {
            id: tabBarRow
            anchors.centerIn: parent
            spacing: 10
        }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                navigationPanel.state = "withNavigationBarAndOverlay";
            }
        }

        states: State {
            name: "hidden"
            PropertyChanges { target: tabBar; visible: false; }
        }
    }

    states: [
        State {
            name: "withNavigationBar"
            AnchorChanges { target: navigationBar; anchors.top: undefined; anchors.bottom: parent.bottom }
        },
        State {
            name: "withNavigationBarAndOverlay"
            extend: "withNavigationBar"
            PropertyChanges { target: overlay; visible: true }
            StateChangeScript { script: navigationBarHidingTimer.stop() }
        }
    ]

    transitions: Transition {
        AnchorAnimation { duration: 200 }
    }

    function openUrl(url, shouldOpenNewTab)
    {
        var tab = shouldOpenNewTab ? TabManager.createTab(url, navigationPanel, tabBarRow) : TabManager.getCurrentTab()
        // FIXME: we cannot set the same url to a webview while it is loading.
        // BUG: https://bugs.webkit.org/show_bug.cgi?id=82506
        if (shouldOpenNewTab) {
            var statusBarIndicator = tab.statusIndicator;
            var tabCount = TabManager.tabCount();
            navigationPanel.hasOpennedTabs = true;
            tab.tabSelected.connect(selectTab);
            tab.closeTabRequested.connect(closeCurrentTab);
            visibleTab = tab;
        } else {
            tab.url = url;
        }
        navigationPanel.webViewMaximized();
        return tab;
    }

    function setFullScreen(value)
    {
        if (value) {
            TabManager.currentTabLayout = TabManager.FULLSCREEN_LAYOUT;
            tabBar.state = "";
            navigationPanel.state = "withNavigationBar";
            navigationBarHidingTimer.updateStateForCurrentTab();
        } else {
            TabManager.currentTabLayout = TabManager.OVERVIEW_LAYOUT;
            tabBar.state = "hidden";
            navigationPanel.state = "";
        }
        TabManager.setTabLayout(TabManager.currentTabLayout, 1);
    }

    function closeCurrentTab()
    {
        TabManager.removeTab(TabManager.currentTab)
        if (TabManager.tabCount() === 0)
            hasOpennedTabs = false;
    }

    function changeOverview(scale)
    {
        if (scale > 1.0)
            if (TabManager.overviewGridSize > 1) {
                TabManager.overviewGridSize--;
            } else {
                webViewMaximized();
                return;
            }
        else if (scale < 1.0 && TabManager.overviewGridSize < TabManager.MAX_GRID_SIZE)
            TabManager.overviewGridSize++;
        else
            return;

        TabManager.doTabOverviewLayout();
    }

    function selectTab(tabNumber)
    {
        webViewMaximized();
        TabManager.setCurrentTab(tabNumber);
        navigationPanel.visibleTab = TabManager.getCurrentTab();
    }
}
