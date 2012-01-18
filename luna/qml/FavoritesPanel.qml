import QtQuick 1.1

Grid {
    id: favoritesGrid

    property real _childrenScale: 0

    columns: 2
    spacing: 10

    function showAnimated() {
        _childrenScale = 1;
    }

    Component {
        id: fakeBookmarkEntry
        Rectangle {
            color: "magenta"
            radius: 10
            scale: favoritesGrid._childrenScale
            width: 176
            height: 312

            Text {
                anchors.centerIn: parent
                text: "This doesn't work yet"
                rotation: -45
            }

            Behavior on scale {
                NumberAnimation {
                    duration: 400
                    easing.type: Easing.InOutQuad
                }
            }
        }
    }

    Component.onCompleted: {
       var i = 0;
       for (i = 0; i < 3; ++i)
           fakeBookmarkEntry.createObject(favoritesGrid);
    }
}
