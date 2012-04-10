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
import "UiConstants.js" as UiConstants

Item {
    id: suggestedItem
    height: 80

    signal searchSelected()

    Image {
        id: suggestionRect
        source: ":/mobile/url/bg_browsing"
        anchors { left: parent.left; right: parent.right; bottom: parent.bottom }
    }

    Image {
        id: searchIcon
        source: ":/mobile/scrollbar/btn_google_search"
        anchors {
            left: parent.left
            leftMargin: UiConstants.DefaultMargin
            topMargin: 11
            top: parent.top
        }
    }

    Text {
        id: titleUrl
        text: "Search on Google"
        color: UiConstants.PrimaryColor
        font.pixelSize: UiConstants.DefaultFontSize
        font.family: UiConstants.DefaultFontFamily
        font.bold: true
        baselineOffset: 2
        anchors.verticalCenter: suggestedItem.verticalCenter
        anchors.left: searchIcon.right
        anchors.leftMargin: 16
        anchors.rightMargin: UiConstants.DefaultMargin
        anchors.right: parent.right
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        onClicked: suggestedItem.searchSelected()
    }
}
