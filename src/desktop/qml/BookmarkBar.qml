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

Item {
    id: bookmarkBar

    Image {
        anchors.fill: parent
        fillMode: Image.TileHorizontally
        source: "qrc:///bookmark/header_bg"
    }

    ListView {
        id: listView
        anchors {
            top: parent.top
            bottom: parent.bottom
            left: parent.left
            right: separator.left
            leftMargin: 8
        }
        interactive: false
        orientation: ListView.Horizontal
        property int maximumBookmarkWidth: 150

        RowsRangeFilter {
            id: filteredModel
            sourceModel: BookmarkModel
            endRow: Math.floor(listView.width / (listView.maximumBookmarkWidth + listView.spacing)) - 1
        }

        model: filteredModel
        spacing: 8
        delegate: BookmarkBarDelegate {}
    }

    Image {
        id: separator
        anchors {
            top: parent.top
            right: dropDownMenuButton.left
            rightMargin: 10
        }
        source: "qrc:///bookmark/bookmark_header_divisor"
        visible: dropDownMenuButton.visible
    }

    Image {
        id: dropDownMenuButton
        anchors {
            right: parent.right
            rightMargin: 10
            top: parent.top
            topMargin: 8
        }
        source: dropDownMenuMouseArea.containsMouse ? "qrc:///bookmarks/btn_dropdown_menu_over" : "qrc:///bookmarks/btn_dropdown_menu_static"
        visible: Boolean(filteredModel.endRow != -1 && filteredModel.endRow < BookmarkModel.count - 1)

        MouseArea {
            id: dropDownMenuMouseArea
            anchors.fill: parent
            hoverEnabled: true
            onClicked: {
                var point = mapToItem(tabWidget, x + width, height);
                var globalPos = BrowserWindow.mapToGlobal(point.x - 200 + width, point.y);
                var menu = dropDownMenuComponent.createObject();
                menu.x = globalPos.x;
                menu.y = globalPos.y;
                menu.show();
            }
        }
    }

    Component {
        id: dropDownMenuComponent

        DropDownMenuBookmark {
            model: BookmarkModel
            startRow: filteredModel.endRow + 1

            // FIXME: We should be able to use Screen.height from QtQuick.Window to
            // calculate this but it isn't working yet.
            maxHeight: 600

            onClicked: {
                root.loadUrl(url)
                hide();
            }
        }
    }
}
