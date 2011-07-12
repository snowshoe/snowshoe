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
    property alias text: urlEdit.text
    property int verticalMargins: 5

    width: parent.width
    height: urlEdit.height + verticalMargins

    Rectangle {
        anchors.fill: parent
        color: "#c9cacb"
    }

    Item {
        id : buttons
        width: backButton.width + forwardButton.width + refreshButton.width
        height: parent.height
        Image {
            id: backButton
            source: "qrc:///images/component_btn_nav_back.png"
        }

        Image {
            id: divisor1
            anchors.left: backButton.right
            source: "qrc:///images/component_divisor.png"
        }

        Image {
            id: forwardButton
            anchors.left: divisor1.right
            source: "qrc:///images/component_btn_nav_next.png"
        }

        Image {
            id: divisor2
            anchors.left: forwardButton.right
            source: "qrc:///images/component_divisor.png"
        }

        Image {
            id: refreshButton
            anchors.left: divisor2.right
            source: "qrc:///images/component_btn_nav_refresh.png"
        }
    }
    Item {
        width: parent.width - buttons.width
        anchors.left: buttons.right
        y: verticalMargins / 2
        UrlEdit {
            id: urlEdit
            objectName: "urlEdit"
        }
    }
}
