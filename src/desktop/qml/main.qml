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
import Snowshoe 1.0

Item {
    id: browserView
    state: "normal"

    function focusUrlBar() {
        urlBar.textInput.forceActiveFocus()
        urlBar.textInput.selectAll()
    }

    function openTabWithUrl(url) {
        var tab = _openEmptyTab()
        if (UrlTools.isValid(url))
            tab.pageWidget.loadUrl(url)
        return tab
    }

    function toggleFullScreen() {
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

        onNewTabRequested: _openEmptyTab()
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
                script: BrowserWindow.showFullScreen()
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
                script: BrowserWindow.showNormal()
            }
            AnchorChanges {
                target: contentArea
                anchors.top: urlBar.bottom
            }
        }

    ]

    Binding {
        target: BrowserWindow
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

    Shortcut {
        key: "Ctrl+L"
        onTriggered: focusUrlBar()
    }

    Shortcut {
        key: "Ctrl+T"
        onTriggered: _openEmptyTab()
    }

    Shortcut {
        key: "Ctrl+W"
        onTriggered: tabWidget.closeActiveTab()
    }

    Shortcut {
        key: "Ctrl+PgDown"
        onTriggered: tabWidget.jumpToNextTab()
    }

    Shortcut {
        key: "Ctrl+PgUp"
        onTriggered: tabWidget.jumpToPreviousTab()
    }

    Shortcut {
        key: "Esc"
        onTriggered: tabWidget.activePage.webView.stop()
    }

    Shortcut {
        key: "Ctrl+I"
        onTriggered: tabWidget.activePage.toggleInspector()
    }

    Shortcut {
        key: "F5"
        onTriggered: tabWidget.activePage.webView.reload()
    }

    Shortcut {
        key: "Ctrl+Shift+Q"
        onTriggered: BrowserWindow.closeWindow()
    }

    Shortcut {
        key: "F11"
        onTriggered: toggleFullScreen()
    }

    Component.onCompleted: {
        // Copy the QStringList so we are not affected when it changes.
        var savedUrls = StateTracker.urlsOpened.slice(0);
        var commandLineUrls = BrowserWindow.urlsFromCommandLine;
        if (!savedUrls.length && !commandLineUrls.length) {
            _openEmptyTab();
            return;
        }

        var i;
        for (i = 0; i < savedUrls.length; i++)
            openTabWithUrl(savedUrls[i]);
        for (i = 0; i < commandLineUrls.length; i++)
            openTabWithUrl(commandLineUrls[i]);
    }

    function _openEmptyTab() {
        var page = pageComponent.createObject(contentArea)
        return tabWidget.addTabForPage(page)
    }
}
