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

    property alias urlBar: urlBar
    property alias desktopView: desktopView
    property bool isLoading: false

    property variant tab;

    UrlBar {
        id: urlBar
        onUrlEntered: {
            var urlToBrowse = BrowserObject.urlFromUserInput(url);
            if (BrowserObject.isUrlValid(urlToBrowse))
                desktopView.load(urlToBrowse);
            else
                desktopView.load(fallbackUrl(url));
        }
    }

    DesktopWebView {
        id: desktopView
        anchors.top: urlBar.bottom
        anchors.topMargin: 5
        anchors.bottom: root.bottom
        anchors.left: root.left
        anchors.right: root.right

        onLoadStarted: {
            root.isLoading = true
        }

        onLoadSucceeded: {
            root.isLoading = false
            if (tab.active && !focus)
                forceActiveFocus();
        }

        onUrlChanged: { urlBar.text = url.toString() }

        onLoadFailed: {
            root.isLoading = false
            load(fallbackUrl(urlBar.text))
        }

        onTitleChanged: { tab.text = title }
    }

    function fallbackUrl(url)
    {
        return "http://www.google.com/search?q=" + url;
    }

    function focusUrlBar() {
        urlBar.textInput.forceActiveFocus();
    }
}
