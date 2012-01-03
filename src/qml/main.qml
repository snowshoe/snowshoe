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

    state: "normal"

    // FIXME: Many of those functions are exposed so we setup global shortcuts, can we move this setup to QML side?
    function stop() {
        tabWidget.activePage.webView.stop()
    }

    function reload() {
        tabWidget.activePage.webView.reload()
    }

    function focusUrlBar() {
        urlBar.textInput.forceActiveFocus()
        urlBar.textInput.selectAll()
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
        if (UrlTools.isValid(url))
            tab.pageWidget.loadUrl(url)
        return tab
    }

    function jumpToNextTab() {
        tabWidget.jumpToNextTab()
    }

    function jumpToPreviousTab() {
        tabWidget.jumpToPreviousTab()
    }

    function fullScreenActionTriggered() {
        if (state == "normal")
            state = "fullscreen"
        else
            state = "normal"
    }

    function showHeaderArea() {
        tabWidget.visible = true
        urlBar.visible = true
    }

    function hideHeaderArea() {
        tabWidget.visible = false
        urlBar.visible = false
    }


    TabWidget {
        id: tabWidget
        z: 1
        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
        }

        onNewTabRequested: browserView.addNewEmptyTab()
        onActivePageChanged: urlBar.pageWidget = activePage
    }

    UrlBar {
        id: urlBar
        z: 1
        anchors.top: tabWidget.bottom
    }

    Item {
        id: contentArea
        anchors {
            top: urlBar.bottom
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }

        MouseArea {
            id: fullScreenMouseArea
            anchors {
                top: parent.top
                left: parent.left
                right: parent.right
            }
            height: 5
            hoverEnabled: true
            z: 1

            onEntered: { if (browserView.state != "fullscreen") return; showHeaderArea(); height = urlBar.height + urlBar.y; }
            onExited: { if (browserView.state != "fullscreen") return; hideHeaderArea(); height = 5; }
        }

    }

    states: [
        State {
            name: "fullscreen"
            PropertyChanges {
                target: urlBar
                visible: false
            }
            PropertyChanges {
                target: tabWidget
                visible: false
            }
            StateChangeScript {
                script: View.showFullScreen()
            }
            AnchorChanges {
                target: contentArea
                anchors.top: browserView.top
            }
        },
        State {
            name: "normal"
            PropertyChanges {
                target: urlBar
                visible: true
            }
            PropertyChanges {
                target: tabWidget
                visible: true
            }
            StateChangeScript {
                script: View.showNormal()
            }
            AnchorChanges {
                target: contentArea
                anchors.top: urlBar.bottom
            }
        }

    ]

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
