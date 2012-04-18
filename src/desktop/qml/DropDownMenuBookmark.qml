/****************************************************************************
 *   Copyright (C) 2011  Instituto Nokia de Tecnologia (INdT)               *
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

PopupWindow {
    id: dropDownBookmarkMenu
    property alias model: filteredModel.sourceModel
    property alias startRow: filteredModel.startRow
    property int maxHeight

    signal clicked(string url)

    property int _margin: 8
    width: listView.width + bg.border.right + bg.border.left
    height: listView.height + bg.border.top + bg.border.bottom + (_margin * 2)

    BorderImage {
        id: bg
        anchors.fill: parent
        source: "qrc:///combobox/base_bg"
        border { left: 12; top: 6; right: 12; bottom: 16 }
    }

    RowsRangeFilter {
        id: filteredModel
    }

    ListView {
        id: listView
        property int elementHeight: 24

        x: bg.x + bg.border.left
        y: bg.y + bg.border.top + _margin
        width: 150
        clip: true
        orientation: ListView.Vertical
        model: filteredModel
        spacing: 2

        interactive: Boolean(height == dropDownBookmarkMenu.maxHeight)
        height: {
            var listHeight = filteredModel.rowCount * (elementHeight + spacing) - spacing;
            return Math.min(listHeight, dropDownBookmarkMenu.maxHeight);
        }

        delegate: DropDownMenuBookmarkDelegate {
            onClicked: dropDownBookmarkMenu.clicked(model.url)
        }
    }
}

