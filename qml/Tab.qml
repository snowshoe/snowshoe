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

import QtQuick 1.1

Item {
    id: tab

    property alias content:  content
    property int headerWidth: content.width + rightImage.width
    property int headerHeight: leftImage.height
    property alias tabHeader: tabHeader

    property bool active: true
    property alias text: tabText.text

    property bool isLastTab

    property bool isLeftDragging
    property bool isRightDragging

    property variant previousTab: undefined

    property variant tabWidget: Item {}

    property variant mainView: Item {}

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

    function startSpinner() {
        spinner.visible = true;
        spinner.playing = true;
    }

    function stopSpinner() {
        spinner.visible = false;
        spinner.playing = false;
    }

    Binding {
        property: "height"
        value: tab.content.height - tab.headerHeight
        target: mainView
    }

    Binding {
        property: "width"
        value: tabWidget.width
        target: mainView
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

        BorderImage {
            id: tabTitle
            width: content.width - leftImage.width
            horizontalTileMode: BorderImage.Repeat
            border { left: 0; top: 0; right: 0; bottom: 0 }
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
            drag.maximumX: tabWidget.width - tab.headerWidth
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
        }

        AnimatedImage {
            id: spinner
            source: "qrc:///tabwidget/spinner.gif"
            width: 15
            anchors.top: parent.top
            anchors.left: leftImage.left
            anchors.topMargin: 10
            anchors.leftMargin: 12
            playing: false
            visible: false
        }

        Text {
            id: tabText
            width: parent.width
            elide: Text.ElideRight
            anchors.top: parent.top
            anchors.left: spinner.right
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
        id: content;
        width: 50
        x: {
            if (tab.previousTab != undefined) {
                return tab.previousTab.content.x +  tab.previousTab.content.width;
            } else
                return 0;
        }
        height: tabWidget.height

        property bool headerFollowContent: true;
        property alias widthBehavior: widthBehavior

        property int effectiveWidth;

        Behavior on width {
            id: widthBehavior;
            function complete()
            {
                return widthAnimation.complete();
            }

            PropertyAnimation {
                id: widthAnimation;
                easing.type: Easing.Linear;
                duration: 150;
            }
        }

        onWidthChanged: syncHeader();
        onXChanged: { if (headerFollowContent) syncHeader(); }
    }
}
