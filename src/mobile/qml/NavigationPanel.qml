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

    property bool hasOpennedTabs: TabsModel.count > 0
    property alias url: navigationBar.url
    property QtObject visibleTab: TabsModel.currentWebView
    property QtObject lastVisibleTab

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

    Image {
        id: barsBackground
        height: tabBar.height
        source: "qrc:///mobile/app/bg_image"
        anchors.bottom: parent.bottom
        fillMode: Image.Pad
        verticalAlignment: Image.AlignBottom
    }

    Component {
        id: tabEntry
        Image {
            property string url: model.url
            source: model.screenshot
            height: UiConstants.PagedGridSizeTable[1]
            width: UiConstants.PagedGridSizeTable[0]
            clip: true

            Image {
                source: "qrc:///mobile/grid/overlayer"
                anchors {
                    bottom: parent.bottom
                    left: parent.left
                    right: parent.right
                }
            }

            Text {
                id: displayedUrl
                text: url.replace(/(https?|file):\/\/\/?(www\.)?/, "").replace(/\/.*/, "");
                color: "#515050"
                horizontalAlignment: urlFade.visible ? Text.AlignLeft : Text.AlignHCenter
                font.pixelSize: 20
                font.family: "Nokia Pure Text Light"
                anchors {
                    bottom: parent.bottom
                    left: parent.left
                    right: parent.right
                    bottomMargin: 10
                    leftMargin: 14
                    rightMargin: 14
                }

            }
            Image {
                id: urlFade
                source: "qrc:///mobile/scrollbar/suggestions_overlayer"
                visible: displayedUrl.paintedWidth > displayedUrl.width
                width: 30
                anchors {
                    verticalCenter: displayedUrl.verticalCenter
                    right: parent.right
                }
            }

            Image {
                source: "qrc:///mobile/grid/mask" + Math.max(0, index)
            }

            Image {
                source: "qrc:///mobile/grid/btn_close" + Math.max(0, index)
                anchors {
                    top: parent.top
                    right: parent.right
                }
            }
        }
    }

    PagedGrid {
        id: tabsGrid
        model: TabsModel
        delegate: tabEntry
        visible: TabsModel.currentWebViewIndex < 0

        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
            topMargin: UiConstants.NavigationPanelYOffset
        }

        onItemClicked: {
            if (y < UiConstants.PagedGridCloseButtonHeight
                && (UiConstants.PagedGridSizeTable[0] - x) <= UiConstants.PagedGridCloseButtonWidth) {
                TabsModel.remove(index);
            } else
                TabsModel.currentWebViewIndex = index;
        }
    }

    IndicatorRow {
        id: pageBarRow
        anchors {
            top: tabsGrid.bottom
            horizontalCenter: parent.horizontalCenter
            topMargin: 25
        }
        itemCount: tabsGrid.pageCount
        maxItems: 3
        currentItem: tabsGrid.currentPage
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
            TabsModel.currentWebViewIndex = index;
        }

        onCloseTab: {
            TabsModel.remove(TabsModel.currentWebViewIndex);
            navigationPanel.state = "";
        }

        onDismissOverlay: {
            navigationPanel.state = "";
        }

        onGoToNextTab: {
            if (TabsModel.currentWebViewIndex + 1 < TabsModel.count)
                TabsModel.currentWebViewIndex++;
        }

        onGoToPreviousTab: {
            if (TabsModel.currentWebViewIndex > 0)
                TabsModel.currentWebViewIndex--;
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
            TabsModel.currentWebViewIndex = -1;
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
            itemCount: TabsModel.count
            maxItems: pageBarRow.maxItems * UiConstants.PagedGridItemsPerPage
            currentItem: Math.max(0, TabsModel.currentWebViewIndex)
            loadProgress: visibleTab != null ? visibleTab.loadProgress : 0
            blinkOnZeroProgress: true
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
        TabsModel.currentWebView.load(url)
        webViewMaximized()
    }
    function openUrlInNewTab(url)
    {
        var webView = snowShoeWebView.createObject(this, { "width" : UiConstants.PortraitWidth,
                                                           "height" : UiConstants.PortraitHeight - UiConstants.TabBarHeight,
                                                           "z" : -1});
        webView.load(url);
        TabsModel.append(webView);
    }

    onVisibleTabChanged: {
        if (lastVisibleTab)
            lastVisibleTab.visible = false;
        lastVisibleTab = visibleTab;

        if (visibleTab) {
            visibleTab.visible = true;
            webViewMaximized();
            tabBar.visible = true;
        } else {
            webViewMinimized();
            tabBar.visible = false;
        }
    }
}
