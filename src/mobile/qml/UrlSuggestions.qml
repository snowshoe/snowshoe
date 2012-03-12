import QtQuick 2.0
import "UiConstants.js" as UiConstants

Item {
    id: urlSuggestions
    signal suggestionSelected(string suggestedUrl)

    // FIXME: implement this model in C++ to provide valid and related data (i.e using history)
    ListModel {
        id: suggestionsModel
        ListElement { url: "google.com" }
        ListElement { url: "facebook.com" }
        ListElement { url: "webkit.org" }
    }

    ListView {
        anchors.fill: parent
        clip: true
        model: suggestionsModel
        delegate: suggestedItemPrototype
        interactive: false // If we may have more than 3 displayed results, then remove this.
    }

    Component {
        id: suggestedItemPrototype

        Item {
            id: suggestedItem
            height: 121
            width: parent.width

            Rectangle {
                id: suggestionRect
                color: mouseArea.pressed ? bottomBorder.color : "transparent"
                anchors.fill: parent
                Rectangle {
                    id: bottomBorder
                    color: "#555"
                    height: 1
                    anchors {
                        bottom: parent.bottom
                        left: parent.left
                        right: parent.right
                    }
                }
            }

            Text {
                id: suggestedUrl
                text: url
                color: mouseArea.pressed ? "#fff" : "#111"
                font.pixelSize: UiConstants.DefaultFontSize
                font.family: UiConstants.DefaultFontFamily
                baselineOffset: 2
                anchors.verticalCenter: suggestedItem.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: UiConstants.DefaultMargin
                anchors.rightMargin: UiConstants.DefaultMargin
                anchors.right:  parent.right
            }

            MouseArea {
                id: mouseArea
                anchors.fill: parent
                onClicked: urlSuggestions.suggestionSelected(suggestedUrl.text)
            }
        }
    }

}
