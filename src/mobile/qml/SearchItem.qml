import QtQuick 2.0
import "UiConstants.js" as UiConstants

Item {
    id: suggestedItem
    height: 80

    signal searchSelected()

    Image {
        id: suggestionRect
        source: "qrc:///mobile/urlbar_bg_browsing"
        anchors { left: parent.left; right: parent.right; bottom: parent.bottom }
    }

    Image {
        id: searchIcon
        source: "qrc:///mobile/button_google_search"
        width: 56
        height: 57
        anchors {
            left: parent.left
            leftMargin: UiConstants.DefaultMargin
            verticalCenter: suggestedItem.verticalCenter
        }
    }

    Text {
        id: titleUrl
        text: "Search on Google"
        color: UiConstants.PrimaryColor
        font.pixelSize: UiConstants.DefaultFontSize
        font.family: UiConstants.DefaultFontFamily
        font.bold: true
        baselineOffset: 2
        anchors.verticalCenter: suggestedItem.verticalCenter
        anchors.left: searchIcon.right
        anchors.leftMargin: 16
        anchors.rightMargin: UiConstants.DefaultMargin
        anchors.right: parent.right
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        onClicked: suggestedItem.searchSelected()
    }
}
