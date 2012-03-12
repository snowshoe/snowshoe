import QtQuick 2.0

import "UiConstants.js" as UiConstants

TextInput {
    id: root
    font.pixelSize: UiConstants.DefaultFontSize
    font.family: UiConstants.DefaultFontFamily
    baselineOffset: 2
    clip: true
    text: ""

    onFocusChanged: if (!focus) closeSoftwareInputPanel()

    Text {
        id: textHint
        text: "Type the address"
        anchors.fill: root
        color: "#bbb"
        font.pixelSize: parent.font.pixelSize
        anchors.leftMargin: 8
        opacity: root.text == "" ? 1 : 0
    }


}

