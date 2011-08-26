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
import Snowshoe 1.0

Item {
    property alias text: urlInput.text
    property alias textInput: urlInput
    property alias bookmarkButton: bookmarkButton
    property int horizontalMargin: 9

    width: parent.width
    height: urlInput.height + verticalMargins * 2

    signal urlEntered(string url)

    BorderImage {
        id: background
        source: "qrc:///urlbar/component_url_input"
        anchors.verticalCenter: parent.verticalCenter
        width: parent.width
        border { left: 10; top: 10; right: 10; bottom: 10 }
    }

    BorderImage {
        anchors.top: background.top
        // Those margins are there to make the progress bar look "inside" the url input.
        anchors.topMargin: 2
        anchors.bottom: background.bottom
        anchors.bottomMargin: 3
        anchors.left: background.left
        anchors.leftMargin: 2
        source: "qrc:///urlbar/progress_bar_url"
        border { left: 3; top: 3; right: 3; bottom: 3 }
        horizontalTileMode: BorderImage.Repeat
        width: (urlEdit.width) * webView.loadProgress / 100.0
        opacity: webView.loadProgress / 100.0 == 1.0 ? 0.0 : 1.0
    }

    TripleClickMonitor {
        target: urlInput
        onTripleClicked: urlInput.selectAll()
    }

    TextInput {
        id: urlInput
        focus: true
        font.pixelSize: 12
        font.bold: true
        selectByMouse: true
        mouseSelectionMode: TextInput.SelectCharacters
        y: verticalMargins
        x: parent.horizontalMargin
        width: parent.width - bookmarkButton.width

        Keys.onEnterPressed: {
            urlEdit.urlEntered(urlInput.text)
        }

        Keys.onReturnPressed: {
            urlEdit.urlEntered(urlInput.text)
        }
    }

    Image {
        id: bookmarkButton
        x: urlInput.width - 2
        visible:  false
        anchors.top: background.top
        // Those margins are there to make the progress bar look "inside" the url input.
        anchors.topMargin: 2
        smooth: true

        property variant isBookmarked
        onIsBookmarkedChanged: { BrowserObject.isUrlEmpty(webView.url) ? visible = false : visible = true }
        source: { isBookmarked ? "qrc:///urlbar/fav_icon_on" :"qrc:///urlbar/fav_icon_off" }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                if (BrowserObject.isUrlEmpty(webView.url))
                    return;
                if (parent.isBookmarked) {
                    parent.isBookmarked = false;
                    BookmarkModel.remove(webView.url)
                } else {
                    parent.isBookmarked = true;
                    BookmarkModel.insert(webView.title, webView.url);
                }
            }
        }
    }
}
