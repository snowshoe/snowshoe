import QtQuick 1.1
Item {
    property alias urlBar: urlBar
    property alias desktopView: desktopView
    UrlBar {
        id: urlBar
        objectName: "urlBar"
    }

    DeclarativeDesktopWebView {
        id: desktopView
        anchors.top: urlBar.bottom
        anchors.topMargin: 5
        anchors.bottom: root.bottom
        anchors.left: root.left
        anchors.right: root.right

        onUrlChanged: { urlBar.text = url.toString() ; focus = true }
        onLoadFailed: { url = "http://www.google.com/search?q=" + urlBar.text }
    }
}
