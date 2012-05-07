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
import Snowshoe 1.0

Item {
    id: pagedGrid

    // Read/write properties.
    property QtObject model: null
    property Component delegate: null
    property int extraMargin: 40
    property int itemWidth: 192
    property int itemHeight: 263

    property int rowsPerPage: 2
    property int columnsPerPage: 2
    property int spacing: 16
    property int currentPage: 0

    // Read only properties.
    property int page: 0
    property int pageWidth: columnsPerPage * itemWidth + (columnsPerPage - 1) * spacing
    property int pageHeight: rowsPerPage * itemHeight + (rowsPerPage - 1) * spacing
    property int itemsPerPage: rowsPerPage * columnsPerPage
    property alias pageCount: grid.pageCount

    width: grid.pageWidth + 2 * extraMargin
    height: grid.pageHeight
    clip: true

    // x and y will be given in coordinates relative to the clicked item.
    signal itemClicked(int index, int x, int y);

    function itemAt(index) {
        return grid.itemAt(index)
    }

    PageFillGrid {
        id: grid
        model: pagedGrid.model
        delegate: pagedGrid.delegate
        spacing: pagedGrid.spacing
        itemWidth: pagedGrid.itemWidth
        itemHeight: pagedGrid.itemHeight
        rowsPerPage: pagedGrid.rowsPerPage
        columnsPerPage: pagedGrid.columnsPerPage
        x: extraMargin - currentPage * (pageWidth + pagedGrid.spacing)

        Behavior on x {
            NumberAnimation { duration: 100 }
        }
    }

    SwipeArea {
        id: swipeArea
        anchors.fill: parent
        z: 1

        onClicked: {
            // Track down which item has been pressed on current page.
            var x = mouse.x - extraMargin;
            var y = mouse.y;
            if (!pageCount || x < 0 || x >= grid.pageWidth)
                return;

            var row = Math.floor(y / (itemHeight + spacing)), column = Math.floor(x / (itemWidth + spacing));
            var topLeftX = (itemWidth + spacing) * column, topLeftY = (itemHeight + spacing) * row;
            var bottomRightX = topLeftX + itemWidth, bottomRightY = topLeftY + itemHeight;
            if (x >= topLeftX && x <= bottomRightX && y >= topLeftY && y <= bottomRightY) {
                var itemIndex = currentPage * grid.itemsPerPage + row * columnsPerPage + column
                var item = grid.itemAt(itemIndex)
                if (item != null) {
                    // Emit a signal pointing the item clicked and the internal position of the click.
                    pagedGrid.itemClicked(itemIndex, x - topLeftX, y - topLeftY);
                }
            }
        }

        onSwipeLeft: {
            if (currentPage < pageCount - 1)
                ++currentPage;
        }

        onSwipeRight: {
            if (currentPage > 0)
                --currentPage;
        }
    }
}
