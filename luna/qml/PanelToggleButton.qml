import QtQuick 1.1

Rectangle {
    id: button

    property alias text: label.text
    property alias enabled: mouseArea.enabled
    property bool active

    signal clicked()

    width: 170
    height: 40
    radius: 20
    color: "#111"

    states: State {
        name: "active"
        when: button.active
        PropertyChanges { target: button; color: "white"; z: 1 }
        PropertyChanges { target: label; font.pixelSize: 20; color: "black" }
    }

    // This animation is synchronized with PanelToggle.
    transitions: Transition {
        ParallelAnimation {
            PropertyAnimation { property: "color"; duration: 400 }
            SequentialAnimation {
                PropertyAnimation { target: label; property: "opacity"; to: 0; duration: 200 }
                PropertyAction { target: label; property: "font.pixelSize" }
                PropertyAnimation { target: label; property: "opacity"; to: 1; duration: 200 }
            }
        }
    }

    Text {
        id: label
        anchors.centerIn: parent
        color: "gray"
        font.family: "Nokia Pure Text"
        font.pixelSize: button.active ? 20 : 14
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
    }

    Component.onCompleted: mouseArea.clicked.connect(clicked)
}
