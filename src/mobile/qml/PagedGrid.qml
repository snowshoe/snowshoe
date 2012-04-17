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
// TODO: Use a Qt model instead of this javascript file.
import "UiConstants.js" as UiConstants

Item {
    id: pagedGrid
    property QtObject model
    // The default height is equal to two items + the margin between them
    height: UiConstants.PagedGridSizeTable[1]*2 + UiConstants.PagedGridSizeTable[3]

    property int page: 0
    property int pageCount: 0
    property bool showCloseButtons: true
    // Number of visible tabs
    property int visibleTabs: 0

    signal itemClicked(variant item);
    signal itemClosed(variant item);
    signal relayoutFinished()

    Connections {
        target: model
        onCountChanged: {
            pageCount = Math.ceil(model.count / UiConstants.PagedGridItemsPerPage);
            page = pageCount ? Math.min(page, pageCount - 1) : 0;
            relayout();
        }
        onCurrentElementIndexChanged: {
            if (model.currentElementIndex !== -1)
                page = Math.floor(model.currentElementIndex / UiConstants.PagedGridItemsPerPage);
        }
    }

    onPageChanged: relayout();

    function relayout()
    {
        // FIXME: Remove this early return. "pageCount > 1" is a workaround for N9, but this code looks wrong anyway.
        if (!visible && pageCount > 1)
            return;

        var size = UiConstants.PagedGridSizeTable;
        var xMargin = 40;
        var yMargin = 16;
        var xStep = size[2]
        var yStep = size[3]

        var line = 0;
        var col = 0;
        var count = model.count;
        var firstTabToShow = page * UiConstants.PagedGridItemsPerPage;
        var lastTabToShow = Math.min(firstTabToShow + UiConstants.PagedGridItemsPerPage, count);
        visibleTabs = lastTabToShow - firstTabToShow;
        for (var i = 0; i < count; ++i)
        {
            var item = model.get(i);

            if (i >= lastTabToShow || i < firstTabToShow) {
                item.visible = false;
                continue;
            }

            if (col >= UiConstants.PagedGridNumColumns) {
                line++;
                col = 0;
            }

            item.visible = true;
            var coords = mapToItem(item.parent, xMargin + col * (size[0] + xStep), line * (size[1] + yStep));
            item.x = coords.x;
            item.y = coords.y;
            item.width = size[0];
            item.height = size[1];
            col++;
        }
        relayoutFinished();
    }

    SwipeArea {
        id: swipeArea
        anchors.fill: parent
        z: 1

        onClicked: {
            var firstTabToShow = page * UiConstants.PagedGridItemsPerPage;
            var lastTabToShow = Math.min(firstTabToShow + UiConstants.PagedGridItemsPerPage, pagedGrid.model.count);

            for (var i = firstTabToShow; i < lastTabToShow; ++i) {
                var item = pagedGrid.model.get(i);
                var mousePos = swipeArea.mapToItem(item.parent, mouse.x, mouse.y);
                var x = mousePos.x - item.x;
                var y = mousePos.y - item.y;
                if (x >= 0 &&
                    y >= 0 &&
                    x <= item.width &&
                    y <= item.height) {

                    // Check if the click was on close button
                    if (showCloseButtons &&
                        y < UiConstants.PagedGridCloseButtonHeight &&
                        item.width - x < UiConstants.PagedGridCloseButtonWidth) {
                        itemClosed(item);
                    } else {
                        parent.itemClicked(item);
                    }
                    break;
                }
            }
        }

        onSwipeLeft: {
            if (page < pageCount - 1)
                page++;
        }

        onSwipeRight: {
            if (page > 0)
                page--;
        }
    }

    Grid {
        anchors {
            fill: parent
            leftMargin: 40
        }
        spacing: 16
        columns: 2

        Repeater {
            model: 4

            Image {
                visible: index < visibleTabs

                source: "qrc:///mobile/grid/overlayer"
                height: UiConstants.PagedGridSizeTable[1]
                fillMode: Image.Pad
                verticalAlignment: Image.AlignBottom
                clip: true

                Text {
                    id: url
                    text: ""
                    color: "#515050"
                    horizontalAlignment: paintedWidth > width ? Text.AlignLeft : Text.AlignHCenter
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

                }
                Image {
                    source: "qrc:///mobile/scrollbar/suggestions_overlayer"
                    visible: url.paintedWidth > url.width
                    width: 30
                    anchors {
                        verticalCenter: url.verticalCenter
                        right: parent.right
                    }
                }
                Image {
                    id: closeBtn
                    source: "qrc:///mobile/grid/btn_close" + index
                    visible: showCloseButtons
                    anchors {
                        top: parent.top
                        right: parent.right
                    }
                }
                Image {
                    source: "qrc:///mobile/grid/btn_favorite_unpressed"
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.top: parent.top
                    anchors.topMargin: 186
                }
                Image {
                    source: "qrc:///mobile/grid/mask" + index
                }

                Connections {
                    target: pagedGrid
                    onRelayoutFinished: {
                        if (index < visibleTabs) {
                            var rawUrl = pagedGrid.model.get(page * UiConstants.PagedGridItemsPerPage + index).url;
                            rawUrl = rawUrl.replace(/(https?|file):\/\/\/?(www\.)?/, "");
                            rawUrl = rawUrl.replace(/\/.*/, "");
                            url.text = rawUrl;
                        }
                    }
                }
            }
        }
    }
}
