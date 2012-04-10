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

Item {
    id: delegate
    height: 80
    width: delegate.ListView.view.width

    function bestDelegate(isSearch) {
        if(isSearch)
            return searchDelegate;
        return suggestionDelegate;
    }

    Component {
        id: searchDelegate
        SearchItem {
            onSearchSelected: delegate.ListView.view.searchSelected()
        }
    }

    Component {
        id: suggestionDelegate
        SuggestionItem {
            url: itemUrl
            title: itemTitle
            onSuggestionSelected: delegate.ListView.view.suggestionSelected(url)
        }
    }

    Loader {
        id: itemDisplay
        anchors.fill: parent
        sourceComponent: bestDelegate(isSearch)
    }
}
