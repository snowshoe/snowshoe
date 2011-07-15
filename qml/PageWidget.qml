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
import Snowshoe 1.0

Item {
    id: root

    property alias urlBar: urlBar
    property alias desktopView: desktopView

    property variant tab;

    UrlBar {
        id: urlBar
        objectName: "urlBar"
    }

    DeclarativeDesktopWebView {
        id: desktopView
        anchors.top: urlBar.bottom
        anchors.topMargin: 5
        anchors.bottom: root.bottom
        anchors.left: root.left
        anchors.right: root.right

        onUrlChanged: { urlBar.text = url.toString() ; forceActiveFocus(); }
        onLoadFailed: { url = "http://www.google.com/search?q=" + urlBar.text }
        onTitleChanged: { tab.text = title }
    }

    function focusUrlBar() {
        urlBar.textInput.forceActiveFocus();
    }
}
