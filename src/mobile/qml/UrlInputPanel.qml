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
    id: urlArea

    property alias text: urlBar.text

    signal urlRequested(string url)
    signal cancelRequested()

    function focusUrlBar() {
        urlBar.input.focus = true;
    }

    function unfocusUrlBar() {
        urlBar.input.focus = false;
    }

    Item {
        id: urlBarBackground
        height: 100
        anchors {
            bottom: urlArea.bottom
            left: urlArea.left
            right: urlArea.right
        }

        UrlBar {
            id: urlBar
            anchors {
                top: parent.top
                bottom: parent.bottom
                left: parent.left
                right: cancelButton.left
                topMargin: 21
                bottomMargin: 22
                leftMargin: UiConstants.DefaultMargin
                rightMargin: UiConstants.NavBarShortMargin
            }
            verticalAlignment: TextInput.AlignVCenter
            input.focus: false
            input.onTextChanged: HistoryModel.filterString = input.text

            function isSearchString(text) {
                return text.indexOf('.') == -1;
            }

            onAccepted: {
                var urlToRequest;
                if (isSearchString(urlBar.text))
                    urlToRequest = "http://www.google.com/search?q=" + urlBar.text.split(" ").join("+");
                else
                    urlToRequest = UrlTools.fromUserInput(urlBar.text);
                urlArea.urlRequested(urlToRequest);
            }

            Button {
                pressedImage: ":/mobile/url/btn_erase_pressed"
                unpressedImage: ":/mobile/url/btn_erase_unpressed"
                visible: urlBar.text !== ""
                anchors.right: parent.right
                onClicked: urlBar.text = ""
            }
        }

        Button {
            id: cancelButton
            anchors {
                right: parent.right
                topMargin: 21
                bottomMargin: 22
                rightMargin: UiConstants.DefaultMargin
            }
            pressedImage: ":/mobile/url/btn_cancel_pressed"
            unpressedImage: ":/mobile/url/btn_cancel_unpressed"
            onClicked: urlArea.cancelRequested()
        }
    }

    Rectangle {
        color: "white"
        anchors {
            top: parent.top
            bottom: urlBarBackground.top
            left: parent.left
            right: parent.right
            leftMargin: 1
            rightMargin: 1
            // Makes the radius effect only apply to bottom.
            topMargin: -radius
        }
        radius: 16

        UrlSuggestions {
            id: urlSuggestions
            width: rootPage.width
            clip: true
            anchors {
                fill: parent
                leftMargin: parent.radius
                rightMargin: parent.radius
                topMargin: parent.radius
            }
            onSuggestionSelected: urlArea.urlRequested(UrlTools.fromUserInput(suggestedUrl))
        }
    }
}
