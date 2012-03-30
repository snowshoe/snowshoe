import QtQuick 2.0
import "UiConstants.js" as UiConstants
import "tabmanager.js" as TabManager

Rectangle {
    id: navigationBar

    property variant currentWebView: null
    property variant navBarHeight: 105
    property variant navBarMargins: UiConstants.NavBarLongMargin

    property string url: currentWebView ? currentWebView.url : ""
    property alias hidingTimer: hidingTimer

    property alias urlInputFocus: urlArea.pressed

    height: navBarHeight
    anchors {
        left: parent.left
        right: parent.right
    }

    Image {
        id: navBarBase
        source: ":/mobile/navbar/bg_image"
        anchors.fill: parent

        Button {
            id: buttonBack
            anchors {
                left: parent.left
                leftMargin: UiConstants.NavBarLongMargin
            }
            pressedImage: ":/mobile/navbar/btn_nav_back_pressed"
            unpressedImage: ":/mobile/navbar/btn_nav_back_unpressed"
            visible: { currentWebView ? currentWebView.canGoBack : false }
            onClicked: {
                currentWebView.goBack();
                hidingTimer.stop();
            }
        }

        Button {
            id: buttonNext
            anchors {
                left: { buttonBack.visible ? buttonBack.right : parent.left }
                leftMargin: buttonBack.visible ? UiConstants.NavBarShortMargin : UiConstants.NavBarLongMargin
            }
            pressedImage: ":/mobile/navbar/btn_nav_next_pressed"
            unpressedImage: ":/mobile/navbar/btn_nav_next_unpressed"
            visible: { currentWebView ? currentWebView.canGoForward : false }
            onClicked: {
                currentWebView.goForward();
                hidingTimer.stop();
            }
        }

        BorderImage {
            id: urlBar
            border { left: 26; top: 26; right: 26; bottom: 26 }
            horizontalTileMode: BorderImage.Repeat
            verticalTileMode: BorderImage.Repeat
            anchors {
                left: { buttonNext.visible ? buttonNext.right : (buttonBack.visible ? buttonBack.right : parent.left) }
                leftMargin: buttonNext.visible || buttonBack.visible ? UiConstants.NavBarShortMargin : UiConstants.NavBarLongMargin
                verticalCenter: parent.verticalCenter
                right: buttonSettings.left
                rightMargin: UiConstants.NavBarShortMargin
            }
            source: ":/mobile/navbar/url_input"
            Item {
                anchors {
                    fill: parent
                    rightMargin: reloadStopButton.width
                }
                clip: true
                Text {
                    id: input
                    anchors {
                        fill: parent
                        topMargin: 15
                        leftMargin: 15
                        verticalCenter: parent.verticalCenter
                    }
                    font.pixelSize: UiConstants.DefaultFontSize
                    font.family: UiConstants.DefaultFontFamily
                    color: UiConstants.PrimaryColor
                    text: navigationBar.url
                }
                MouseArea {
                    id: urlArea
                    anchors.fill: parent
                }
            }
            Button {
                id: reloadStopButton
                property bool loading: { currentWebView ? currentWebView.loading : false }
                anchors.right: parent.right
                pressedImage: { loading ? ":/mobile/navbar/btn_nav_stop_pressed" : ":/mobile/navbar/btn_nav_reload_pressed" }
                unpressedImage: { loading ? ":/mobile/navbar/btn_nav_stop_unpressed" : ":/mobile/navbar/btn_nav_reload_unpressed" }
                visible: true
                onClicked: {
                    if (loading) {
                        currentWebView.stop();
                        hidingTimer.restart();
                    } else {
                        currentWebView.reload();
                        hidingTimer.stop();
                    }
                }
            }
        }

        Button {
            id: buttonSettings
            anchors {
                margins: navBarMargins
                right: parent.right
            }
            pressedImage: ":/mobile/navbar/btn_nav_settings_pressed"
            unpressedImage: ":/mobile/navbar/btn_nav_settings_unpressed"
            visible: true
            onClicked: null
        }
    }

    states: [
        State {
            name: "hidden"
            AnchorChanges { target: navigationBar; anchors.top: undefined; anchors.bottom: parent.top }
            StateChangeScript { script: TabManager.doTabResetY(); }
        },
        State {
            name: "visible"
            AnchorChanges { target: navigationBar; anchors.top: parent.top; anchors.bottom: undefined }
        }

    ]
    transitions: [
        Transition {
            to: "visible"
            reversible: true
            AnchorAnimation { duration: 200 }
        }
    ]
    Timer {
        id: hidingTimer
        interval: 2000
        onTriggered: navigationBar.state = "hidden"
    }
}
