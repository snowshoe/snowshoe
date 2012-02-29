import QtQuick 2.0

Rectangle {
    id: statusBall
    width: 10
    height: 10
    radius: 5
    z: 1
    property bool active: true
    color: active ? "white" : "#666"
    property alias url : urlBar.text
    property variant webView
    property bool startAnimation: Boolean(webView && webView.shouldAnimateIndicator)

    UrlBar {
        id: urlBar
        visible: false
        anchors.centerIn: parent
        width: parent.width - 20

        onAccepted: {
            webView.url = urlBar.text
        }
    }

    onStartAnimationChanged: {
        if (startAnimation)
            loadingAnimation.start()
        else
            loadingAnimation.stop()
    }

    SequentialAnimation on y {
        id: loadingAnimation
        alwaysRunToEnd: true
        loops: Animation.Infinite
        PropertyAnimation { to: -10}
        PropertyAnimation { to: 0}
        PropertyAnimation { to: 10}
        PropertyAnimation { to: 0}
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
