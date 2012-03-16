import QtQuick 2.0
import "UiConstants.js" as UiConstants

Rectangle {
    id: navigationBar

    property variant currentWebView: null
    property variant navBarHeight: 64
    property variant navBarMargins: 10
    property variant navBarSeparatorWidth: 2
    property variant navBarNumberOfButtons: 3
    property variant navBarButtonHeight: (navBarHeight - (navBarMargins * 2)) // Top + Bottom
    property variant navBarButtonWidthLandscape: (UiConstants.LandscapeWidth - (navBarMargins * 2 * navBarNumberOfButtons) - (navBarSeparatorWidth * (navBarNumberOfButtons - 1))) / navBarNumberOfButtons
    property variant navBarButtonWidthPortrait: (UiConstants.PortraitWidth - (navBarMargins * 2 * navBarNumberOfButtons) - (navBarSeparatorWidth * (navBarNumberOfButtons - 1))) / navBarNumberOfButtons

    color: UiConstants.InterfaceColor
    height: navBarHeight

    anchors {
        left: parent.left
        right: parent.right
    }

    Row {
        id: controlsRow
        height: parent.height
        width: parent.width
        anchors {
            horizontalCenter: parent.horizontalCenter
            horizontalCenterOffset: navBarMargins // Add spacing at left
            verticalCenter: parent.verticalCenter
        }

        spacing: navBarMargins

        Button {
            disabledImage: "qrc:///mobile/navbar/btn_nav_back_disabled"
            pressedImage: "qrc:///mobile/navbar/btn_nav_back_pressed"
            standardImage: "qrc:///mobile/navbar/btn_nav_back_unpressed"
            disabled: { currentWebView ? !currentWebView.canGoBack : false }
            onClicked: { !disabled ? currentWebView.goBack() : null }
        }

        Image {
            anchors.verticalCenter: parent.verticalCenter
            source: "qrc:///mobile/navbar/component_divisor"
        }

        Button {
            disabledImage: "qrc:///mobile/navbar/btn_nav_next_disabled"
            pressedImage: "qrc:///mobile/navbar/btn_nav_next_pressed"
            standardImage: "qrc:///mobile/navbar/btn_nav_next_unpressed"
            disabled: { currentWebView ? !currentWebView.canGoForward : false }
            onClicked: { !disabled ? currentWebView.goForward() : null }
        }

        Image {
            anchors.verticalCenter: parent.verticalCenter
            source: "qrc:///mobile/navbar/component_divisor"
        }

        Button {
            property bool loading: { currentWebView ? currentWebView.loading : false }
            disabledImage: "qrc:///mobile/navbar/btn_nav_reload_disabled"
            pressedImage: { loading ? "qrc:///mobile/navbar/btn_nav_stop_pressed" : "qrc:///mobile/navbar/btn_nav_reload_pressed" }
            standardImage: { loading ? "qrc:///mobile/navbar/btn_nav_stop_unpressed" : "qrc:///mobile/navbar/btn_nav_reload_unpressed" }
            disabled: false
            onClicked: { loading ? currentWebView.stop() : currentWebView.reload() }
        }
    }

    states: [
        State {
            name: "hidden"
            AnchorChanges { target: navigationBar; anchors.top: parent.bottom; anchors.bottom: undefined }
        },
        State {
            name: "visible"
            AnchorChanges { target: navigationBar; anchors.top: undefined; anchors.bottom: rootPage.bottom }
        }

    ]
    transitions: [
        Transition {
            to: "visible"
            reversible: true
            AnchorAnimation { duration: 300 }
        }
    ]
}

