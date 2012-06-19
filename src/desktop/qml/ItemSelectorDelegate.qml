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

Item {
    signal clicked(int index)

    width: ListView.view.width
    height: ListView.view.elementHeight

    BorderImage {
        anchors.fill: parent
        id: overlay
        source: "qrc:///combobox/item_over_bg"
        border { left: 2; top: 2; right: 2; bottom: 2 }
        visible: mouseArea.containsMouse
    }

    Text {
        id: text
        font.pixelSize: 11
        text: model.text
        elide: Text.ElideRight
        anchors {
            verticalCenter: parent.verticalCenter
            left: parent.left
            leftMargin: 8
            rightMargin: 8
            right: parent.right
        }
        onWidthChanged: {
            if (width > parent.ListView.view.width)
                parent.ListView.view.width = width
        }

    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        enabled: model.enabled
        onClicked: parent.clicked(model.index)
    }
}
