import QtQuick 2.0
import QtWebKit 3.0
// What to do on Qt5 !?
import "UiConstants.js" as UiConstants
import "tabmanager.js" as TabManager

Item {
    id: navigationPanel
    property bool hasOpennedTabs: false
    signal webViewMaximinized()
    signal webViewMinimized()

    PinchArea {
        id: pinchArea
        visible: false
        anchors.bottom: tabBar.top
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        z: 99

        onPinchFinished: {
            if (pinch.scale > 1.0 && TabManager.overviewGridSize > 1)
                TabManager.overviewGridSize--;
            else if (pinch.scale < 1.0 && TabManager.overviewGridSize < TabManager.MAX_GRID_SIZE)
                TabManager.overviewGridSize++;
            else
                return;
            TabManager.doTabOverviewLayout();
        }
    }

    Item {
        id: tabBar
        width: UiConstants.PortraitWidth
        height: 58
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right

        Item {
            id: tabBarRow
            anchors.centerIn: parent
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
                    // normal click,
                    setFullScreen(false);
                    webViewMinimized();
                    return;
                }

                if (mouse.x > lastX) // swip right
                    TabManager.goToPreviousTab();
                else // swipe left
                    TabManager.goToNextTab();
            }
        }

        states: State {
            name: "hidden"
            PropertyChanges { target: tabBar; visible: false; }
        }
    }

    function createTab(url)
    {
        var tab = TabManager.createTab(url, navigationPanel, tabBarRow);
        var statusBarIndicator = tab.statusIndicator;
        statusBarIndicator.anchors.verticalCenter = tabBarRow.verticalCenter
        var tabCount = TabManager.tabCount()
        var indicatorSpacing = tabCount * 4
        tabBarRow.width = ((tabCount + 1) * statusBarIndicator.width) + indicatorSpacing
        statusBarIndicator.x = (tabCount * statusBarIndicator.width) + indicatorSpacing
        navigationPanel.hasOpennedTabs = true;
        tab.fullScreenRequested.connect(webViewMaximinized);
        webViewMaximinized();
        return tab;
    }

    onWebViewMaximinized: setFullScreen(true)

    function setFullScreen(value)
    {
        var layout;
        if (value) {
            layout = TabManager.FULLSCREEN_LAYOUT;
            tabBar.state = "";
        } else {
            layout = TabManager.OVERVIEW_LAYOUT;
            tabBar.state = "hidden";
        }
        TabManager.setTabLayout(layout, 1);
    }
}
