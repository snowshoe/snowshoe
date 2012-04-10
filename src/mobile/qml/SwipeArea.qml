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
    id: swipeArea

    property int swipeLength: 50

    signal swipeRight()
    signal swipeLeft()
    signal swipeUp()
    signal swipeDown()
    signal clicked()

    MouseArea {
        property int lastX
        property int lastY

        anchors.fill: parent

        onPressed: {
            lastX = mouse.x;
            lastY = mouse.y;
        }

        onReleased: {
            var horizontalDelta = mouse.x - lastX;
            var verticalDelta = mouse.y - lastY;
            var isHorizontalSwipe = Math.abs(horizontalDelta) >= swipeArea.swipeLength;
            var isVerticalSwipe = Math.abs(verticalDelta) >= swipeArea.swipeLength;

            if (!isHorizontalSwipe && !isVerticalSwipe) {
                swipeArea.clicked();
                return;
            }

            if (isHorizontalSwipe) {
                if (horizontalDelta > 0)
                    swipeArea.swipeRight();
                else
                    swipeArea.swipeLeft();
            } else {
                if (verticalDelta > 0)
                    swipeArea.swipeDown();
                else
                    swipeArea.swipeUp();
            }

        }
    }
}
