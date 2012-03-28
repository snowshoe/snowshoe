import QtQuick 2.0
import "UiConstants.js" as UiConstants

Rectangle {
    id: rootPage
    width: UiConstants.PortraitWidth
    height: UiConstants.PortraitHeight
    color: "#aaa"
    clip: true
    property bool shouldOpenNewTab: false

    Image {
        anchors.fill: parent
        source: ":/mobile/app/bg_image"
    }

    PanelToggle {
        id: panelToggle
        anchors.top: parent.top
        anchors.topMargin: 24
        anchors.horizontalCenter: parent.horizontalCenter
        navigationEnabled: navigationPanel.hasOpennedTabs
        onTopSitesSelected: {
            rootPage.state = "favorites";
        }
        onTabsSelected: {
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

        onWebViewMaximized: {
            rootPage.state = "navigationFullScreen";
        }
        onWebViewMinimized: {
            rootPage.state = "navigation";
        }

        onUrlInputFocusChanged: {
            urlBar.text = navigationPanel.url
            rootPage.shouldOpenNewTab = false
            rootPage.state = "typeNewUrl"
        }

    }

    Image {
        id: plusButton
        source: ":/mobile/nav/btn_plus"
        width: 56
        height: 57

        anchors.bottom: parent.bottom
        anchors.bottomMargin: 24
        anchors.horizontalCenter: rootPage.horizontalCenter

        MouseArea {
            anchors.fill: parent
            onClicked: {
                urlBar.text = ""
                rootPage.shouldOpenNewTab = true
                rootPage.state = "typeNewUrl"
            }
        }
    }

    Rectangle {
        id: urlArea
        color: "white"
        opacity: 0
        anchors.fill: rootPage

        Item {
            id: urlBarBackground
            height: 100
            anchors {
                bottom: urlArea.bottom
                left: urlArea.left
                right: urlArea.right
            }

            Image {
                source: ":/mobile/url/bg_typing"
                anchors { bottom: parent.bottom; left: parent.left; right: parent.right }
            }

            UrlBar {
                id: urlBar
                anchors {
                    fill: parent
                    topMargin: 21
                    bottomMargin: 22
                    leftMargin: UiConstants.DefaultMargin
                    rightMargin: UiConstants.DefaultMargin
                }
                verticalAlignment: TextInput.AlignVCenter
                input.focus: false

                onAccepted: {
                    navigationPanel.openUrl(UrlTools.fromUserInput(urlBar.text), rootPage.shouldOpenNewTab)
                }

                Image {
                    source: clearUrlButton.pressed ? ":/mobile/url/btn_cancel_pressed" : ":/mobile/url/btn_cancel_unpressed"
                    visible: urlBar.text != ""
                    anchors {
                        verticalCenter: parent.verticalCenter
                        right: parent.right
                    }
                    MouseArea {
                        id: clearUrlButton
                        anchors.fill: parent
                        onClicked: urlBar.text = ""
                    }
                }
            }
        }

        UrlSuggestions {
            id: urlSuggestions
            width: rootPage.width
            height: 400
            clip: true
            anchors { bottom: urlBarBackground.top; }
            onSuggestionSelected: {
                navigationPanel.openUrl(UrlTools.fromUserInput(suggestedUrl), rootPage.shouldOpenNewTab)
            }
            onSearchSelected: {
                var searchUrl = "http://www.google.com/search?q=" + urlBar.text.replace(" ", "+")
                navigationPanel.openUrl(searchUrl, rootPage.shouldOpenNewTab)
            }
            opacity: urlBar.text != "" && urlBar.text.length > 0

            Image {
                id: separator
                source: ":/mobile/scrollbar/suggestions_separator"
                anchors { left: parent.left; right: parent.right; bottom: parent.bottom }
            }
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
            PropertyChanges { target: plusButton; opacity: 1 }
        },
        State {
            name: "favorites"
            PropertyChanges { target: plusButton; opacity: 1 }
            PropertyChanges { target: navigationPanel; visible: false }
            PropertyChanges { target: favoritesPanel; visible: true } // Note: this is redundant but needed for N9.
        },
        State {
            name: "navigation"
            PropertyChanges { target: plusButton; opacity: 1 }
            PropertyChanges { target: favoritesPanel; visible: false }
            PropertyChanges { target: navigationPanel; visible: true } // Note: this is redundant but needed for N9.
        },
        State {
            name: "navigationFullScreen"
            PropertyChanges { target: favoritesPanel; visible: false }
            PropertyChanges { target: navigationPanel; visible: true }  // Note: this is redundant but needed for N9.
            AnchorChanges { target: panelToggle; anchors.bottom: parent.top; anchors.top: undefined }
            StateChangeScript { script: panelToggle.resetToTabs() }
            AnchorChanges { target: plusButton; anchors.bottom: undefined; anchors.top: parent.bottom }
        },
        State {
            name: "typeNewUrl"
            AnchorChanges { target: panelToggle; anchors.bottom: parent.top; anchors.top: undefined }
            PropertyChanges { target: favoritesPanel; visible: false }
            PropertyChanges { target: navigationPanel; visible: false }
            AnchorChanges { target: plusButton; anchors.bottom: undefined; anchors.top: parent.bottom }
            PropertyChanges { target: urlSuggestions; contentY: 0 }
            PropertyChanges { target: urlArea; opacity: 1 }
        }
    ]

    transitions: [
        Transition {
            from: "splash"
            AnchorAnimation { duration: 200; easing.type: Easing.InOutQuad }
        },
        Transition {
            to: "typeNewUrl"
            PropertyAnimation { properties: "opacity"; duration: 600 }
            SequentialAnimation {
                PropertyAction { target: plusButton; properties: "visible" }
                AnchorAnimation { duration: 300; easing.type: Easing.InOutQuad }
                PropertyAnimation { properties: "width"; duration: 300; easing.type: Easing.InOutQuad }
                PropertyAction { properties: "visible,focus" }
                PropertyAction { target: urlBar.input; property: "focus"; value: "true" }
            }
        },
        Transition {
            from: "typeNewUrl"
            to: "navigationFullScreen"
            SequentialAnimation {
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
