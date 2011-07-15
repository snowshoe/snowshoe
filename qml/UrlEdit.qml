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
    property alias text: urlInput.text
    property int verticalMargin: 5
    property int horizontalMargin: 9

    width: parent.width
    height: urlInput.height + verticalMargin * 2

    signal urlEntered(string url)

    BorderImage {
        id: background
        source: "qrc:///urlbar/component_url_input"
        anchors.verticalCenter: parent.verticalCenter
        width: parent.width
        border { left: 10; top: 10; right: 10; bottom: 10 }
    }

    BorderImage {
        anchors.top: parent.top
        anchors.topMargin: 3 // To look "inside" the urlEdit
        anchors.left: parent.left
        anchors.leftMargin: 2 // To look "inside" the urlEdit
        source: "qrc:///urlbar/progress_bar_url"
        border { left: 10; top: 10; right: 10; bottom: 10 }
        width: (urlEdit.width) * desktopview.loadProgress / 100.0
        height: urlEdit.height - anchors.topMargin * 2 // To look "inside" the urlEdit
        opacity: desktopview.loadProgress / 100.0 == 1.0 ? 0.0 : 1.0
    }

    TextInput {
        id: urlInput
        focus: true
        font.pointSize: 10
        font.bold: true
        selectByMouse: true
        mouseSelectionMode: TextInput.SelectCharacters
        y: parent.verticalMargin
        x: parent.horizontalMargin
        width: parent.width

        Keys.onEnterPressed: {
            urlEdit.urlEntered(urlInput.text)
        }

        Keys.onReturnPressed: {
            urlEdit.urlEntered(urlInput.text)
        }
    }
}
