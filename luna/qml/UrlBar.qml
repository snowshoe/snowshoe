import QtQuick 1.1

TextInput {
    font.pixelSize: 24
    font.family: "Nokia Pure Text"
    baselineOffset: 2
    clip: true
    text: "http://"

    onFocusChanged: if (!focus) closeSoftwareInputPanel()
}

