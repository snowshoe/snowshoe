import QtQuick 1.1

Grid {
    id: bookmarkGrid
    columns: 2
    spacing: 10

    Component {
        id: fakeBookmarkEntry
        Rectangle {
            color: "magenta"
            radius: 10
            scale: 0
            width: 160
            height: 284

            Text {
                anchors.centerIn: parent
                text: "This doesn't work yet"
                rotation: -45
            }

            Behavior on scale {
                NumberAnimation {
                    duration: 250
                    easing.type: Easing.InOutQuad
                }
            }
        }
     }

    Component.onCompleted: {
       var i = 0
       for (i = 0; i < 3; ++i) {
           var elem = fakeBookmarkEntry.createObject(bookmarkGrid)
           elem.scale = 1
       }
    }
}
