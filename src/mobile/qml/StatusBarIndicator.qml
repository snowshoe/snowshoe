import QtQuick 2.0

Rectangle {
    width: 10
    height: 10
    radius: 5
    z: 1
    property bool active: true
    color: active ? "white" : "#666"
    property alias animation: loadingAnimation

    SequentialAnimation on y {
        id: loadingAnimation
        alwaysRunToEnd: true
        loops: Animation.Infinite
        PropertyAnimation { to: -10}
        PropertyAnimation { to: 0}
        PropertyAnimation { to: 10}
        PropertyAnimation { to: 0}
    }
}
