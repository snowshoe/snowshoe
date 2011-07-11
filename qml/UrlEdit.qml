import QtQuick 1.1

Item {
    property alias text : urlInput.text
    property int verticalMargin : 5
    property int horizontalMargin : 9

    width: parent.width
    height : urlInput.height + verticalMargin * 2

    signal urlEntered(string url)

    BorderImage {
        source : "qrc:///images/tab_url_input.png"
        anchors.verticalCenter: parent.verticalCenter
        width: parent.width
        border { left: 10; top: 10; right: 10; bottom: 10 }
    }

    TextInput {
        id : urlInput
        focus : true
        font.pointSize: 10
        font.bold: true
        y : parent.verticalMargin
        x : parent.horizontalMargin

        Keys.onEnterPressed: {
            urlEdit.urlEntered(urlInput.text)
        }

        Keys.onReturnPressed: {
            urlEdit.urlEntered(urlInput.text)
        }
    }
    MouseArea {
        anchors.fill: urlEdit
        onDoubleClicked: { urlInput.selectAll(); urlInput.focus = true }
        onClicked: urlInput.focus = true
    }
}
