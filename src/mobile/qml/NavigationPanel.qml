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
            property string url: ""
            property variant statusIndicator
            width: navigationPanel.width
            height: navigationPanel.height - tabBar.height
            property alias webView: webView
            property bool shouldAnimateIndicator: (navigationPanel.parent.state == "navigationFullScreen" && webView.loading)

            WebView {
                id: webView
                anchors.fill: parent
                url: webViewItem.url

                onLoadingChanged: {
                    if (loadRequest.status == WebView.LoadFailedStatus) {
                        webViewItem.shouldAnimateIndicator = false
                        webViewItem.url = "qrc:/mobile/404.html"
                    }
                }

                MouseArea {
                    id: webViewMaximizeMouseArea
                    anchors.fill: parent
                    visible: false
                    onClicked: {
                        navigationPanel.parent.state = "navigationFullScreen"
                    }
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
                    PropertyChanges { target: webViewMaximizeMouseArea; visible: true; }
                }
            ]

            transitions: [
                Transition {
                    to: "minimized"
                    SequentialAnimation {
                        PropertyAnimation { properties: "scale"; duration: 300; }
                        PropertyAnimation { target: closeBtn; properties: "visible"; duration: 0; }
                        PropertyAnimation { target: addToFavBtn; properties: "visible"; duration: 0; }
                        PropertyAnimation { target: webViewMaximizeMouseArea; properties: "visible"; duration: 0; }
                    }
                },
                Transition {
                    to: ""
                    SequentialAnimation {
                        PropertyAnimation { target: closeBtn; properties: "visible"; duration: 0; }
                        PropertyAnimation { target: addToFavBtn; properties: "visible"; duration: 0; }
                        PropertyAnimation { properties: "scale"; duration: 300; }
                        PropertyAnimation { target: webViewMaximizeMouseArea; properties: "visible"; duration: 0; }
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


        Row {
            id: tabBarRow
            spacing: 5
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
                if (Math.abs(mouse.y - lastY) > height*3
                    || Math.abs(mouse.x - lastX) < 50) {
                    // normal click,
                    navigationPanel.state = "";
                    navigationPanel.parent.state = "navigation";
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

        tabCount += 1
    }

    states: [
        State {
            name: ""
            PropertyChanges { target: tabBar; state: "minimized" }
            StateChangeScript {
                script: TabManager.getWebPage(currentTabIndex).state = "minimized"
            }
        },
        State {
            name: "fullscreen"
            PropertyChanges { target: tabBar; state: "" }
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
