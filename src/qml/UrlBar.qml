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
import QtWebKit.experimental 5.0

Item {
    id: root

    property alias text: urlEdit.text
    property alias textInput: urlEdit.textInput
    property alias bookmarkButton: urlEdit.bookmarkButton
    property int verticalMargins: 7

    signal urlEntered(string url)

    Component.onCompleted: { urlEdit.view = desktopView }

    width: parent.width
    height: urlEdit.height + verticalMargins

    Image {
        anchors.fill: parent
        fillMode: Image.TileHorizontally
        source: "qrc:///urlbar/url_bg_base_fill"
    }

    Item {
        id : buttons
        width: backButton.width + forwardButton.width + refreshButton.width
        height: parent.height
        Image {
            id: backButton
            source: "qrc:///urlbar/button_nav_back"

            MouseArea {
                anchors.fill: parent
                onClicked: { desktopView.navigation.back(); }
            }
        }

        Image {
            id: divisor1
            anchors.left: backButton.right
            source: "qrc:///urlbar/component_divisor"
        }

        Image {
            id: forwardButton
            anchors.left: divisor1.right
            source: "qrc:///urlbar/button_nav_next"

            MouseArea {
                anchors.fill: parent
                onClicked: { desktopView.navigation.forward(); }
            }
        }

        Image {
            id: divisor2
            anchors.left: forwardButton.right
            source: "qrc:///urlbar/component_divisor"
        }

        Image {
            id: refreshButton
            anchors.left: divisor2.right
            source: "qrc:///urlbar/button_nav_refresh"

            MouseArea {
                anchors.fill: parent
                onClicked: { desktopView.navigation.reload(); }
            }
        }
    }
    Item {
        width: parent.width - buttons.width
        anchors.left: buttons.right
        y: verticalMargins / 2

        UrlEdit {
            id: urlEdit
            property variant view: desktopView
            objectName: "urlEdit"
            onUrlEntered: root.urlEntered(url)
        }
    }
}
