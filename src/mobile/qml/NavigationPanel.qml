import QtQuick 2.0
import QtWebKit 3.0
// What to do on Qt5 !?
import "UiConstants.js" as UiConstants
import "tabmanager.js" as TabManager

Item {
    id: navigationPanel
    property bool hasOpennedTabs: false
    signal webViewMaximized()
    signal webViewMinimized()
    property alias urlInputFocus: navigationBar.urlInputFocus
    property alias url: navigationBar.url
    property QtObject visibleTab: null

    Connections {
        target: visibleTab
        onLoadingChanged: {
            if (visibleTab.loading) {
                navigationBar.state = "visible";
                navigationBarHidingTimer.stop();
            } else
                navigationBarHidingTimer.restart();
        }
    }

    NavigationBar {
        id: navigationBar
        state: "hidden"
        currentWebView: navigationPanel.visibleTab

        states: [
            State {
                name: "hidden"
                AnchorChanges { target: navigationBar; anchors.top: undefined; anchors.bottom: parent.top }
                StateChangeScript { script: TabManager.doTabResetY(); }
            },
            State {
                name: "visible"
                AnchorChanges { target: navigationBar; anchors.top: parent.top; anchors.bottom: undefined }
            }
        ]

        transitions: [
            Transition {
                to: "visible"
                reversible: true
                AnchorAnimation { duration: 200 }
            }
        ]

        Timer {
            id: navigationBarHidingTimer
            interval: 2000
            onTriggered: navigationBar.state = "hidden"
        }
    }

    Item {
        id: tabBar
        width: UiConstants.PortraitWidth
        height: UiConstants.TabBarHeight
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        z: 1

        Image {
            source: ":/mobile/tabs/bg_image"
            anchors.fill: parent
        }

        Row {
            id: tabBarRow
            anchors.centerIn: parent
            spacing: 10
        }
        MouseArea {
            property int lastX
            property int lastY
            anchors.fill: parent

            onPressed: {
                lastX = mouse.x
                lastY = mouse.y
            }

            onReleased: {
                if (Math.abs(mouse.y - lastY) > height * 3
                    || Math.abs(mouse.x - lastX) < UiConstants.DefaultSwipeLenght) {
                    navigationPanel.webViewMinimized();
                    return;
                }

                if (mouse.x > lastX) // swipe right
                    TabManager.goToPreviousTab();
                else // swipe left
                    TabManager.goToNextTab();
                visibleTab = TabManager.getCurrentTab()

                navigationPanel.webViewMaximized()
            }
        }

        states: State {
            name: "hidden"
            PropertyChanges { target: tabBar; visible: false; }
        }
    }

    function openUrl(url, shouldOpenNewTab)
    {
        var tab = shouldOpenNewTab ? TabManager.createTab(url, navigationPanel, tabBarRow) : TabManager.getCurrentTab()
        // FIXME: we cannot set the same url to a webview while it is loading.
        // BUG: https://bugs.webkit.org/show_bug.cgi?id=82506
        if (shouldOpenNewTab) {
            var statusBarIndicator = tab.statusIndicator;
            var tabCount = TabManager.tabCount();
            navigationPanel.hasOpennedTabs = true;
            tab.tabSelected.connect(selectTab);
            tab.closeTabRequested.connect(closeCurrentTab);
            tab.overviewChanged.connect(changeOverview);
            visibleTab = tab;
        } else {
            tab.url = url;
        }
        navigationPanel.webViewMaximized();
        return tab;
    }

    function setFullScreen(value)
    {
        if (value) {
            TabManager.currentTabLayout = TabManager.FULLSCREEN_LAYOUT;
            tabBar.state = "";
            if (navigationBar.state == "hidden")
                navigationBar.state = "visible";
            var tab = TabManager.getCurrentTab();
            if (tab.loading)
                navigationBarHidingTimer.stop();
            else
                navigationBarHidingTimer.restart();
        } else {
            TabManager.currentTabLayout = TabManager.OVERVIEW_LAYOUT;
            tabBar.state = "hidden";
            navigationBar.state = "hidden";
        }
        TabManager.setTabLayout(TabManager.currentTabLayout, 1);
    }

    function closeCurrentTab()
    {
        TabManager.removeTab(TabManager.currentTab)
        if (TabManager.tabCount() === 0)
            hasOpennedTabs = false;
    }

    function changeOverview(scale)
    {
        if (scale > 1.0)
            if (TabManager.overviewGridSize > 1) {
                TabManager.overviewGridSize--;
            } else {
                webViewMaximized();
                return;
            }
        else if (scale < 1.0 && TabManager.overviewGridSize < TabManager.MAX_GRID_SIZE)
            TabManager.overviewGridSize++;
        else
            return;

        TabManager.doTabOverviewLayout();
    }

    function selectTab(tabNumber)
    {
        webViewMaximized();
        TabManager.setCurrentTab(tabNumber);
        navigationPanel.visibleTab = TabManager.getCurrentTab();
    }
}
