/****************************************************************************
 *   Copyright (C) 2012  Instituto Nokia de Tecnologia (INdT)               *
 *                                                                          *
 *   This file may be used under the terms of the GNU Lesser                *
 *   General Public License version 2.1 as published by the Free Software   *
 *   Foundation and appearing in the file LICENSE.LGPL included in the      *
 *   packaging of this file.  Please review the following information to    *
 *   ensure the GNU Lesser General Public License version 2.1 requirements  *
 *   will be met: http://www.gnu.org/licenses/old-licenses/lgpl-2.1.html.   *
 *                                                                          *
 *   This program is distributed in the hope that it will be useful,        *
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of         *
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the          *
 *   GNU Lesser General Public License for more details.                    *
 ****************************************************************************/

import QtQuick 2.0

PagedGrid {
    id: favoritesGrid
    model: topSitesModel
    showCloseButtons: false

    signal urlSelected(string url)

    ItemModel {
        id: topSitesModel
    }

    Component {
        id: fakeBookmarkEntry
        Image {
            id: fakeImage
            z: -1
            clip: true
            verticalAlignment: Image.AlignTop
            fillMode: Image.Pad
            property string url: ""

            Behavior on scale {
                NumberAnimation {
                    duration: 400
                    easing.type: Easing.InOutQuad
                }
            }

            Image {
                source: "qrc:///mobile/app/thumb_overlayer"
                anchors.fill: parent

                Image {
                    source: "qrc:///mobile/overlaybar/btn_favorite_unpressed"
                    width: 40
                    height: 40
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.top: parent.top
                    anchors.topMargin: 186
                }
                Text {
                    text: fakeImage.url
                    color: "#515050"
                    font.pixelSize: 20
                    font.family: "Nokia Pure Text Light"
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 6
                }
            }
        }
    }

    IndicatorRow {
        anchors {
            top: parent.bottom
            horizontalCenter: parent.horizontalCenter
            topMargin: 16
        }
        itemCount: favoritesGrid.pageCount
        currentItem: favoritesGrid.page
    }

    onItemClicked: urlSelected(item.url)

    Component.onCompleted: {
       var urls = ["kde.org", "google.com", "qt.nokia.com"];
       for (var i = 0; i < 3; ++i) {
           var elem = fakeBookmarkEntry.createObject(favoritesGrid, {source: ":/mobile/fav/icon0"+(i+1), url: urls[i]});
           topSitesModel.add(elem);
       }

    }
}
