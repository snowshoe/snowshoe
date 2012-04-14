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

Rectangle {
    id: overlay
    color: "black"
    opacity: 0

    signal showThumbnails()
    signal closeTab()
    signal dismissOverlay()
    signal goToPreviousTab()
    signal goToNextTab()

    Text {
        anchors.centerIn: parent
        color: "white"
        font.bold: true
        font.pixelSize: 20
        text: "Swipe Left/Right to change tabs\nSwipe Down to close tab\nSwipe Up to show thumbnails\nClick to dismiss overlay"
        horizontalAlignment: Text.AlignHCenter
    }

    SwipeArea {
        anchors.fill: parent

        onSwipeUp: overlay.showThumbnails()
        onSwipeDown: overlay.closeTab()
        onSwipeLeft: overlay.goToNextTab()
        onSwipeRight: overlay.goToPreviousTab()
        onClicked: overlay.dismissOverlay()
    }
}
