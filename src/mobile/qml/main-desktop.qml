import QtQuick 2.0

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
