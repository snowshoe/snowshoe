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
    signal suggestionSelected(string suggestedUrl)
    clip: true
    delegate: SuggestionItem {
        url: model.url
        title: model.title
        height: 80
        width: suggestionsList.width
        onSuggestionSelected: suggestionsList.suggestionSelected(url)
    }

    model: HistoryModel

    Scrollbar {
        list: suggestionsList
        width: 6
        height: parent.height
        anchors { right: parent.right; top: parent.top; rightMargin: 6; bottom: parent.bottom }
        opacity: list.moving ? 1 : 0
    }
}
