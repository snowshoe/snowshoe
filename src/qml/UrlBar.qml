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
import QtWebKit 3.0

Item {
    id: root

    property alias text: urlEdit.text
    property alias textInput: urlEdit.textInput
    property alias bookmarkButton: urlEdit.bookmarkButton

    signal urlEntered(string url)

    width: parent.width
    height: background.height

    property PageWidget pageWidget: PageWidget {}

    onPageWidgetChanged: {
        if (UrlTools.isEmpty(pageWidget.webView.url)) {
            textInput.forceActiveFocus()
            bookmarkButton.visible = false
        } else {
            pageWidget.webView.forceActiveFocus()
            if (!pageWidget.isLoading) {
                bookmarkButton.visible = true
                bookmarkButton.isBookmarked = BookmarkModel.contains(textInput.text)
            }
        }
        urlEdit.text = pageWidget.currentUrl
    }

    onUrlEntered: {
        var urlToBrowse = UrlTools.fromUserInput(url);
        if (UrlTools.isValid(urlToBrowse))
            pageWidget.loadUrl(urlToBrowse);
        else
            pageWidget.loadUrl(pageWidget.fallbackUrl(url));
    }

    Image {
        id: background
        width: parent.width
        fillMode: Image.TileHorizontally
        source: "qrc:///urlbar/url_bg_base_fill"
    }

    Connections {
        target: pageWidget.webView
        onLoadSucceeded: {
            bookmarkButton.visible = true;
            bookmarkButton.isBookmarked = BookmarkModel.contains(pageWidget.webView.url);
        }
        onLoadStarted: {
            bookmarkButton.visible = false;
        }
    }

    Binding {
        target: urlEdit
        property: "text"
        value : pageWidget.currentUrl
    }

    Row {
        id: buttons
        width: childrenRect.width
        height: childrenRect.height
        anchors.verticalCenter: parent.verticalCenter
        anchors.verticalCenterOffset: -1

        Button {
            disabledImage: "qrc:///urlbar/btn_nav_back_disable"
            hoveredImage: "qrc:///urlbar/btn_nav_back_over"
            pressedImage: "qrc:///urlbar/btn_nav_back_pressed"
            standardImage: "qrc:///urlbar/btn_nav_back_unpressed"
            disabled: !pageWidget.webView.canGoBack
            onClicked: { pageWidget.webView.goBack() }
        }

        Image {
            source: "qrc:///urlbar/component_divisor"
        }

        Button {
            disabledImage: "qrc:///urlbar/btn_nav_next_disable"
            hoveredImage: "qrc:///urlbar/btn_nav_next_over"
            pressedImage: "qrc:///urlbar/btn_nav_next_pressed"
            standardImage: "qrc:///urlbar/btn_nav_next_unpressed"
            disabled: !pageWidget.webView.canGoForward
            onClicked: { pageWidget.webView.goForward() }
        }

        Image {
            source: "qrc:///urlbar/component_divisor"
        }

        Button {
            hoveredImage: { pageWidget.webView.canStop ? "qrc:///urlbar/btn_nav_cancel_over" : "qrc:///urlbar/btn_nav_refresh_over" }
            pressedImage: { pageWidget.webView.canStop ? "qrc:///urlbar/btn_nav_cancel_pressed" : "qrc:///urlbar/btn_nav_refresh_pressed" }
            standardImage: { pageWidget.webView.canStop ? "qrc:///urlbar/btn_nav_cancel_unpressed" : "qrc:///urlbar/btn_nav_refresh_unpressed" }

            onClicked: { pageWidget.webView.canStop ? pageWidget.webView.stop() : pageWidget.webView.reload() }
        }
    }

    UrlEdit {
        id: urlEdit
        anchors {
            left: buttons.right
            right: parent.right
            rightMargin: 4
            verticalCenter: root.verticalCenter
            verticalCenterOffset: -1
        }
        onUrlEntered: root.urlEntered(url)
    }
}
