import QtQuick 2.0
import "UiConstants.js" as UiConstants

Item {
    id: suggestedItem

    property alias url: suggestedUrl.text
    property alias title: suggestedTitle.text

    signal searchSelected()
    signal suggestionSelected(string url)

    Image {
        id: suggestionRect
        source: "qrc:///mobile/urlbar_bg_browsing"
        anchors { left: parent.left; right: parent.right; bottom: parent.bottom }
    }

    Text {
        id: suggestedTitle
        text: ""
        color: UiConstants.PrimaryColor
        font.pixelSize: UiConstants.DefaultFontSize
        font.family: UiConstants.DefaultFontFamily
        anchors {
            left: parent.left
            right: parent.right
            top: parent.top
            leftMargin: UiConstants.DefaultMargin
            rightMargin: UiConstants.DefaultMargin
            topMargin: 11
        }
    }

    Text {
        id: suggestedUrl
        text: ""
        color: UiConstants.SecondaryColor
        font.pixelSize: UiConstants.SecondaryFontSize
        font.family: UiConstants.DefaultFontFamily
        font.weight: Font.Light
        anchors {
            left: parent.left
            right: parent.right
            bottom: parent.bottom
            leftMargin: UiConstants.DefaultMargin
            rightMargin: UiConstants.DefaultMargin
            bottomMargin: 19
        }
    }

    Image {
        id: fadingLayer
        source: "qrc:///mobile/url_suggestions_overlayer"
        anchors {
            right: parent.right
            top: parent.top
            bottom: parent.bottom
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        onClicked: {
            if (suggestedItem.isSearch)
                suggestedItem.searchSelected()
            else
                suggestedItem.suggestionSelected(suggestedUrl.text)
        }
    }
}
