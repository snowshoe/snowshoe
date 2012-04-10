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

Row {
    id: panelToggle

    property bool navigationEnabled: true

    signal topSitesSelected()
    signal tabsSelected()

    function resetToTabs() {
        state = "tabs";
    }

    function selectFavorites() {
        if (panelToggle.state === "topsites")
            return;
        panelToggle.state = "topsites";
        topSitesSelected();
    }

    onNavigationEnabledChanged: {
        if (!navigationEnabled)
            selectFavorites();
    }

    state: "topsites"


    Image {
        id: topsites
        source: ":/mobile/app/topsites" + (active ? "_pressed" : "_unpressed")
        property bool active;

        MouseArea {
            anchors.fill: parent
            onClicked: panelToggle.selectFavorites()
        }
    }
    Image {
        id: tabs
        source: ":/mobile/app/tabs" + (active ? "_pressed" : "_unpressed")
        property bool active;

        MouseArea {
            anchors.fill: parent
            onClicked: {
                if (!navigationEnabled)
                    return;
                panelToggle.state = "tabs";
                tabsSelected();
            }
        }
    }

    states: [
        State {
            name: "topsites"
            PropertyChanges { target: topsites; active: true }
            PropertyChanges { target: tabs; active: false }
        },
        State {
            name: "tabs"
            PropertyChanges { target: topsites; active: false }
            PropertyChanges { target: tabs; active: true }
        }
    ]

}

