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

Item {
    id: root

    TabWidget {
        id: tabWidget
        objectName: "tabWidget"
        anchors.fill: parent

        Component.onCompleted: { addNewTab(); newTabRequested.connect(addNewTab); }

        function addNewTab()
        {
            var component = Qt.createComponent("Tab.qml");
            if (component.status == Component.Ready) {
                var tab = component.createObject(tabWidget);
                var componentView = Qt.createComponent("PageWidget.qml");
                if (componentView.status == Component.Error)
                    console.log(componentView.errorString())
                if (componentView.status == Component.Ready) {
                    var view = componentView.createObject(tab);
                    tab.mainView = view;
                    tab.text = "New Tab";
                    view.tab = tab;
                    tabWidget.addTab(tab);
                    tabWidget.setActiveTab(tab);
                }
            }
        }
    }
}
