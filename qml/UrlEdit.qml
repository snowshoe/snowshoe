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

import QtQuick 1.1

Item {
    property alias text : urlInput.text
    property int verticalMargin : 5
    property int horizontalMargin : 9

    width: parent.width
    height : urlInput.height + verticalMargin * 2

    signal urlEntered(string url)

    BorderImage {
        source : "qrc:///images/tab_url_input.png"
        anchors.verticalCenter: parent.verticalCenter
        width: parent.width
        border { left: 10; top: 10; right: 10; bottom: 10 }
    }

    TextInput {
        id : urlInput
        focus : true
        font.pointSize: 10
        font.bold: true
        y : parent.verticalMargin
        x : parent.horizontalMargin

        Keys.onEnterPressed: {
            urlEdit.urlEntered(urlInput.text)
        }

        Keys.onReturnPressed: {
            urlEdit.urlEntered(urlInput.text)
        }
    }
    MouseArea {
        anchors.fill: urlEdit
        onDoubleClicked: { urlInput.selectAll(); urlInput.focus = true }
        onClicked: urlInput.focus = true
    }
}
