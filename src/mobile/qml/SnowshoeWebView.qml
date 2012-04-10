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
    property variant tabNumber
    property alias url: webView.url
    property alias loading: webView.loading
    property alias canGoBack: webView.canGoBack
    property alias canGoForward: webView.canGoForward
    property variant statusIndicator
    property bool active: true
    property bool visibility: false
    signal tabSelected(int tabNumber)
    signal closeTabRequested()
    signal overviewChanged(double scale)
    property alias closeButton: closeButton

    function goBack() { webView.goBack() }
    function goForward() { webView.goForward() }
    function reload() { webView.reload() }
    function stop() { webView.stop() }

    Behavior on y {
        NumberAnimation { duration: 200 }
    }

    WebView {
        id: webView
        anchors.fill: parent
        enabled: webViewItem.active

        onLoadingChanged: {
            if (loadRequest.status === WebView.LoadFailedStatus)
                webView.loadHtml(UiConstants.HtmlFor404Page)
        }
    }

    Image {
        id: borders
        visible: closeButton.visible
        anchors.left: parent.left
        anchors.leftMargin: -40
        source: ":/mobile/nav/border"
    }

    Item {
        id: clicksHandler
        anchors.fill: parent

        PinchArea {
            id: pinchArea
            visible: false // FIXME: https://bugreports.qt-project.org/browse/QTBUG-25058
                           // Should use "webViewItem.visibility" but MeeGo's pinchArea captures all touch events
            anchors.fill: parent
            onPinchFinished: overviewChanged(pinch.scale);
        }
        MouseArea {
            id: mouseArea
            anchors.fill: parent
            enabled: !webViewItem.active
            propagateComposedEvents: true // Allow multi-touch to reach pinchArea
            onClicked: tabSelected(tabNumber);
            onWheel: overviewChanged(wheel.angleDelta.y); // Allow testing on desktop, using mouse wheel
        }
        Image {
            id: closeButton
            anchors {
                top: parent.top
                right: parent.right
            }
            source: ":/mobile/nav/btn_close"
            visible: webViewItem.visibility
            z: 1
            MouseArea {
                anchors {
                    verticalCenter: parent.verticalCenter
                    horizontalCenter: parent.horizontalCenter
                }
                // Avoid a "too big" clickable area
                height: parent.height * 0.7
                width: parent.width * 0.7

                onClicked: closeTabRequested();
            }
        }
    }
}
