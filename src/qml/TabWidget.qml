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
import "TabWidget.js" as Core

Item {
    id: root

    property PageWidget activePage: currentActiveTab.pageWidget
    property variant currentActiveTab: Tab {}

    property variant currentTabAnimate;

    function setActiveTab(newActiveTab)
    {
        Core.setActiveTab(newActiveTab);
    }

    signal newTabRequested()

    height: currentActiveTab.height

    Image {
        id: base
        width: parent.width
        fillMode: Image.TileHorizontally
        source: "qrc:///tabwidget/tab_base_fill"
        MouseArea {
            anchors.fill: parent
            onDoubleClicked: root.newTabRequested()
        }
    }

    Component {
        id: tabComponent
        Tab {
            text: pageWidget ? pageWidget.title : ""
        }
    }

    function addTabForPage(page) {
        var tabToAdd = tabComponent.createObject(root)
        tabToAdd.pageWidget = page
        page.tab = tabToAdd
        root.addTab(tabToAdd)
        root.setActiveTab(tabToAdd)
        return tabToAdd
    }

    function addTab(tab)
    {
        Core.addTab(tab);
        if (Core.tabsHeadersWidth() > width) {
            // Shrink the tabs
            Core.shrinkTabs(width);
        }
        tab.anchors.top = root.top;
        tab.tabWidget = root;
        updateUrlsOpened();
    }

    function closeTab(tab)
    {
        Core.closeTab(tab);
        tab.destroy();
        updateUrlsOpened()
        if (Core.tabsHeadersWidth() < width) {
            // Shrink the tabs
            Core.shrinkTabs(width);
        }
    }

    function updateUrlsOpened() {
        BrowserObject.updateUrlsOpened(Core.urlsInTabOrder())
    }

    function updateSiblingTabsForDragging(tab, draggingEnable)
    {
        Core.updateSiblingTabsForDragging(tab, draggingEnable);
    }

    function updateTabsLayout(tab)
    {
        Core.updateTabsLayout(tab);
    }

    function jumpToNextTab()
    {
        Core.jumpToNextTab();
    }

    function jumpToPreviousTab()
    {
        Core.jumpToPreviousTab();
    }

    function resetTabsToNonDraggingState() {
        Core.resetTabsToNonDraggingState()
        updateUrlsOpened()
    }

    function closeActiveTab() {
        root.closeTab(root.currentActiveTab)
    }

    onWidthChanged: Core.shrinkTabs(width)
}
