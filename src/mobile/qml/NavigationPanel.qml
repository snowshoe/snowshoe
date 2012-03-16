import QtQuick 2.0
import QtWebKit 3.0
// What to do on Qt5 !?
import "UiConstants.js" as UiConstants
import "tabmanager.js" as TabManager

Item {
    id: navigationPanel
    width: parent.width
    height: parent.height
    property int currentTabIndex: -1
    property int tabCount: 0
    property variant rootPage
    property int webPageHeight: height - tabBar.height

    Row {
        id: webViewRow
        x: 0
        y: 0

        Behavior on x {
            NumberAnimation { duration: 200; }
        }
    }

    Component {
        id: webViewPrototype
        Item {
            id: webViewItem
            property alias url: webView.url
            property variant statusIndicator
            width: navigationPanel.width
            height: navigationPanel.height - tabBar.height
            property alias webView: webView
            property bool shouldAnimateIndicator: (navigationPanel.parent.state == "navigationFullScreen" && webView.loading)

            WebView {
                id: webView
                anchors.fill: parent

                onLoadingChanged: {
                    if (loadRequest.status == WebView.LoadFailedStatus) {
                        webViewItem.shouldAnimateIndicator = false
                        webView.loadHtml(UiConstants.HtmlFor404Page)
                    }
                }
            }

            MouseArea {
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.right: parent.right
                height: navigationPanel.webPageHeight
                visible: (navigationBar.state === "visible")
                onClicked: {
                    navigationPanel.parent.state = "navigationFullScreen"
                    navigationBar.state = "hidden"
                    navigationPanel.webPageHeight = navigationPanel.height - tabBar.height
                }
            }

            Image {
                id: closeBtn
                // ok.. this are the coords, but they dont't need to be binded because
                // this coords will NEVER change.
                x: webView.width * 0.85 - width/2
                y: webView.height * 0.15 - height/2
                source: "image://theme/icon-m-framework-close-thumbnail"
                visible: false
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        TabManager.removeTab(currentTabIndex)
                        navigationPanel.tabCount = TabManager.tabCount();
                        if (currentTabIndex === TabManager.tabCount())
                            currentTabIndex--;
                        tabBar.setCurrentTab(currentTabIndex)
                    }
                }
            }

            Image {
                id: addToFavBtn
                // ok.. this are the coords, but they dont't need to be binded because
                // this coords will NEVER change.
                x: webView.width * 0.15 - width/2
                y: webView.height * 0.15 - height/2
                // FIXME: This image is too ugly to be used here!
                source: "image://theme/icon-l-content-favourites"
                width: 48; height: 48 // resize the original Harmattan image while we don't have a good one to put here
                visible: false
                MouseArea {
                    anchors.fill: parent
                    onClicked: console.log("Add to favorites!")
                }
            }

            states: [
                State {
                    name: "minimized"
                    PropertyChanges { target: webView; scale: 0.7; }
                    PropertyChanges { target: closeBtn; visible: true; }
                    PropertyChanges { target: addToFavBtn; visible: true; }
                }
            ]

            transitions: [
                Transition {
                    to: "minimized"
                    SequentialAnimation {
                        PropertyAnimation { properties: "scale"; duration: 300; }
                        PropertyAnimation { target: closeBtn; properties: "visible"; duration: 0; }
                        PropertyAnimation { target: addToFavBtn; properties: "visible"; duration: 0; }
                    }
                },
                Transition {
                    to: ""
                    SequentialAnimation {
                        PropertyAnimation { target: closeBtn; properties: "visible"; duration: 0; }
                        PropertyAnimation { target: addToFavBtn; properties: "visible"; duration: 0; }
                        PropertyAnimation { properties: "scale"; duration: 300; }
                    }
                }
            ]
        }
    }

    Item {
        id: tabBar
        width: 480
        height: 36
        x: 0
        y: 818 - 36

        function setCurrentTab(index) {
            if (index !== -1) {
                // deactivate old status indicator
                var oldStatusElem = TabManager.getStatusBarIndicator(currentTabIndex);
                if (oldStatusElem)
                    oldStatusElem.active = false;

                var statusIndicator = TabManager.getStatusBarIndicator(index);
                statusIndicator.state = state === "minimized" ? "likeAUrlBar" : ""
                statusIndicator.active = true
                TabManager.getWebPage(index).state = state
                webViewRow.x = -index * navigationPanel.width
            }
            currentTabIndex = index
        }

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
                if (mouse.y < lastY - UiConstants.DefaultSwipeLenght) { // swipe up
                    navigationPanel.state = "";
                    navigationPanel.parent.state = "navigation";
                    return
                }

                if (Math.abs(mouse.y - lastY) > height * 3
                    || Math.abs(mouse.x - lastX) < UiConstants.DefaultSwipeLenght) {
                    // normal click,
                    navigationPanel.parent.state = "withNavigationBar"
                    return;
                }

                if (mouse.x > lastX) { // swip right
                    if (currentTabIndex !== 0)
                        tabBar.setCurrentTab(currentTabIndex - 1);
                } else { // swipe left
                    if (currentTabIndex !== TabManager.tabCount() - 1)
                        tabBar.setCurrentTab(currentTabIndex + 1);
                }
            }
        }
        states: [
            State {
                name: "minimized"
                StateChangeScript {
                    script: {
                        TabManager.setAllStatusBarIndicatorStatusBut("hide", currentTabIndex)
                        TabManager.getStatusBarIndicator(currentTabIndex).state = "likeAUrlBar"
                    }
                }
            },
            State {
                name: "hidden"
                AnchorChanges { target: tabBar; anchors.top: parent.bottom }
                StateChangeScript {
                    script: {
                        TabManager.setAllStatusBarIndicatorStatusBut("hide", currentTabIndex)
                    }
                }
            },
            State {
                name: ""
                StateChangeScript {
                    script: {
                        TabManager.setAllStatusBarIndicatorStatusBut("", -1)
                    }
                }
            }
        ]

        transitions: Transition {
            PropertyAnimation { properties: "y"; duration: 200; }
        }
    }

    function createTab(url)
    {
        var webView = webViewPrototype.createObject(webViewRow)
        var statusBarIndicator = Qt.createComponent("StatusBarIndicator.qml").createObject(tabBarRow)
        statusBarIndicator.anchors.verticalCenter = tabBar.verticalCenter
        var indicatorSpacing = tabCount * 4
        tabBarRow.width = ((tabCount + 1) * statusBarIndicator.width) + indicatorSpacing
        statusBarIndicator.x = (tabCount * statusBarIndicator.width) + indicatorSpacing
        TabManager.pushTab(webView, statusBarIndicator)

        statusBarIndicator.webView = webView
        webView.statusIndicator = statusBarIndicator

        // reset previous status bullet
        if (currentTabIndex !== -1) {
            var prevStatusElem = TabManager.getStatusBarIndicator(currentTabIndex)
            prevStatusElem.active = false
            prevStatusElem.state = ""
            TabManager.getWebPage(currentTabIndex).state = ""
        }
        currentTabIndex = TabManager.tabCount() - 1
        webViewRow.x = -currentTabIndex * navigationPanel.width

        webView.url = url
        webView.webView.urlChanged.connect(function() { statusBarIndicator.url = webView.webView.url; })
        statusBarIndicator.webView = webView
        statusBarIndicator.rootPage = navigationPanel.rootPage

        tabCount += 1
    }

    function currentWebView()
    {
        if (currentTabIndex == -1)
            return null

        return TabManager.getWebPage(currentTabIndex)
    }

    states: [
        State {
            name: ""
            PropertyChanges { target: tabBar; state: "minimized" }
            PropertyChanges { target: navigationPanel; webPageHeight: navigationPanel.height - tabBar.height }
            StateChangeScript {
                script: TabManager.getWebPage(currentTabIndex).state = "minimized"
            }
        },
        State {
            name: "navBar"
            PropertyChanges { target: tabBar; state: "hidden" }
            PropertyChanges { target: navigationPanel; webPageHeight: navigationPanel.height - navigationBar.height }
        },
        State {
            name: "fullscreen"
            PropertyChanges { target: tabBar; state: "" }
            PropertyChanges { target: navigationPanel; webPageHeight: navigationPanel.height - tabBar.height }
            StateChangeScript {
                script: {
                    if (currentTabIndex - 1  >= 0)
                        TabManager.getWebPage(currentTabIndex - 1).state = ""
                    TabManager.getWebPage(currentTabIndex).state = ""
                    TabManager.getStatusBarIndicator(currentTabIndex).state = ""
                    if (currentTabIndex + 1 < TabManager.tabCount())
                        TabManager.getWebPage(currentTabIndex + 1).state = ""
                }
            }
        }
    ]
}
