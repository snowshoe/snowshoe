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
    id: root
    property string url: ''
    property alias urlFadeImage: urlFade.source
    property bool shouldFadeUrl: false
    Text {
        id: displayUrl
        text: root.url.replace(/(https?|file):\/\/\/?(www\.)?/, "").replace(/\/.*/, "");
        color: "#515050"
        font.pixelSize: 20
        font.family: UiConstants.DefaultFontFamily
        font.weight: Font.Light
        horizontalAlignment: shouldFadeUrl ? Text.AlignLeft : Text.AlignHCenter
        verticalAlignment: Text.AlignBottom
        anchors {
            fill: parent
            bottomMargin: 5
            leftMargin: 14
            rightMargin: 14
        }
        onWidthChanged: shouldFadeUrl = paintedWidth > width
        onPaintedWidthChanged: shouldFadeUrl = paintedWidth > width
    }
    Image {
        id: urlFade
        visible: shouldFadeUrl
        anchors {
            bottom: parent.bottom
            right: parent.right
        }
    }
}
