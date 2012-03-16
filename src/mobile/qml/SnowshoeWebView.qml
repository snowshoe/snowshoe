import QtQuick 2.0
import QtWebKit 3.0

import "tabmanager.js" as TabManager
import "UiConstants.js" as UiConstants

Item {
    id: webViewItem
    property alias url: webView.url
    property variant statusIndicator
    property alias webView: webView
    property bool active: true

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
        // FIXME: Find a better way to do this!!!
        onClicked: parent.parent.parent.state = "navigationFullScreen"
    }

    Image {
        id: closeBtn
        // ok.. these are the coords, but they dont't need to be bound because
        // this coords will NEVER change.
        x: webView.width * 0.85 - width/2
        y: webView.height * 0.15 - height/2
        source: "image://theme/icon-m-framework-close-thumbnail"
        visible: !webViewItem.active
        MouseArea {
            anchors.fill: parent
            onClicked: TabManager.removeTab();
        }
    }

    Image {
        id: addToFavBtn
        // ok.. these are the coords, but they dont't need to be bound because
        // this coords will NEVER change.
        x: webView.width * 0.15 - width/2
        y: webView.height * 0.15 - height/2
        // FIXME: This image is too ugly to be used here!
        source: "image://theme/icon-l-content-favourites"
        width: 48; height: 48 // resize the original Harmattan image while we don't have a good one to put here
        visible: !webViewItem.active
        MouseArea {
            anchors.fill: parent
            onClicked: console.log("Add to favorites!")
        }
    }
}
