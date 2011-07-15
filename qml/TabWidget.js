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

var tabArray = new Array;

function setActiveTab(newActiveTab) {
    if (currentActiveTab === newActiveTab)
        return;
    newActiveTab.active = true;
    newActiveTab.mainView.visible = true;

    // Update the old active tab.
    if (currentActiveTab) {
        currentActiveTab.mainView.visible = false;
        currentActiveTab.active = false;
        var currentActiveTabIndex = tabArray.indexOf(currentActiveTab);
        if (!currentActiveTab.isLastTab) {
            tabArray[currentActiveTabIndex + 1].isLeftActive = false;
            tabArray[currentActiveTabIndex + 1].updateAssets();
        }
        currentActiveTab.updateAssets();
    }

    var newActiveTabIndex = tabArray.indexOf(newActiveTab);
    if (!newActiveTab.isLastTab) {
        tabArray[newActiveTabIndex + 1].isLeftActive = true;
        tabArray[newActiveTabIndex + 1].updateAssets();
    }
    newActiveTab.updateAssets();
    currentActiveTab = newActiveTab;
    updateMainView(currentActiveTab);
}

function addTab(newTab)
{
    if (tabArray.length != 0) {
        newTab.anchors.left = tabArray[tabArray.length-1].right;
        tabArray[tabArray.length - 1].isLastTab = false;
        tabArray[tabArray.length - 1].updateAssets();
        newTab.isFirstTab = false;
    } else {
        newTab.isFirstTab = true;
    }
    newTab.isLastTab = true;
    newTab.updateAssets();
    tabArray.push(newTab);
}

function tabsHeadersWidth()
{
    var size = 0;
    for(var index in tabArray)
    {
        size += tabArray[index].width;
    }
    return size;
}

function shrinkTabs(sizeToShrink)
{
    for (var index in tabArray) {
        tabArray[index].shrink(sizeToShrink / tabArray.length);
    }
}

function closeTab(tab)
{
    if (tabArray.length == 0)
        return;

    if (tabArray.length == 1) {
        tabArray.pop();
        return;
    }

    var tabIndex = tabArray.indexOf(tab);
    if (tabIndex > 0) {
        if (tabIndex == tabArray.length - 1) {
            tabArray[tabIndex - 1].isLastTab = true;
            tabArray[tabIndex - 1].updateAssets();
            if (tab.active) {
                setActiveTab(tabArray[tabIndex - 1]);
            }
        } else {
            tabArray[tabIndex + 1].anchors.left = tabArray[tabIndex - 1].right;
            if (tabArray[tabIndex - 1].active || tab.active)
                tabArray[tabIndex + 1].isLeftActive = true;
            tabArray[tabIndex + 1].updateAssets();
            tabArray[tabIndex - 1].updateAssets();
            if (tab.active) {
                setActiveTab(tabArray[tabIndex + 1]);
            }
        }
    } else {
        tabArray[tabIndex + 1].isFirstTab = true;
        tabArray[tabIndex + 1].anchors.left = undefined;
        tabArray[tabIndex + 1].updateAssets();
        tabArray[tabIndex + 1].x = 0;
        if (tab.active) {
            tabArray[tabIndex + 1].isLeftActive = false;
            setActiveTab(tabArray[tabIndex + 1]);
        }

    }

    tabArray.splice(tabIndex, 1);
}

function updateMainView(tab)
{
    tab.mainView.y = tab.headerHeight + 5
    tab.mainView.x = -tab.x
}
