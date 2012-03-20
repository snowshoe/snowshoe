import QtQuick 2.0
import QtWebKit 3.0

import "UiConstants.js" as UiConstants

Item {
    id: webViewItem
    property alias url: webView.url
    property variant statusIndicator
    property alias webView: webView
    property bool active: true
    signal fullScreenRequested()

    WebView {
        id: webView
        anchors.fill: parent

        onLoadingChanged: {
            if (loadRequest.status === WebView.LoadFailedStatus)
                webView.loadHtml(UiConstants.HtmlFor404Page)
            if (!loading)
                statusIndicator.animation.stop();
        }
    }
    // FIXME: This is outside WebView due to a qt-webkit bug
    MouseArea {
        id: mouseArea
        anchors.fill: webView
        visible: !webViewItem.active
        onClicked: fullScreenRequested();
    }
}
