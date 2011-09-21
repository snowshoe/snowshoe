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
import QtWebKit.experimental 5.0
import Snowshoe 1.0

Item {
    id: root

    property alias url: webView.url
    property alias urlBar: urlBar
    property alias webView: webView
    property bool isLoading: false
    property string title: "New Tab"

    property variant tab;

    UrlBar {
        id: urlBar
        onUrlEntered: {
            var urlToBrowse = BrowserObject.urlFromUserInput(url);
            if (BrowserObject.isUrlValid(urlToBrowse))
                webView.load(urlToBrowse);
            else
                webView.load(fallbackUrl(url));
        }
    }

    DesktopWebView {
        id: webView
        anchors {
            top: urlBar.bottom
            bottom: root.bottom
            left: root.left
            right: root.right
        }

        visible: false

        onLoadStarted: {
            root.isLoading = true;
            visible = true;
            newTab.visible = false;
            urlBar.bookmarkButton.visible = false;
            if (tab.active && !focus)
                forceActiveFocus();
        }

        onLoadSucceeded: {
            root.isLoading = false
            urlBar.bookmarkButton.visible = true;
            urlBar.bookmarkButton.isBookmarked = BookmarkModel.contains(url);
        }

        onUrlChanged: { urlBar.text = url.toString() }

        onLoadFailed: {
            root.isLoading = false
            if (errorType == DesktopWebView.NetworkError && errorCode == NetworkReply.OperationCanceledError)
                return;
            load(fallbackUrl(urlBar.text))
        }

        onTitleChanged: { root.title = title }

        function navigationPolicyForUrl(url, button, modifiers) {
            if (button == Qt.MiddleButton
                || (button == Qt.LeftButton && modifiers & Qt.ControlModifier)) {
                tab.tabWidget.addNewTabWithUrl(url)
                return DesktopWebView.IgnorePolicy
            }
            return DesktopWebView.UsePolicy
        }
    }

    function fallbackUrl(url)
    {
        return "http://www.google.com/search?q=" + url;
    }

    function focusUrlBar() {
        urlBar.textInput.forceActiveFocus()
        urlBar.textInput.selectAll()
    }

    function stop() {
        webView.navigation.stop()
    }

    function reload() {
        webView.navigation.reload()
    }

    NewTab {
        id: newTab
        anchors.top: urlBar.bottom
        anchors.bottom: root.bottom
        anchors.left: root.left
        anchors.right: root.right
    }
}
