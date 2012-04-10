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
    property QtObject model
    // The default height is equal to two items + the margin between them
    height: UiConstants.PagedGridSizeTable[1]*2 + UiConstants.PagedGridSizeTable[3]

    property int page: 0
    property int pageCount: 0

    signal itemClicked(variant item);

    Connections {
        target: model
        onCountChanged: {
            pageCount = model.count / UiConstants.PagedGridItemsPerPage;
            page = Math.min(page, pageCount);
            relayout();
        }
    }

    onPageChanged: relayout();

    function relayout()
    {
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
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        z: 1

        onClicked: {
            var firstTabToShow = page * UiConstants.PagedGridItemsPerPage;
            var lastTabToShow = Math.min(firstTabToShow + UiConstants.PagedGridItemsPerPage, model.count);

            for (var i = firstTabToShow; i < lastTabToShow; ++i) {
                var item = model.get(i);
                var x = mouse.x - item.x;
                var y = mouse.y - item.y;
                if (x >= 0 &&
                    y >= 0 &&
                    x <= item.width &&
                    y <= item.height) {
                    parent.itemClicked(item);
                    break;
                }
            }
        }
    }
}
