import QtQuick 2.0
import QtWebKit 3.0
// What to do on Qt5 !?
import "UiConstants.js" as UiConstants
import "tabmanager.js" as TabManager

Item {
    id: navigationPanel
    anchors.fill: parent
    property int currentTabIndex: -1
    property int tabCount: 0
    property int webPageHeight: height - tabBar.height

    Item {
        id: tabBar
        width: 480
        height: 36
        x: 0
        y: 818 - 36

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
                    TabManager.setTabLayout(TabManager.OVERVIEW_LAYOUT, 1);
                    navigationPanel.state = "";
                    navigationPanel.parent.state = "navigation";
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
                AnchorChanges { target: tabBar; anchors.top: parent.bottom }
            }

        transitions: Transition {
            PropertyAnimation { properties: "y"; duration: 200; }
        }
    }

    function createTab(url)
    {
        TabManager.createTab(url, navigationPanel, tabBarRow);
        var statusBarIndicator = TabManager.getCurrentTab().statusIndicator;
        statusBarIndicator.anchors.verticalCenter = tabBar.verticalCenter
        var tabCount = TabManager.tabCount()
        var indicatorSpacing = tabCount * 4
        tabBarRow.width = ((tabCount + 1) * statusBarIndicator.width) + indicatorSpacing
        statusBarIndicator.x = (tabCount * statusBarIndicator.width) + indicatorSpacing

        currentTabIndex = TabManager.tabCount() - 1
        tabCount += 1
    }

    states: [
        State {
            name: ""
            PropertyChanges { target: tabBar; state: "hidden" }
            StateChangeScript { script: TabManager.doTabOverviewLayout(); }
        },
        State {
            name: "fullscreen"
            PropertyChanges { target: tabBar; state: "" }
            StateChangeScript { script: TabManager.doTabFullScreenLayout(); }
        }
    ]

    Component.onCompleted: {
        TabManager.WINDOW_WIDTH = navigationPanel.width;
        TabManager.WINDOW_HEIGHT = navigationPanel.height - tabBar.height;
    }
}
