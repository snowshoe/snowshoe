import QtQuick 2.0
import "UiConstants.js" as UiConstants

Rectangle {
    id: rootPage
    width: UiConstants.PortraitWidth
    height: UiConstants.PortraitHeight
    color: "#aaa"
    clip: true

    PanelToggle {
        id: panelToggle
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.margins: UiConstants.DefaultMargin
        navigationEnabled: navigationPanel.hasOpennedTabs
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
        anchors.fill: parent

        onHasOpennedTabsChanged: {
            if (navigationPanel.hasOpennedTabs)
                rootPage.state = "favorites";
        }
    }


    Rectangle {
        id: urlBarArea
        color: "#fff"
        anchors.margins: UiConstants.DefaultMargin
        anchors.centerIn: rootPage
        width: rootPage.width - 20
        height: 40
        radius: 10

        UrlBar {
            id: urlBar
            width: parent.width
            anchors.verticalCenter: parent.verticalCenter
            property string previousUrl: ""
            focus: false

            onAccepted: {
                navigationPanel.createTab(UrlTools.fromUserInput(urlBar.text))
                rootPage.state = "navigationFullScreen"
                urlBar.text = ""
            }
        }
    }

    Rectangle {
        id: plusButton

        anchors.bottom: parent.bottom
        anchors.margins: UiConstants.DefaultMargin
        anchors.horizontalCenter: rootPage.horizontalCenter

        width: 40
        height: 40
        smooth: true
        radius: 10

        Text {
            id: plusLabel
            anchors.centerIn: parent
            font.bold: true
            font.pixelSize: 24
            color: "#666"
            text: "+"
        }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                urlBar.previousUrl = ""
                rootPage.state = "typeNewUrl"
            }
        }
    }

    UrlSuggestions {
        id: urlSuggestions
        width: rootPage.width
        anchors.top: rootPage.top
        anchors.bottom: plusButton.top
        anchors.bottomMargin: 26
        onSuggestionSelected: urlBar.text = suggestedUrl
        // Only lookup suggestions once you have at least 2 characters to provide better results.
        opacity: urlBar.text != urlBar.previousUrl && urlBar.text.length >= 2 ? 1 : 0
    }

    NavigationBar {
        id: navigationBar
        state: "hidden"
    }

    state: "splash"
    states: [
        State {
            name: "splash"
            AnchorChanges { target: panelToggle; anchors.bottom: parent.top; anchors.top: undefined }
            PropertyChanges { target: favoritesPanel; visible: false }
            PropertyChanges { target: navigationPanel; visible: false }
            AnchorChanges { target: plusButton; anchors.bottom: undefined; anchors.top: parent.bottom }
            PropertyChanges { target: urlBarArea; opacity: 0 }
        },
        State {
            name: "favorites"
            StateChangeScript { script: favoritesPanel.showAnimated() }
            PropertyChanges { target: navigationPanel; visible: false }
            PropertyChanges { target: favoritesPanel; visible: true } // Note: this is redundant but needed for N9.
            PropertyChanges { target: urlBarArea; opacity: 0 }
        },
        State {
            name: "navigation"
            PropertyChanges { target: favoritesPanel; visible: false }
            PropertyChanges { target: navigationPanel; visible: true } // Note: this is redundant but needed for N9.
            PropertyChanges { target: urlBarArea; opacity: 0 }
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
            PropertyChanges { target: urlBarArea; opacity: 0 }
        },
        State {
            name: "typeNewUrl"
            AnchorChanges { target: panelToggle; anchors.bottom: parent.top; anchors.top: undefined }
            PropertyChanges { target: favoritesPanel; opacity: 0 }
            PropertyChanges { target: navigationPanel; opacity: 0 }
            PropertyChanges { target: plusButton; opacity: 0 }
            PropertyChanges { target: urlBar; focus: true }
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
                PropertyAnimation { target: urlBarArea; properties: "opacity"; duration: 300 }
                PropertyAnimation { properties: "x,y,width,scale,opacity"; duration: 300; easing.type: Easing.InOutQuad }
                AnchorAnimation { duration: 0 }
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

    Timer {
        running: true
        interval: 800
        onTriggered: rootPage.state = "favorites"
    }
}
