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
    height: pagedGrid.height + 25 + indicatorRow.height

    signal urlSelected(string url)

    IndicatorRow {
        id: indicatorRow
        anchors {
            bottom: root.bottom
            left: root.left
            right: root.right
        }
        itemCount: pagedGrid.pageCount
        maxItems: UiConstants.TopSitesMaxPages
        currentItem: pagedGrid.currentPage
    }

    Component {
        id: pagedItemDelegate
        Image {
            property string url: model.url
            source: model.thumbnail
            height: UiConstants.PagedGridSizeTable[1]
            fillMode: Image.Pad
            verticalAlignment: Image.AlignBottom
            clip: true

            Text {
                text: index + (pagedGrid.currentPage * 4) + 1
                color: "#C1C2C3"
                font.pixelSize: 30
                font.family: "Nokia Pure Headline Light"
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                anchors {
                    top: parent.top
                    bottom: parent.bottom
                    left: parent.left
                    right: parent.right
                    topMargin: 71
                    bottomMargin: 140
                    leftMargin: 69
                    rightMargin: 62
                }
            }

            PageThumbUrl {
                id: displayedUrl
                url: model.url
                urlFadeImage: "qrc:///mobile/grid/overlayer_mysites_url"
                anchors {
                    bottom: parent.bottom
                    left: parent.left
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
        }
    }

    PagedGrid {
        id: pagedGrid
        model: BookmarkModel
        delegate: pagedItemDelegate
        emptyItemDelegate: Image { source: "qrc:///mobile/grid/thumb_empty_slot" }
        maxPages: indicatorRow.maxItems
        anchors {
            left: parent.left
            right: parent.right
            top: parent.top
        }
        onItemClicked: {
            var item = pagedGrid.itemAt(index)
            if (y < 176)
                root.urlSelected(item.url)
            else
                BookmarkModel.remove(item.url)
        }
    }
}
