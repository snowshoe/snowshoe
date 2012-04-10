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
    property int count: 0
    property QtObject currentElement;
    property var _items: new Array();

    function get(index)
    {
        return _items[index];
    }

    function remove(elem)
    {
        var index = _items.indexOf(elem);
        if (index === -1)
            return;

        _items.splice(index, 1);
        elem.destroy();
        count--;

        if (!count) {
            currentElement = null;
        } else {
            if (index === count)
                index--;
            currentElement = _items[index];
        }
    }

    function add(item)
    {
        _items.push(item);
        count++;
        currentElement = item;
    }

    function nextItem()
    {
        var index = _items.indexOf(currentElement);
        if (!count || index === count - 1)
            return;
        currentElement = _items[index + 1];
    }

    function previousItem()
    {
        var index = _items.indexOf(currentElement);
        if (!count || !index)
            return;
        currentElement = _items[index - 1];
    }
}
