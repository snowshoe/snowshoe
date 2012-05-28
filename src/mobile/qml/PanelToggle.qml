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

Image {
    id: panelToggle

    property bool navigationEnabled: true

    signal topSitesSelected()
    signal tabsSelected()

    function resetToTabs() {
        topsites.visible = false;
    }

    onNavigationEnabledChanged: {
        if (!navigationEnabled)
            topsites.visible = true;
    }

    source: navigationEnabled ? "qrc:///mobile/app/menu_unpressed" : "qrc:///mobile/app/menu_disabled"

    Image {
        id: topsites
        source: "qrc:///mobile/app/mysites_pressed"
        onVisibleChanged: visible ? topSitesSelected() : tabsSelected()
    }
    MouseArea {
        anchors.fill: topsites
        onClicked: topsites.visible = true
    }

    Image {
        id: tabs
        source: "qrc:///mobile/app/tabs_pressed"
        anchors.right:  parent.right
        visible: !topsites.visible

    }
    MouseArea {
        anchors.fill: tabs
        visible: navigationEnabled
        onClicked: topsites.visible = false
    }
}

