/****************************************************************************
 *   Copyright (C) 2012  Instituto Nokia de Tecnologia (INdT)               *
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
import QtWebKit 3.0

import "UiConstants.js" as UiConstants

Item {
    id: webViewItem

    property string url
    property alias loading: webView.loading
    property alias canGoBack: webView.canGoBack
    property alias canGoForward: webView.canGoForward
    property alias loadProgress: webView.loadProgress
    property bool active: true
    property bool interactive: true

    function goBack() { webView.goBack() }
    function goForward() { webView.goForward() }
    function reload() {
        // When we load a 404 page using loadHtml, webView.url becomes "about:blank". Requesting a reload with
        // that address won't reload the original requested page, so it's safer to do this explicit call here.
        load(url)
    }
    function stop() { webView.stop() }

    // FIXME: webView.url should reflect url requested by the user (https://bugs.webkit.org/show_bug.cgi?id=77554)
    function load(newUrl) {
        webViewItem.url = newUrl // Keep the url requested originally, so we can display on navbar.
        webView.url = newUrl // Request to load the new url on our internal webview.
    }

    WebView {
        id: webView
        anchors.fill: parent
        enabled: webViewItem.active && webViewItem.interactive

        onLoadingChanged: {
            if (webView.url == "about:blank")
                return;

            if (loadRequest.status === WebView.LoadFailedStatus)
                webView.loadHtml(UiConstants.HtmlFor404Page)
            else if (loadRequest.status === WebView.LoadSucceededStatus) {
                webViewItem.url = webView.url // Updates the url displayed on navbar as it could have been redirected.
                HistoryModel.insert(webView.url, webView.title)
            }
        }
    }
}
