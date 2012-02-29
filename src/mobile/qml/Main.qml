import QtQuick 2.0
import "UiConstants.js" as UiConstants

Rectangle {
    id: rootPage
    color: "#202022"
    clip: true

    PanelToggle {
        id: panelToggle
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.margins: UiConstants.DefaultMargin
        navigationEnabled: navigationPanel.tabCount !== 0
        onFavoritesSelected: {
            rootPage.state = "favorites";
        }
        onNavigationSelected: {
            rootPage.state = "navigation";
        }
    }

    FavoritesPanel {
        id: favoritesPanel
        anchors.centerIn: parent
    }

    NavigationPanel {
        id: navigationPanel
        anchors.centerIn: parent
    }

    Rectangle {
        id: plusButton

        anchors.bottom: parent.bottom
        anchors.margins: UiConstants.DefaultMargin
        anchors.horizontalCenter: rootPage.horizontalCenter

        width: 40
        height: 40
        smooth: true
        radius: 20

        Text {
            id: plusLabel
            anchors.centerIn: parent
            font.bold: true
            font.pixelSize: 24
            color: "#666"
            text: "+"
        }

        UrlBar {
            id: newUrlBar
            visible: false
            anchors.centerIn: parent
            width: parent.width - 20

            onAccepted: {
                navigationPanel.createTab(newUrlBar.text)
                newUrlBar.text = "http://"
                rootPage.state = "navigationFullScreen"
            }
        }

        MouseArea {
            anchors.fill: parent
            onClicked: rootPage.state = "typeNewUrl"
        }
    }

    state: "splash"
    states: [
        State {
            name: "splash"
            AnchorChanges { target: panelToggle; anchors.bottom: parent.top; anchors.top: undefined }
            PropertyChanges { target: favoritesPanel; visible: false }
            PropertyChanges { target: navigationPanel; visible: false }
            AnchorChanges { target: plusButton; anchors.bottom: undefined; anchors.top: parent.bottom }
        },
        State {
            name: "favorites"
            StateChangeScript { script: favoritesPanel.showAnimated() }
            PropertyChanges { target: navigationPanel; visible: false }
            PropertyChanges { target: favoritesPanel; visible: true } // Note: this is redundant but needed for N9.
        },
        State {
            name: "navigation"
            PropertyChanges { target: favoritesPanel; visible: false }
            PropertyChanges { target: navigationPanel; visible: true } // Note: this is redundant but needed for N9.
        },
        State {
            name: "navigationFullScreen"
            AnchorChanges { target: panelToggle; anchors.bottom: parent.top; anchors.top: undefined }
            StateChangeScript { script: panelToggle.resetToNavigation() }
            PropertyChanges { target: favoritesPanel; visible: false }
            PropertyChanges { target: navigationPanel; state: "fullscreen" }
            AnchorChanges { target: plusButton; anchors.bottom: undefined; anchors.top: parent.bottom }
            PropertyChanges { target: plusButton; opacity: 0 }
            PropertyChanges { target: navigationPanel; visible: true }  // Note: this is redundant but needed for N9.
        },
        State {
            name: "typeNewUrl"
            AnchorChanges { target: panelToggle; anchors.bottom: parent.top; anchors.top: undefined }
            PropertyChanges { target: favoritesPanel; opacity: 0 }
            PropertyChanges { target: navigationPanel; opacity: 0 }
            AnchorChanges { target: plusButton; anchors.bottom: undefined; anchors.verticalCenter: parent.verticalCenter }
            PropertyChanges { target: plusLabel; visible: false }
            PropertyChanges { target: plusButton; width: rootPage.width - UiConstants.DefaultMargin }
            PropertyChanges { target: newUrlBar; visible: true; focus: true }
        }
    ]

    transitions: [
        Transition {
            from: "splash"
            AnchorAnimation { duration: 200; easing.type: Easing.InOutQuad }
        },
        Transition {
            to: "typeNewUrl"
            PropertyAnimation { properties: "opacity"; duration: 300 }
            SequentialAnimation {
                PropertyAction { target: plusLabel; properties: "visible" }
                AnchorAnimation { duration: 300; easing.type: Easing.InOutQuad }
                PropertyAnimation { properties: "width"; duration: 300; easing.type: Easing.InOutQuad }
                PropertyAction { properties: "visible,focus" }
            }
        },
        Transition {
            from: "typeNewUrl"
            to: "navigationFullScreen"
            SequentialAnimation {
                PropertyAnimation { target: plusButton; properties: "opacity"; duration: 300 }
                PropertyAnimation { properties: "x,y,width,scale,opacity"; duration: 300; easing.type: Easing.InOutQuad }
                AnchorAnimation { duration: 0 }
                PropertyAction { targets: [plusButton, plusLabel, newUrlBar]; properties: "visible,focus,width,opacity" }
            }
        },
        Transition {
            from: "navigation"
            to: "navigationFullScreen"
            reversible: true
            SequentialAnimation {
                AnchorAnimation { targets: [plusButton, panelToggle]; duration: 300 }
                PropertyAction { properties: "opacity" }
            }
        }
    ]

    Connections {
        target: navigationPanel
        onCurrentTabIndexChanged: {
            if (navigationPanel.currentTabIndex === -1)
                rootPage.state = "favorites";
        }
    }

    Timer {
        running: true
        interval: 800
        onTriggered: rootPage.state = "favorites"
    }
}
