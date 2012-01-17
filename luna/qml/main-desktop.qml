import QtQuick 1.0

// We need to load this at least in one QML file to enable the image provider for MeeGo assets.
import com.nokia.meego 1.0

Item {
    width: 480
    height: 854

    Rectangle {
        id: fakeStatusBar
        color: "black"
        anchors.left: parent.left
        anchors.right: parent.right
        height: 36
        Text {
            anchors.fill: parent
            anchors.rightMargin: 5
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignRight
            text: "23:59"
            color: "white"
            font.pixelSize: 20
        }
    }

    Main {
        anchors {
            top: fakeStatusBar.bottom
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }
    }
}
