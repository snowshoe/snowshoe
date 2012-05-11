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
    id: indicatorRow
    property int itemCount: 0
    property int currentItem: 0
    property int maxItems: 0
    property int loadProgress: 0
    property bool blinkOnZeroProgress: false
    height: 21

    function roundProgress() {
        return (Math.floor(loadProgress / 5)) * 5;
    }

    Row {
        anchors.horizontalCenter: parent.horizontalCenter

        Repeater {
            model: maxItems
            StatusBarIndicator {
                valid: index < itemCount
                active: index === currentItem
                blinkOnZeroProgress: indicatorRow.blinkOnZeroProgress
                loadProgress: active ? roundProgress() : 0
            }
        }
    }
}
