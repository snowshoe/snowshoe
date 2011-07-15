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
    width: 150
    height: tabWidget.height

    property int headerHeight: leftImage.height
    property bool active: true
    property alias text: tabText.text

    property bool isFirstTab
    property bool isLastTab
    property bool isLeftActive

    property variant tabWidget: Item {}

    property variant mainView: Item {}

    Binding {
        property: "height"
        value: tab.height - tab.headerHeight
        target: mainView
    }

    Binding {
        property: "width"
        value: tabWidget.width
        target: mainView
    }

    function updateAssets() {
        leftImage.selectAsset();
        rightImage.selectAsset();
    }

    Image {
        id: leftImage
        Component.onCompleted: selectAsset()

        function selectAsset() {
            if (tab.isFirstTab) {
                if (tab.active)
                    source = "qrc:///tabwidget/tab_active_left";
                else
                    source = "qrc:///tabwidget/tab_inactive_left";
            } else {
                if (tab.isLeftActive)
                    source = "qrc:///tabwidget/tab_active_with_inactive_right";
                else if (tab.active)
                    source = "qrc:///tabwidget/tab_active_with_inactive_left";
                else
                    source = "qrc:///tabwidget/tab_inactive_with_inactive";
            }
        }
    }

    BorderImage {
        id: tabTitle
        width: tab.width - leftImage.width - rightImage.width
        horizontalTileMode: BorderImage.Repeat
        border { left: 0; top: 0; right: 0; bottom: 0 }
        source: tab.active ? "qrc:///tabwidget/tab_active_fill" : "qrc:///tabwidget/tab_inactive_fill"
        anchors.left: leftImage.right
    }

    Image {
        id: rightImage
        Component.onCompleted: selectAsset()

        function selectAsset() {
            if (tab.isLastTab) {
                if (tab.active)
                    source = "qrc:///tabwidget/tab_active_right";
                else
                    source = "qrc:///tabwidget/tab_inactive_right";
            } else {
                source = "";
            }
        }

        anchors.left: tabTitle.right
    }

    MouseArea {
        anchors.top: parent.top
        anchors.bottom: tabTitle.bottom
        anchors.right: tab.right
        anchors.left: tab.left
        onClicked: { tabWidget.setActiveTab(tab); }
    }

    Text {
        id: tabText
        width: parent.width
        elide: Text.ElideRight
        anchors.top: parent.top
        anchors.left: leftImage.right
        anchors.right: closeImage.left
        anchors.topMargin: 10
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

    function shrink(sizeToShrink)
    {
        if (sizeToShrink > 150)
            tab.width = 150
        else
            tab.width = Math.round(sizeToShrink);
    }
}
