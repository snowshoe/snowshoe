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
    id: browserView

    // FIXME: Many of those functions are exposed so we setup global shortcuts, can we move this setup to QML side?
    function stop() {
        tabWidget.activePage.stop()
    }

    function focusUrlBar() {
        tabWidget.activePage.focusUrlBar()
    }

    function closeActiveTab() {
        tabWidget.closeActiveTab()
    }

    function addNewEmptyTab() {
        var page = pageComponent.createObject(contentArea)
        return tabWidget.addTabForPage(page)
    }

    function addNewTabWithUrl(url) {
        var tab = addNewEmptyTab()
        if (BrowserObject.isUrlValid(url))
            tab.pageWidget.webView.load(url)
        return tab
    }

    function jumpToNextTab() {
        tabWidget.jumpToNextTab()
    }

    function jumpToPreviousTab() {
        tabWidget.jumpToPreviousTab()
    }

    TabWidget {
        id: tabWidget
        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
        }
        onNewTabRequested: browserView.addNewEmptyTab()
    }

    Item {
        id: contentArea
        anchors {
            top: tabWidget.bottom
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }
    }

    Binding {
        target: BrowserObject
        property: "windowTitle"
        value: tabWidget.activePage ? tabWidget.activePage.title + " ~ Snowshoe" : ""
    }

    Component {
        id: pageComponent
        PageWidget {
            anchors.fill: contentArea
            visible: tab ? tab.active : 0
            onUrlChanged: tabWidget.updateUrlsOpened()
        }
    }
}
