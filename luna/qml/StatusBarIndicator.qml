import QtQuick 1.1

Rectangle {
    id: statusBall
    width: 8
    height: 8
    radius: 4
    z: 1
    property bool active: true
    color: active ? "white" : "#666"
    property alias url: urlBar.text

    // FIXME: Create a component for this!? to add auto completion, clear buttons, etc...
    TextInput {
        id: urlBar
        visible: false
        anchors.centerIn: parent
        width: parent.width - 20
        clip: true
    }

    states: [
        State {
            name: "likeAUrlBar"
            PropertyChanges { target: urlBar; visible: true; }
            PropertyChanges { target: statusBall; radius: 15; }
            PropertyChanges { target: statusBall; y: -100; }
            AnchorChanges { target: statusBall; anchors.horizontalCenter: parent.horizontalCenter; }
            PropertyChanges { target: statusBall; width: 380; }
            PropertyChanges { target: statusBall; height: 30; }
        },
        State {
            name: "hide"
            PropertyChanges { target: urlBar; visible: false; }
            PropertyChanges { target: statusBall; y: 50; }
        }
        ]
    transitions: [
        Transition {
            to: "likeAUrlBar"
            SequentialAnimation {
                PropertyAnimation { properties: "y,height"; duration: 300; }
                PropertyAnimation { properties: "x,width"; duration: 300; }
                PropertyAnimation { properties: "visible"; duration: 0; }
            }
        },
        Transition {
            from: "likeAUrlBar"
            SequentialAnimation {
                PropertyAnimation { properties: "visible"; duration: 0; }
                PropertyAnimation { properties: "x,width"; duration: 300; }
                PropertyAnimation { properties: "y,height"; duration: 300; }
            }
        },
        Transition {
            to: "hide"
            PropertyAnimation { properties: "y"; duration: 250; }
        }
    ]
}
