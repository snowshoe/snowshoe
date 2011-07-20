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
    }

    currentActiveTab = newActiveTab;
    updateMainView(currentActiveTab);

    // FIXME: Do better it breaks the genericity of the tabwidget
    if (newActiveTab.mainView.desktopView.isUrlEmpty())
        newActiveTab.mainView.urlBar.textInput.forceActiveFocus();
    else
        newActiveTab.mainView.desktopView.forceActiveFocus();

    tabWidget.currentTabChanged();
}

function addTab(newTab)
{
    if (tabArray.length != 0) {
        var previousTab = tabArray[tabArray.length - 1];
        previousTab.isLastTab = false;
        previousTab.content.widthBehavior.complete();
        newTab.previousTab = previousTab;
    }

    newTab.content.width = 150;
    newTab.content.effectiveWidth = 150;
    newTab.isLastTab = true;
    newTab.syncHeader();
    tabArray.push(newTab);
}

function tabsHeadersWidth()
{
    var size = 0;
    for(var index in tabArray)
    {
        size += tabArray[index].content.effectiveWidth;
    }
    return size;
}

function shrinkTabs(tabWidgetSize)
{
    var sizeToShrink = tabWidgetSize / tabArray.length;
    for (var index in tabArray) {
        tabArray[index].content.widthBehavior.complete();
        tabArray[index].content.widthBehavior.enabled = false;
        if (sizeToShrink > 150) {
            tabArray[index].content.width = 150;
            tabArray[index].content.effectiveWidth = 150;
        }
        else {
            tabArray[index].content.width = Math.floor(sizeToShrink);
            tabArray[index].content.effectiveWidth = Math.floor(sizeToShrink);
        }
        tabArray[index].syncHeader();
        tabArray[index].content.widthBehavior.enabled = true;
    }
}

function getRightTab(tab)
{
    var rightTab = undefined;
    var tabIndex = tabArray.indexOf(tab);
    if (tabIndex + 1 < tabArray.length) {
        return tabArray[tabIndex + 1];
    }
    return rightTab;
}

function getLeftTab(tab)
{
    var leftTab = undefined;
    var tabIndex = tabArray.indexOf(tab);
    if (tabIndex - 1 >= 0) {
        return tabArray[tabIndex - 1];
    }
    return leftTab;
}

function closeTab(tab)
{
    if (tabArray.length == 0)
        return;

    if (tabArray.length == 1) {
        tabArray.pop();
        Qt.quit();
        return;
    }

    var rightTab = getRightTab(tab);
    var leftTab = getLeftTab(tab);

    var tabIndex = tabArray.indexOf(tab);
    if (tabIndex > 0) {
        if (tabIndex == tabArray.length - 1) {
            leftTab.isLastTab = true;
            if (tab.active) {
                setActiveTab(leftTab);
            }
        } else {
            rightTab.previousTab = leftTab;
            rightTab.syncHeader();
            if (tab.active) {
                setActiveTab(rightTab);
            }
        }
    } else {
        rightTab.previousTab = undefined;
        rightTab.syncHeader();
        if (tab.active) {
            setActiveTab(rightTab);
        }

    }

    tabArray.splice(tabIndex, 1);
}

function getTabToReplace(tab, tabIndex)
{
    var middleTab = tab.content.x + tab.content.effectiveWidth / 2;
    var tabToReplaceIndex = 0;
    if (tab.tabHeader.x <= middleTab)
        tabToReplaceIndex = tabIndex - Math.floor((middleTab - tab.tabHeader.x) / tab.content.effectiveWidth);
    else {
        var headerRight = tab.tabHeader.x + tab.tabHeader.width;
        tabToReplaceIndex = tabIndex + Math.floor((headerRight - middleTab) / tab.content.effectiveWidth);
    }
    return tabToReplaceIndex;
}

function updateTabsLayout(tab)
{
    var tabIndex = tabArray.indexOf(tab);
    var tabToReplaceIndex = getTabToReplace(tab, tabIndex);

    if (tabToReplaceIndex < 0 || tabToReplaceIndex >= tabArray.length || tabIndex == tabToReplaceIndex)
        return;

    var oldTabPreviousTab = tab.previousTab;
    var rightTab = getRightTab(tab);
    var tabToReplace = tabArray[tabToReplaceIndex];
    tab.content.headerFollowContent = false;

    if (tabToReplaceIndex < tabIndex) {
        if (tabToReplaceIndex == tabIndex - 1) {
            var oldTabToReplacePrevious = tabToReplace.previousTab;
            tab.previousTab = undefined;
            tabToReplace.previousTab = tab;
            tab.previousTab = oldTabToReplacePrevious;

            if (rightTab != undefined) {
                rightTab.previousTab = tabToReplace;
            }

        } else {
            tab.previousTab = tabToReplace.previousTab;
            tabToReplace.previousTab = tab;
            if (rightTab != undefined) {
                rightTab.previousTab = oldTabPreviousTab;
            }
        }

    } else {
        if (tabToReplaceIndex == tabIndex + 1) {
            tabToReplace.previousTab = tab.previousTab;
            tab.previousTab = tabToReplace;

            var rightTabOfTabToReplace = getRightTab(tabToReplace);
            if (rightTabOfTabToReplace != undefined) {
                rightTabOfTabToReplace.previousTab = tab;
            }

        } else {
            rightTab.previousTab = tab.previousTab;
            tab.previousTab = tabToReplace;

            var rightTabOfTabToReplace = getRightTab(tabToReplace);
            if (rightTabOfTabToReplace != undefined) {
                rightTabOfTabToReplace.previousTab = tab;
            }
        }
    }

    tabArray[tabArray.length - 1].isLastTab = false;
    tabArray.splice(tabIndex, 1);
    tabArray.splice(tabToReplaceIndex, 0, tab);
    tabArray[tabArray.length - 1].isLastTab = true;

    tab.content.headerFollowContent = true;
    updateSiblingTabsForDragging(tab, true);
}

function updateSiblingTabsForDragging(tab, draggingEnable)
{
    var tabIndex = tabArray.indexOf(tab);
    if (tabIndex - 1 >= 0) {
        tabArray[tabIndex - 1].isRightDragging = draggingEnable;
    }
    if (tabIndex + 1 < tabArray.length) {
        tabArray[tabIndex + 1].isLeftDragging = draggingEnable;
    }
}

function resetTabsToNonDraggingState()
{
    for (var index in tabArray) {
        tabArray[index].isLeftDragging = false;
        tabArray[index].isRightDragging = false;
    }
}

function updateMainView(tab)
{
    tab.mainView.y = tab.headerHeight
}

function jumpToNextTab()
{
    var tabIndex = tabArray.indexOf(currentActiveTab) + 1;
    if (tabIndex >= tabArray.length)
        tabIndex = 0;
    setActiveTab(tabArray[tabIndex]);
}

function jumpToPreviousTab()
{
    var tabIndex = tabArray.indexOf(currentActiveTab) - 1;
    if (tabIndex < 0)
        tabIndex = tabArray.length - 1;
    setActiveTab(tabArray[tabIndex]);
}
