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
    width: text.width + text.anchors.leftMargin + text.anchors.rightMargin
    height: dropDownMenuButton.height
    anchors.top: parent.top
    anchors.topMargin: 8

    BorderImage {
       anchors.fill: parent
       id: background
       source: "qrc:///bookmark/static_bg"
       border { left: 3; top: 3; right: 3; bottom: 3 }
    }

    Text {
       id: text
       anchors {
           left: parent.left
           leftMargin: 8
           rightMargin: 8
           top: parent.top
           topMargin: 9
       }
       text: name + " "
       font.pixelSize: 11
       Component.onCompleted: {
           text.elide = Text.ElideRight;
           width = listView.maximumBookmarkWidth;
       }
    }

    BorderImage {
       anchors.fill: parent
       id: overlay
       source: "qrc:///bookmark/static_mask"
       border { left: 3; top: 2; right: 50; bottom: 2 }
    }

    MouseArea {
       anchors.fill: parent
       hoverEnabled: true
       onEntered: {
           background.source = "qrc:///bookmark/over_bg";
           overlay.source = "qrc:///bookmark/over_mask";
       }
       onExited: {
           background.source = "qrc:///bookmark/static_bg";
           overlay.source = "qrc:///bookmark/static_mask";
       }
       onClicked: { loadUrl(url) }
    }
}
