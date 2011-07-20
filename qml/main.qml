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

TabWidget {
    id: tabWidget

    function focusUrlBar() {
        currentActiveTab.mainView.focusUrlBar()
    }

    function closeActiveTab() {
        closeTab(currentActiveTab)
    }

    onNewTabRequested: addNewTab()
    Component.onCompleted: addNewTab()

    function addNewTab() {
        var tab = tabComponent.createObject(tabWidget)
        tabWidget.addTab(tab)
        tabWidget.setActiveTab(tab)
    }

    Component {
        id: tabComponent
        Tab {
            id: tab
            text: "New Tab"
            mainView: page

            PageWidget {
                id: page
                tab: tab
            }
        }
    }
}
