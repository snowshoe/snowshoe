import QtQuick 2.0

TextInput {
    id: root
    font.pixelSize: 24
    font.family: "Nokia Pure Text"
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

