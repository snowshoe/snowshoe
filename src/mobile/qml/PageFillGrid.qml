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

Row {
    id: root

    // Read/write properties.
    property QtObject model: null
    property Component delegate: null
    property int itemWidth: 192
    property int itemHeight: 263
    property int rowsPerPage: 2
    property int columnsPerPage: 2

    // Read only properties.
    property int pageCount: model != null && itemsPerPage ? Math.ceil(model.count / itemsPerPage) : 0
    property int itemsPerPage: rowsPerPage * columnsPerPage
    property int pageWidth: columnsPerPage * itemWidth + (columnsPerPage - 1) * spacing
    property int pageHeight: rowsPerPage * itemHeight + (rowsPerPage - 1) * spacing

    function itemAt(index) {
        var pageForIndex = Math.floor(index / grid.itemsPerPage), offset = index % grid.itemsPerPage;
        var pageItem = pageRepeater.itemAt(pageForIndex);
        if (pageItem == null)
            return null;

        return pageItem.thumbs.itemAt(offset);
    }

    Repeater {
        id: pageRepeater
        model: pageCount

        Grid {
            property alias thumbs: thumbRepeater
            width: pageWidth
            height: pageHeight
            spacing: root.spacing
            columns: root.columnsPerPage

            RowsRangeFilter {
                id: currentPageModel
                sourceModel: root.model
                startRow: index * itemsPerPage
                endRow: startRow + itemsPerPage - 1
            }

            Repeater {
                id: thumbRepeater
                model: currentPageModel
                delegate: pagedGrid.delegate
            }
        }
    }
}
