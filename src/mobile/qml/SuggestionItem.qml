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
    property string title
    property bool isGoogleSearch: url.length > UiConstants.GoogleSearchPatternLength
                                  && url.substring(0, UiConstants.GoogleSearchPatternLength) === UiConstants.GoogleSearchPattern
    property string keywords: ""

    signal suggestionSelected(string url)
    onIsGoogleSearchChanged: {
        if (!isGoogleSearch)
            return;

        // Extract keywords from google's search page title. It removes words until it finds "-", starting from last word.
        // It follows the format: <keywords> - <google page title>
        var i;
        for (i = title.length - 1; i >= 0; --i) {
            if (title.charAt(i) === '-')
                break;
        }
        keywords = title.substring(0, --i);
    }

    Image {
        id: suggestionRect
        source: "qrc:///mobile/url/bg_browsing"
        anchors { left: parent.left; right: parent.right; bottom: parent.bottom }
    }

    Image {
        id: icon
        source: isGoogleSearch ? "qrc:///mobile/scrollbar/btn_google_search" : "qrc:///mobile/scrollbar/btn_url_suggestion"
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
    }

    Text {
        id: suggestedTitle
        text: isGoogleSearch ? keywords : suggestedItem.title
        color: UiConstants.PrimaryColor
        font.pixelSize: UiConstants.DefaultFontSize
        font.family: UiConstants.DefaultFontFamily
        anchors {
            left: icon.right
            right: parent.right
            top: parent.top
            leftMargin: UiConstants.DefaultMargin
            rightMargin: UiConstants.DefaultMargin
            topMargin: 13
        }
    }

    Text {
        id: suggestedUrl
        text: isGoogleSearch ? "Google Search" : suggestedItem.url
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
            bottomMargin: 17
        }
    }

    Image {
        id: fadingLayer
        source: "qrc:///mobile/scrollbar/suggestions_overlayer"
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
