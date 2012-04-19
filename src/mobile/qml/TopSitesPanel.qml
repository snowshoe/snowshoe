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

Item {
    id: root
    height: topSitesGrid.height + 25 + indicatorRow.height

    signal urlSelected(string url)

    IndicatorRow {
        id: indicatorRow
        anchors {
            bottom: root.bottom
            left: root.left
            right: root.right
        }
        itemCount: topSitesGrid.pageCount
        currentItem: topSitesGrid.page
    }

    PagedGrid {
        id: topSitesGrid
        model: topSitesModel
        showCloseButtons: false

        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
        }

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
            }
        }

        onItemClicked: {
            console.log('clicked on url' + item.url)
            root.urlSelected(item.url)
        }
    }

    Component.onCompleted: {
       var urls = ["http://www.kde.org/", "http://www.google.com/", "http://www.qt.nokia.com/"];
       for (var i = 0; i < 3; ++i) {
           //!!! Start of temporary code while topsites isn't ready.
           if (!BookmarkModel.contains(urls[i]))
               BookmarkModel.insert(urls[i], urls[i]);
           //!!! End of temporary code

           var elem = fakeBookmarkEntry.createObject(topSitesGrid, {source: ":/mobile/fav/icon0"+(i+1), url: urls[i]});
           topSitesModel.add(elem);
       }
    }
}
