import QtQuick 1.1

Rectangle {
    width: 170
    height: 40
    signal clicked()
    property alias text: btnLabel.text
    property alias enabled: mouseArea.enabled
    radius: 20
    color: enabled ? activeColor : "gray"
    property string activeColor: "red"

    Text {
        id: btnLabel
        anchors.centerIn: parent
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
    }

    Component.onCompleted: mouseArea.clicked.connect(clicked)
}
