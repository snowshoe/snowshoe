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

Item {
    width: listView.width
    height: listView.elementHeight
    BorderImage {
        anchors.fill: parent
        id: overlay
        source: "qrc:///combobox/item_over_bg"
        border { left: 2; top: 2; right: 2; bottom: 2 }
        visible: false
    }

    Text {
        id: text
        font.pixelSize: 11
        text: name
        elide: Text.ElideRight
        anchors.verticalCenter: parent.verticalCenter
        onWidthChanged: {
            if (width > listView.width)
                listView.width = width
        }

    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        onEntered: { overlay.visible = true; }
        onExited: overlay.visible = false
        onClicked: { WebView.load(url); View.hide(); }
    }
}
