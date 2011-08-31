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

BorderImage {
    id: background
    width: listView.width + border.right + border.left
    height: listView.height + border.top + border.bottom + margin*2
    source: "qrc:///combobox/base_bg"
    border { left: 12; top: 6; right: 12; bottom: 16 }
    property int margin: 8
    property int topOffset: -4
    property int rightOffset: -width + margin

    ListView {
        id: listView
        x: background.x + background.border.left
        y: background.y + background.border.top + margin
        width: 150
        clip: true;
        property int elementHeight: 24
        height: {
            if (filteredModel.rowCount * elementHeight > View.maxHeight) {
                interactive = true;
                return View.maxHeight;
            } else
                return filteredModel.rowCount * (elementHeight + spacing) - spacing
        }
        orientation: ListView.Vertical
        interactive: false

        BookmarkFilter {
            id: filteredModel
            sourceModel: BookmarkModel
            startRow: StartRow
        }

        model: filteredModel
        spacing: 2
        delegate: DropDownMenuBookmarkDelegate {}
    }
}
