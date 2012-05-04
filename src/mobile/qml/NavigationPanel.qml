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

Item {
    id: navigationPanel

    property bool hasOpennedTabs: tabsModel.count
    property alias url: navigationBar.url
    property QtObject visibleTab: tabsModel.currentElement

    signal newTabRequested()
    signal urlInputRequested()
    signal webViewMaximized()
    signal webViewMinimized()

    Connections {
        target: visibleTab
        onLoadingChanged: {
            if (navigationPanel.state === "withNavigationBarAndOverlay")
                return;
            navigationBarHidingTimer.updateStateForCurrentTab();
        }
    }

    Binding {
        target: visibleTab
        property: "interactive"
        value: navigationPanel.state !== "withNavigationBarAndOverlay"
    }

    ItemModel {
        id: tabsModel

        function hideNonCurrentElements() {
            for (var i = 0; i < count; ++i) {
                var item = get(i);
                item.visible = item === currentElement
            }
        }

        function showAll() {
            for (var i = 0; i < count; ++i) {
                var item = get(i);
                item.visible = true;
                item.interactive = false;
            }
        }
    }

    Image {
        id: barsBackground
        height: tabBar.height
        source: "qrc:///mobile/app/bg_image"
        anchors.bottom: parent.bottom
        fillMode: Image.Pad
        verticalAlignment: Image.AlignBottom
    }

    PagedGrid {
        id: tabsGrid
        model: tabsModel
        visible: visibleTab === null

        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
            topMargin: UiConstants.NavigationPanelYOffset
        }

        onItemClicked: tabsModel.currentElement = item;
        onItemClosed: tabsModel.remove(item);
    }

    IndicatorRow {
        id: pageBarRow
        anchors {
            top: tabsGrid.bottom
            horizontalCenter: parent.horizontalCenter
            topMargin: 25
        }
        itemCount: tabsGrid.pageCount
        currentItem: tabsGrid.page
        visible: !tabBarRow.visible
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
            tabsModel.currentElement = null;
        }

        onCloseTab: {
            tabsModel.remove(visibleTab);
            navigationPanel.state = "";
        }

        onDismissOverlay: {
            navigationPanel.state = "";
        }

        onGoToNextTab: {
            tabsModel.nextItem();
        }

        onGoToPreviousTab: {
            tabsModel.previousItem();
        }
    }

    OverlayBar {
        id: overlayBar
        visible: overlay.visible
        anchors {
            top: navigationBar.top
            left: parent.left
            right: parent.right
            bottomMargin: 27
        }

        onShowThumbnails: {
            navigationPanel.state = "";
            tabsModel.currentElement = null;
        }

        onOpenNewTab: navigationPanel.newTabRequested()

        onFavoriteToggled: BookmarkModel.toggleFavorite(visibleTab.url);

        Connections {
            target: BookmarkModel
            onCountChanged: {
                if (visibleTab)
                    overlayBar.favorite = BookmarkModel.contains(visibleTab.url);
            }
        }
    }

    NavigationBar {
        id: navigationBar
        currentWebView: navigationPanel.visibleTab
        anchors.top: parent.bottom
        anchors.bottomMargin: 31

        onUrlInputRequested: navigationPanel.urlInputRequested()
        onStopRequested: navigationPanel.state = "withNavigationBar"
        onReloadRequested: navigationPanel.state = "withNavigationBar"
        onBackRequested: navigationPanel.state = "withNavigationBar"
        onForwardRequested: navigationPanel.state = "withNavigationBar"

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

        onUrlChanged: overlayBar.favorite = BookmarkModel.contains(url);
    }

    Item {
        id: tabBar
        width: UiConstants.PortraitWidth
        height: UiConstants.TabBarHeight
        anchors.bottom: overlayBar.top
        anchors.left: parent.left
        anchors.right: parent.right

        IndicatorRow {
            id: tabBarRow
            anchors {
                top: parent.top
                bottom: parent.bottom
                horizontalCenter: parent.horizontalCenter
                topMargin: 25
                bottomMargin: 27
            }
            itemCount: tabsModel.count
            currentItem: tabsModel.currentElementIndex
            loadProgress: visibleTab ? visibleTab.loadProgress : 0
        }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                navigationPanel.state = "withNavigationBarAndOverlay";
            }
        }
    }

    states: [
        State {
            name: "withNavigationBar"
            AnchorChanges { target: navigationBar; anchors.top: undefined; anchors.bottom: parent.bottom }
            PropertyChanges {
                target: barsBackground
                height: tabBar.height + tabBar.anchors.topMargin + tabBar.anchors.bottomMargin
                        + navigationBar.height + navigationBar.anchors.topMargin + navigationBar.anchors.bottomMargin
            }

            // TODO: avoid dealing with webView's height. This was used to allow N9 users to be able to click
            // on tabbar indicators without sending all the clicks to the webView component
            PropertyChanges {
                target: visibleTab
                height: UiConstants.PortraitHeight - barsBackground.height
                restoreEntryValues: false
            }
        },
        State {
            name: "withNavigationBarAndOverlay"
            extend: "withNavigationBar"
            PropertyChanges { target: overlay; visible: true }
            PropertyChanges { target: overlay; opacity: 0.5 }
            AnchorChanges { target: overlayBar; anchors.top: undefined; anchors.bottom: navigationBar.top }
            StateChangeScript { script: navigationBarHidingTimer.stop() }
            PropertyChanges {
                target: barsBackground
                height: tabBar.height + tabBar.anchors.topMargin + tabBar.anchors.bottomMargin
                        + navigationBar.height + navigationBar.anchors.topMargin + navigationBar.anchors.bottomMargin
                        + overlayBar.height + overlayBar.anchors.topMargin + overlayBar.anchors.bottomMargin
            }
            PropertyChanges {
                target: visibleTab
                height: UiConstants.PortraitHeight - UiConstants.TabBarHeight
                restoreEntryValues: false
            }
        }
    ]

    transitions: Transition {
        AnchorAnimation { duration: 100 }
        PropertyAnimation { target: visibleTab; properties: "height"; duration: 100 }
        PropertyAnimation { target: barsBackground; properties: "height"; duration: 100 }
        PropertyAnimation { target: overlay; properties: "opacity"; duration: 200 }
    }

    Component {
        id: snowShoeWebView
        SnowshoeWebView {}
    }

    function openUrl(url)
    {
        tabsModel.currentElement.load(url)
        webViewMaximized()
    }
    function openUrlInNewTab(url)
    {
        var webView = snowShoeWebView.createObject(this, { "width" : UiConstants.PortraitWidth,
                                                           "height" : UiConstants.PortraitHeight - UiConstants.TabBarHeight,
                                                           "z" : -1});
        webView.load(url);
        tabsModel.add(webView);
    }

    onVisibleTabChanged: {
        if (!visibleTab && tabsModel.count) {
            tabsModel.showAll();
            tabsGrid.relayout();
            navigationPanel.webViewMinimized();
            tabBar.visible = false;
        } else if (visibleTab) {
            visibleTab.x = 0;
            visibleTab.y = 0;
            visibleTab.width = UiConstants.PortraitWidth;
            visibleTab.height = UiConstants.PortraitHeight - UiConstants.TabBarHeight;
            tabsModel.hideNonCurrentElements();
            webViewMaximized();
            tabBar.visible = true;
        }
    }
}
