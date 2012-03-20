import QtQuick 2.0
import "UiConstants.js" as UiConstants
import "tabmanager.js" as TabManager

Rectangle {
    id: navigationBar

    property variant currentWebView: null
    property variant navBarHeight: 80
    property variant navBarMargins: 10

    property alias navBarTimer: navBarTimer

    height: navBarHeight
    anchors {
        left: parent.left
        right: parent.right
    }

    Image {
        id: navBarBase
        source: "qrc:///mobile/navbar/bar_base"

        Button {
            id: buttonBack
            anchors.margins: navBarMargins
            baseImage: "qrc:///mobile/navbar/btn_base"
            pressedImage: "qrc:///mobile/navbar/btn_nav_back_pressed"
            standardImage: "qrc:///mobile/navbar/btn_nav_back_unpressed"
            visible: { currentWebView ? !currentWebView.canGoBack : false }
            onClicked: currentWebView.goBack()
        }

        Button {
            id: buttonNext
            anchors {
                margins: navBarMargins
                left: { buttonBack.visible ? buttonBack.right : parent.left }
            }
            baseImage: "qrc:///mobile/navbar/btn_base"
            pressedImage: "qrc:///mobile/navbar/btn_nav_next_pressed"
            standardImage: "qrc:///mobile/navbar/btn_nav_next_unpressed"
            visible: { currentWebView ? !currentWebView.canGoForward : false }
            onClicked: currentWebView.goForward()
        }

        Image {
            id: urlBar
            anchors {
                margins: navBarMargins
                left: { buttonBack.visible ? buttonNext.right : parent.left }
                right: buttonSettings.left
                verticalCenter: parent.verticalCenter
            }
            source: "qrc:///mobile/navbar/url_input"
            Button {
                property bool loading: { currentWebView ? currentWebView.loading : false }
                anchors.right: parent.right
                baseImage: { loading ? "qrc:///mobile/navbar/btn_nav_stop_unpressed" : "qrc:///mobile/navbar/btn_nav_reload_unpressed" }
                pressedImage: { loading ? "qrc:///mobile/navbar/btn_nav_stop_pressed" : "qrc:///mobile/navbar/btn_nav_reload_pressed" }
                standardImage: { loading ? "qrc:///mobile/navbar/btn_nav_stop_unpressed" : "qrc:///mobile/navbar/btn_nav_reload_unpressed" }
                visible: true
                onClicked: { loading ? currentWebView.stop() : currentWebView.reload() }
            }
        }

        Button {
            id: buttonSettings
            anchors {
                margins: navBarMargins
                right: parent.right
            }
            baseImage: "qrc:///mobile/navbar/btn_base"
            pressedImage: "qrc:///mobile/navbar/btn_nav_settings_pressed"
            standardImage: "qrc:///mobile/navbar/btn_nav_settings_unpressed"
            visible: true
            onClicked: null
        }
    }

    states: [
        State {
            name: "hidden"
            AnchorChanges { target: navigationBar; anchors.top: undefined; anchors.bottom: rootPage.top }
            StateChangeScript { script: TabManager.doTabFullScreenLayout(); }
        },
        State {
            name: "visible"
            AnchorChanges { target: navigationBar; anchors.top: rootPage.top; anchors.bottom: undefined }
            PropertyChanges { target: navBarTimer; running: true }
        }

    ]
    transitions: [
        Transition {
            to: "visible"
            reversible: true
            AnchorAnimation { duration: 300 }
        }
    ]
    Timer {
        id: navBarTimer
        interval: 2000
        onTriggered: navigationBar.state = "hidden"
    }
}
