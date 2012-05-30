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
import "UiConstants.js" as UiConstants

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
        maxItems: 3
        currentItem: topSitesGrid.currentPage
    }

    Component {
        id: bookmarkEntry
        Image {
            property string url: model.url
            property bool fadeUrl: false

            source: "qrc:///mobile/grid/pin_overlayer"
            height: UiConstants.PagedGridSizeTable[1]
            fillMode: Image.Pad
            verticalAlignment: Image.AlignBottom
            clip: true

            Text {
                id: displayedUrl
                text: url.replace(/(https?|file):\/\/\/?(www\.)?/, "").replace(/\/.*/, "");
                color: "#515050"
                horizontalAlignment: fadeUrl ? Text.AlignLeft : Text.AlignHCenter
                font.pixelSize: 20
                font.family: "Nokia Pure Text Light"
                anchors {
                    bottom: parent.bottom
                    left: parent.left
                    right: parent.right
                    bottomMargin: 10
                    leftMargin: 14
                    rightMargin: 14
                }
                onWidthChanged: fadeUrl = paintedWidth > width

            }
            Image {
                id: urlFade
                source: "qrc:///mobile/scrollbar/suggestions_overlayer"
                visible: fadeUrl
                width: 30
                anchors {
                    verticalCenter: displayedUrl.verticalCenter
                    right: parent.right
                }
            }
            Image {
                id: pinButton
                source: "qrc:///mobile/grid/btn_pin_pressed"
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: parent.top
                anchors.topMargin: 186
            }
            Image {
                source: "qrc:///mobile/grid/mask" + Math.max(0, index)
            }
        }
    }

    PagedGrid {
        id: topSitesGrid
        model: BookmarkModel
        delegate: bookmarkEntry
        emptyItemDelegate: Image { source: "qrc:///mobile/grid/thumb_empty_slot"; }
        maxPages: indicatorRow.maxItems
        anchors {
            left: parent.left
            right: parent.right
            top: parent.top
        }
        onItemClicked: {
            var item = topSitesGrid.itemAt(index)
            if (y < 176) root.urlSelected(item.url)
            else BookmarkModel.remove(item.url)
        }
    }
}
