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

    property string url
    property alias title: suggestedTitle.text

    signal suggestionSelected(string url)

    Image {
        id: suggestionRect
        source: ":/mobile/url/bg_browsing"
        anchors { left: parent.left; right: parent.right; bottom: parent.bottom }
    }

    Image {
        id: icon
        source: ":/mobile/scrollbar/btn_url_suggestion"
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.leftMargin: UiConstants.DefaultMargin
    }

    Text {
        id: suggestedTitle
        text: ""
        color: UiConstants.PrimaryColor
        font.pixelSize: UiConstants.DefaultFontSize
        font.family: UiConstants.DefaultFontFamily
        anchors {
            left: icon.right
            right: parent.right
            top: parent.top
            leftMargin: UiConstants.DefaultMargin
            rightMargin: UiConstants.DefaultMargin
            topMargin: 11
        }
    }

    Text {
        id: suggestedUrl
        text: suggestedItem.url
        color: UiConstants.SecondaryColor
        font.pixelSize: UiConstants.SecondaryFontSize
        font.family: UiConstants.DefaultFontFamily
        font.weight: Font.Light
        anchors {
            left: icon.right
            right: parent.right
            bottom: parent.bottom
            leftMargin: UiConstants.DefaultMargin
            rightMargin: UiConstants.DefaultMargin
            bottomMargin: 19
        }
    }

    Image {
        id: fadingLayer
        source: ":/mobile/scrollbar/suggestions_overlayer"
        anchors {
            right: parent.right
            top: parent.top
            bottom: parent.bottom
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        onClicked: suggestedItem.suggestionSelected(suggestedItem.url)
    }
}
