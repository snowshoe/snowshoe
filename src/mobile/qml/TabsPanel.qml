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

    IndicatorRow {
        id: indicatorRow
        anchors {
            bottom: root.bottom
            left: root.left
            right: root.right
        }
        itemCount: pagedGrid.pageCount
        maxItems: UiConstants.TabsMaxPages
        currentItem: pagedGrid.currentPage
    }

    Component {
        id: pagedItemComponent
        Image {
            id: pagedItem
            property string url: model.url
            source: model.thumbnail
            height: UiConstants.PagedGridSizeTable[1]
            fillMode: Image.Pad
            verticalAlignment: Image.AlignBottom
            clip: true

            Text {
                // FIXME: We should expose a property like index to PageFillGrid's delegate rather than
                // depending on PageFillGrid internal structure as we retrieve parent's attribute.
                text: pagedItem.parent.pageOffset + index + 1
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
                    topMargin: 110
                    bottomMargin: 101
                    leftMargin: 69
                    rightMargin: 62
                }
            }

            PageThumbUrl {
                id: displayedUrl
                url: model.url
                urlFadeImage: "qrc:///mobile/grid/overlayer_tabs_url"
                anchors {
                    bottom: parent.bottom
                    left: parent.left
                    right: parent.right
                }
            }
        }
    }

    PagedGrid {
        id: pagedGrid
        model: TabsModel
        delegate: pagedItemComponent
        emptyItemDelegate: Image { source: "qrc:///mobile/grid/thumb_empty_slot" }
        maxPages: indicatorRow.maxItems
        anchors {
            left: parent.left
            right: parent.right
            top: parent.top
        }
        onItemClicked: {
            if (y < UiConstants.PagedGridCloseButtonHeight
                && (UiConstants.PagedGridSizeTable[0] - x) <= UiConstants.PagedGridCloseButtonWidth) {
                TabsModel.remove(index);
            } else
                TabsModel.currentWebViewIndex = index;
        }
    }
}
