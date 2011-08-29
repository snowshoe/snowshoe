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

TabWidget {
    id: tabWidget

    Binding {
        target: BrowserObject
        property: "windowTitle"
        value: currentActiveTab.text + " ~ Snowshoe"
    }

    function focusUrlBar() {
        currentActiveTab.pageWidget.focusUrlBar()
    }

    function closeActiveTab() {
        closeTab(currentActiveTab)
    }

    onNewTabRequested: addNewEmptyTab()

    function addNewEmptyTab() {
        var page = pageComponent.createObject()
        return tabWidget.addTabForPage(page)
    }

    function addNewTabWithUrl(url) {
        var tab = addNewEmptyTab()
        if (BrowserObject.isUrlValid(url))
            tab.pageWidget.webView.load(url)
        return tab
    }

    Component {
        id: pageComponent
        PageWidget {
            y: tab ? tab.headerHeight : 0
            visible: tab ? tab.active : 0
            onUrlChanged: tabWidget.updateUrlsOpened()
        }
    }
}
