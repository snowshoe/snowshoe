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

    width: parent.width
    height: background.height

    signal urlEntered(string url)

    BorderImage {
        id: background
        source: "qrc:///urlbar/component_url_input"
        width: parent.width
        border { left: 10; top: 10; right: 10; bottom: 10 }
    }

    Item {
        anchors {
            fill: background
            // Those margins are here to make the progress bar look "inside" the url input.
            topMargin: 2
            bottomMargin: 3
            leftMargin: 2
            rightMargin: 2
        }

        BorderImage {
            source: "qrc:///urlbar/progress_bar_url"
            border { left: 3; top: 3; right: 3; bottom: 3 }
            horizontalTileMode: BorderImage.Repeat
            width: parent.width * pageWidget.webView.loadProgress / 100.0
            opacity: pageWidget.webView.loadProgress / 100.0 == 1.0 ? 0.0 : 1.0
        }
    }

    TextInput {
        id: urlInput

        anchors {
            verticalCenter: background.verticalCenter
            left: background.left
            right: bookmarkButton.left
            leftMargin: 9
            rightMargin: 2
        }
        focus: true
        clip: true
        font.pixelSize: 12
        selectByMouse: true
        mouseSelectionMode: TextInput.SelectCharacters

        Keys.onEnterPressed: urlEdit.urlEntered(urlInput.text)
        Keys.onReturnPressed: urlEdit.urlEntered(urlInput.text)
    }

    Image {
        id: bookmarkButton

        property bool isBookmarked: false

        anchors {
            top: background.top
            right: background.right
            topMargin: 2
            rightMargin: 5
        }
        visible: false
        source: isBookmarked ? "qrc:///urlbar/fav_icon_on" : "qrc:///urlbar/fav_icon_off"

        MouseArea {
            anchors.fill: parent
            onClicked: {
                if (BrowserObject.isUrlEmpty(pageWidget.webView.url))
                    return;
                if (parent.isBookmarked) {
                    parent.isBookmarked = false;
                    BookmarkModel.remove(pageWidget.webView.url)
                } else {
                    parent.isBookmarked = true;
                    BookmarkModel.insert(pageWidget.webView.title, pageWidget.webView.url);
                }
            }
        }

        onIsBookmarkedChanged: {
            visible = !BrowserObject.isUrlEmpty(pageWidget.webView.url)
        }
    }
}
