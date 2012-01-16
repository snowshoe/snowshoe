import QtQuick 1.1
import "UiConstants.js" as UiConstants

// Temporary hack to lock the app in portrait mode
import com.nokia.meego 1.0
PageStackWindow {
    initialPage: Page {
        orientationLock: PageOrientation.LockPortrait
// end hack

Rectangle {
    id: rootPage
    width: 480
    height: 854 - 36 // 36 is the height of status bar
    color: "#202022"

    Row {
        id: toolbar
        y: -100
        width: 300
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: -30

        UglyButton {
            id: favoritesBtn
            activeColor: "red"
            text: "FAVORITES"
            onClicked: rootPage.state = "favorites"
            z: 1
        }
        UglyButton {
            id: currentBtn
            activeColor: "blue"
            text: "CURRENT"
            z: 0
            onClicked: rootPage.state = "current"
            enabled: navigationPanel.pageCount !== 0
        }
    }

    FavoritesPanel {
        id: favoritesPanel
        anchors.centerIn: parent
    }

    NavigationPanel {
        visible: false
        id: navigationPanel
        anchors.centerIn: parent
    }

    Rectangle {
        id: plusBtn
        y: rootPage.height
        anchors.horizontalCenter: rootPage.horizontalCenter

        width: 40
        height: 40
        smooth: true
        radius: 20

        Text {
            id: plusBtnLabel
            anchors.centerIn: parent
            font.bold: true
            font.pixelSize: 24
            color: "#666"
            text: "+"
        }
        TextInput {
            id: newUrlBar
            visible: false
            anchors.centerIn: parent
            width: parent.width - 20
            font.pixelSize: 24
            clip: true
            text: "http://"
            onAccepted: {
                navigationPanel.createTab(newUrlBar.text)
                newUrlBar.text = "http://"
                rootPage.state = "currentFullScreen"
            }
        }
        MouseArea {
            anchors.fill: parent
            onClicked: rootPage.state = "typeNewUrl"
        }
    }

    states: [
        State {
            name: "favorites"
            PropertyChanges { target: navigationPanel; visible: false }
            PropertyChanges { target: favoritesPanel; visible: true }
            PropertyChanges { target: toolbar; y: UiConstants.DefaultMargin }
            PropertyChanges { target: plusBtn; y:  rootPage.height - 50 }
            PropertyChanges { target: currentBtn; z: 0 }
            PropertyChanges { target: favoritesBtn; z: 1 }
        },
        State {
            name: "current"
            PropertyChanges { target: navigationPanel; visible: true }
            PropertyChanges { target: favoritesPanel; visible: false }
            PropertyChanges { target: toolbar; y: UiConstants.DefaultMargin }
            PropertyChanges { target: plusBtn; y:  rootPage.height - 50 }
            PropertyChanges { target: currentBtn; z: 1 }
            PropertyChanges { target: favoritesBtn; z: 0 }
        },
        State {
            name: "currentFullScreen"
            PropertyChanges { target:  navigationPanel; visible: true }
            PropertyChanges { target:  favoritesPanel; visible: false }
            PropertyChanges { target:  toolbar; visible: true }
            PropertyChanges { target:  navigationPanel; state: "fullscreen" }
            PropertyChanges { target:  plusBtn; y:  rootPage.height }
        },
        State {
            name: "typeNewUrl"
            PropertyChanges { target: plusBtnLabel; visible: false }
            PropertyChanges { target:  plusBtn; y: 400 }
            PropertyChanges { target:  plusBtn; width: rootPage.width - UiConstants.DefaultMargin }
            PropertyChanges { target:  newUrlBar; visible: true }
            PropertyChanges { target:  newUrlBar; focus: true }
            PropertyChanges { target:  navigationPanel; opacity: 0 }
            PropertyChanges { target:  favoritesPanel; opacity: 0 }
            PropertyChanges { target: currentBtn; z: currentBtn.z }
            PropertyChanges { target: favoritesBtn; z: favoritesBtn.z }
        }
    ]

    transitions: [
        Transition {
            to: "typeNewUrl"
            PropertyAnimation { properties: "opacity"; duration: 300; }
            SequentialAnimation {
                PropertyAnimation { target: plusBtnLabel; properties: "visible"; duration: 0; }
                PropertyAnimation { properties: "x,y"; duration: 300; easing.type: Easing.InOutQuad }
                PropertyAnimation { properties: "width"; duration: 300; easing.type: Easing.InOutQuad }
                PropertyAnimation { properties: "visible,focus"; duration: 0; }
            }
        },
        Transition {
            from: "currentFullScreen"
            PropertyAnimation { properties: "x,y,width,scale"; duration: 300; easing.type: Easing.InOutQuad }
        },
        Transition {
            from: ""
            PropertyAnimation { properties: "y"; duration: 500; easing.type: Easing.InOutQuad }
        },
        Transition {
            from: "current"
            to: "currentFullScreen"
            PropertyAnimation { properties: "y"; duration: 300; }
        },
        Transition {
            to: "currentFullScreen"
            PropertyAnimation { target: plusBtn; properties: "x,y"; duration: 0; }
            PropertyAnimation { properties: "opacity"; duration: 500; }
        }
    ]

    Connections {
        target: navigationPanel
        onCurrentWebPageIndexChanged: {
            if (navigationPanel.currentWebPageIndex === -1)
                rootPage.state = "favorites";
        }
    }

    Component.onCompleted: {
        rootPage.state = "favorites"
    }
}

// Temporary hack to lock the app in portrait mode
    }
}
// end hack
