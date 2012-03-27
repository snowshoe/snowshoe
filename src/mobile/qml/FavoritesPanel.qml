import QtQuick 2.0

Grid {
    id: favoritesGrid
    columns: 2
    spacing: 16

    Component {
        id: fakeBookmarkEntry
        Rectangle {
            color: "darkgrey"
            radius: 22
            width: 192
            height: 286

            Behavior on scale {
                NumberAnimation {
                    duration: 400
                    easing.type: Easing.InOutQuad
                }
            }

            Image {
                source: ":/mobile/app/thumb_overlayer"
                anchors.fill: parent

                Image {
                    source: ":/mobile/fav/btn_favorite"
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.top: parent.top
                    anchors.topMargin: 209
                }
                Text {
                    text: "foobar.com"
                    color: "#515050"
                    font.pixelSize: 20
                    font.family: "Nokia Pure Text Light"
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 14
                }
            }
        }
    }

    Component.onCompleted: {
       for (var i = 0; i < 3; ++i)
           fakeBookmarkEntry.createObject(favoritesGrid);
    }
}
