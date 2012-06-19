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
    id: root
    property var selectorModel: model
    property var contentArea
    property int maxHeight
    property int margins: 8

    PopupWindow {
        id : popup

        width: listView.width + bg.border.right + bg.border.left
        height: listView.height + bg.border.top + bg.border.bottom + (root.margins * 2)

        Component.onCompleted: {
            var globalPos = BrowserWindow.mapToGlobal(selectorModel.elementRect.x - bg.border.left, contentArea.y + selectorModel.elementRect.y + selectorModel.elementRect.height);
            globalPos = BrowserWindow.ensureInsideScreen(globalPos.x, globalPos.y, popup.width, popup.height);
            popup.x = globalPos.x;
            popup.y = globalPos.y;
            popup.show();
        }

        onVisibleChanged : { if (!visible) selectorModel.reject(); }

        BorderImage {
            id: bg
            anchors.fill: parent
            source: "qrc:///combobox/base_bg"
            border { left: 12; top: 6; right: 12; bottom: 16 }
        }

        ListView {
            id: listView
            property int elementHeight: 24

            x: bg.x + bg.border.left
            y: bg.y + bg.border.top + root.margins
            width: selectorModel.elementRect.width
            clip: true
            orientation: ListView.Vertical
            model: selectorModel.items
            spacing: 2

            interactive: Boolean(height == root.maxHeight)
            height: Math.min(contentItem.height, root.maxHeight);

            delegate: ItemSelectorDelegate {
                onClicked: selectorModel.accept(index)
            }

            section.property: "group"
            section.delegate: Rectangle {
                width: parent.width
                height: listView.elementHeight
                color: "silver"
                Text {
                    anchors.centerIn: parent
                    text: section
                    font.pixelSize: 11
                    elide: Text.ElideRight
                    font.bold: true
                }
            }
        }

        ScrollIndicator {
            flickableItem : listView
        }
    }
}
