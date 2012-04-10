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

ListView {
    id: suggestionsList
    signal searchSelected()
    signal suggestionSelected(string suggestedUrl)
    clip: true
    delegate: SuggestionsDelegate {}

    model: ListModel {
        // FIXME: implement this model in C++ to provide valid and related data (i.e using history)
        ListElement { isSearch: true } // We will always provide the first item as a search item.
        ListElement { itemTitle: "Facebook"; itemUrl: "http://facebook.com" }
        ListElement { itemTitle: "Snowshoe on GitHub"; itemUrl: "https://github.com/snowshoe/snowshoe/commits/master" }
        ListElement { itemTitle: "KDE"; itemUrl: "http://kde.org" }
        ListElement { itemTitle: "WebKit"; itemUrl: "http://webkit.org" }
        ListElement { itemTitle: "Wikipedia"; itemUrl: "http://en.wikipedia.org/wiki/List_of_Pok%C3%A9mon" }
        ListElement { itemTitle: "Globo"; itemUrl: "http://globo.com" }
        ListElement { itemTitle: "KDE"; itemUrl: "http://kde.org" }
        ListElement { itemTitle: "WebKit"; itemUrl: "http://webkit.org" }
    }

    Scrollbar {
        list: suggestionsList
        width: 6
        height: parent.height
        anchors { right: parent.right; top: parent.top; rightMargin: 6; bottom: parent.bottom }
        opacity: list.moving ? 1 : 0
    }
}
