import QtQuick 2.0
import QtWebKit 3.0

import "UiConstants.js" as UiConstants

Item {
    id: webViewItem
    property alias url: webView.url
    property alias loading: webView.loading
    property alias canGoBack: webView.canGoBack
    property alias canGoForward: webView.canGoForward
    property variant statusIndicator
    property bool active: true
    signal fullScreenRequested()
    signal closeTabRequested()
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

        onLoadingChanged: {
            if (loadRequest.status === WebView.LoadFailedStatus)
                webView.loadHtml(UiConstants.HtmlFor404Page)
        }
    }
    // FIXME: This is outside WebView due to a qt-webkit bug
    MouseArea {
        id: mouseArea
        anchors.fill: webView
        visible: !webViewItem.active
        onClicked: fullScreenRequested();
    }

    Image {
        id: closeButton
        anchors {
            top: parent.top
            right: parent.right
        }
        source: ":/mobile/nav/btn_close"
        visible: !webViewItem.active
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
