/****************************************************************************
 *   Copyright (C) 2011  Instituto Nokia de Tecnologia (INdT)               *
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

Item {
    id: tab

    property alias content:  content
    property alias tabHeader: tabHeader

    property bool active: true
    property alias text: tabText.text

    property bool isLastTab

    property bool isLeftDragging
    property bool isRightDragging

    property variant previousTab: undefined

    property variant tabWidget: Item {}

    property PageWidget pageWidget

    height: leftImage.height

    function rightEdge() {
        return content.x + content.width;
    }

    function isLeftActive() {
        if (previousTab != undefined) {
            return previousTab.active;
        }
        else
            return false;
    }

    function isFirstTab() {
        return (previousTab == undefined);
    }

    function syncHeader() {
        tabHeader.x = content.x;
        tabHeader.y = content.y;
        tabHeader.width = content.width;
        tabHeader.height = content.height;
    }

    Item {
        id: tabHeader
        height: content.height
        width: content.width
        Image {
            id: leftImage
            source: {
                if (tab.isFirstTab() || mouseArea.drag.active || isLeftDragging) {
                    if (tab.active)
                        return "qrc:///tabwidget/tab_active_left";
                    return "qrc:///tabwidget/tab_inactive_left";
                }

                if (tab.isLeftActive())
                    return "qrc:///tabwidget/tab_active_with_inactive_right";

                if (tab.active)
                    return "qrc:///tabwidget/tab_active_with_inactive_left";

                return "qrc:///tabwidget/tab_inactive_with_inactive";
            }
        }

        Image {
            id: tabTitle
            width: content.width - leftImage.width
            fillMode: Image.TileHorizontally
            source: tab.active ? "qrc:///tabwidget/tab_active_fill" : "qrc:///tabwidget/tab_inactive_fill"
            anchors.left: leftImage.right
        }

        Image {
            id: rightImage
            source: {
                if (tab.isLastTab || mouseArea.drag.active || isRightDragging) {
                    if (tab.active)
                        return "qrc:///tabwidget/tab_active_right";
                    return "qrc:///tabwidget/tab_inactive_right";
                }
                return "";
            }

            anchors.left: tabTitle.right
        }

        MouseArea {
            id: mouseArea
            anchors.top: parent.top
            anchors.bottom: tabTitle.bottom
            anchors.right: parent.right
            anchors.left: parent.left
            onClicked: { tabWidget.setActiveTab(tab); }
            onReleased: { tab.syncHeader(); tabWidget.resetTabsToNonDraggingState(); }
            drag.target: tabHeader
            drag.axis: Drag.XAxis
            drag.minimumX: 0
            drag.maximumX: tabWidget.width - content.width
            drag.onActiveChanged: {
                tab.z = drag.active;
                tabWidget.updateSiblingTabsForDragging(tab, drag.active);
            }
            onPositionChanged: {
                if (drag.active)
                {
                    tabWidget.updateTabsLayout(tab);
                }
            }

            // Prevent double click to hit TabWidget background.
            onDoubleClicked: { }
        }

        Item {
            id: faviconArea
            height: 15
            width: 15
            anchors.top: parent.top
            anchors.left: leftImage.left
            anchors.topMargin: 10
            anchors.leftMargin: 12

            AnimatedImage {
                id: spinner
                source: "qrc:///tabwidget/spinner.gif"
                playing: visible
                visible: pageWidget != undefined && pageWidget.isLoading;
            }

            Image {
                id: favicon
                anchors.fill: parent
                source: pageWidget != undefined && pageWidget.webView.icon ? pageWidget.webView.icon : ""
                visible: !spinner.visible && source != ""
            }
        }

        Text {
            id: tabText
            width: parent.width
            elide: Text.ElideRight
            anchors.top: parent.top
            anchors.left: faviconArea.right
            anchors.right: closeImage.left
            font.pixelSize: 12
            anchors.topMargin: 10
            anchors.leftMargin: 5
        }

        Image {
            id: closeImage
            source: tab.active ? "qrc:///tabwidget/tab_active_btn_close" : "qrc:///tabwidget/tab_inactive_btn_close"
            x: rightImage.x - width
            MouseArea {
                anchors.fill: parent
                onClicked: { tabWidget.closeTab(tab) }
            }
        }
    }

    Item {
        id: content
        width: 50
        height: tabWidget.height

        property bool headerFollowContent: true
        property alias widthBehavior: widthBehavior
        property alias xAnimation: xAnimation

        property int effectiveWidth

        Behavior on width {
            id: widthBehavior
            function complete()
            {
                return widthAnimation.complete();
            }

            PropertyAnimation {
                id: widthAnimation
                easing.type: Easing.Linear
                duration: 150
            }
        }

        PropertyAnimation {
            id: xAnimation
            target: content
            property: "x"
            easing.type: Easing.Linear
            duration: 200
            onRunningChanged: { if (running == false) { tabWidget.currentTabAnimate = undefined } }
        }

        onWidthChanged: syncHeader();
        onXChanged: { if (headerFollowContent) syncHeader(); }
    }
}
