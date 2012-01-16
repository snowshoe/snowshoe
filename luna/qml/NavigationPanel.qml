import QtQuick 1.1
// What to do on Qt5 !?
import "UiConstants.js" as UiConstants
import "foo.js" as Foo

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
    }

    Component {
        id: webViewPrototype
        Item {
            property alias text: fakeWebViewText.text
            width: navigationPanel.width
            height: navigationPanel.height - tabBar.height

            Rectangle {
                id: webView
                anchors.fill: parent
                color: "purple"
                radius: 10

                Text {
                    id: fakeWebViewText
                    anchors.centerIn: parent
                    rotation: -45
                }
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        navigationPanel.parent.state = "currentFullScreen"
                        state = "minimized"
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
                        Foo.removeTab(currentTabIndex)
                        navigationPanel.tabCount = Foo.tabCount();
                        if (currentTabIndex === Foo.tabCount())
                            currentTabIndex--;
                        tabBar.setCurrentTab(currentTabIndex)
                    }
                }
            }
            states: [
                State {
                    name: "minimized"
                    PropertyChanges { target: webView; scale: 0.7; }
                    PropertyChanges { target: closeBtn; visible: true; }
                }
            ]

            transitions: [
                Transition {
                    to: "minimized"
                    SequentialAnimation {
                        PropertyAnimation { properties: "scale"; duration: 300; }
                        PropertyAnimation { target: closeBtn; properties: "visible"; duration: 0; }
                    }
                },
                Transition {
                    to: ""
                    SequentialAnimation {
                        PropertyAnimation { target: closeBtn; properties: "visible"; duration: 0; }
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
                var oldStatusElem = Foo.getStatusBarIndicator(currentTabIndex);
                if (oldStatusElem)
                    oldStatusElem.active = false

                Foo.getStatusBarIndicator(index).active = true
                Foo.getWebPage(index).state = state
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
            anchors.fill: parent
            onClicked: {
                navigationPanel.state = ""
                navigationPanel.parent.state = "current"
            }
            onPressAndHold: {
                // emulate swipe gesture to the left
                if (currentTabIndex === 0)
                    return;
                tabBar.setCurrentTab(currentTabIndex - 1);
            }
        }
        states: [
            State {
                name: "minimized"
                StateChangeScript {
                    script: {
                        Foo.setAllStatusBarIndicatorStatusBut("hide", currentTabIndex)
                        Foo.getStatusBarIndicator(currentTabIndex).state = "likeAUrlBar"
                    }
                }
            },
            State {
                name: ""
                StateChangeScript {
                    script: {
                        Foo.setAllStatusBarIndicatorStatusBut("", -1)
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
        Foo.pushTab(webView, statusBarIndicator)

        // reset previous status bullet
        if (currentTabIndex !== -1) {
            var prevStatusElem = Foo.getStatusBarIndicator(currentTabIndex)
            prevStatusElem.active = false
            prevStatusElem.state = ""
            Foo.getWebPage(currentTabIndex).state = ""
        }
        currentTabIndex = Foo.tabCount() - 1
        webViewRow.x = -currentTabIndex * navigationPanel.width

        webView.text = url
        statusBarIndicator.url = url

        tabCount += 1
    }

    states: [
        State {
            name: ""
            PropertyChanges { target: tabBar; state: "minimized" }
            StateChangeScript {
                script: Foo.getWebPage(currentTabIndex).state = "minimized"
            }
        },
        State {
            name: "fullscreen"
            PropertyChanges { target: tabBar; state: "" }
            StateChangeScript {
                script: {
                    if (currentTabIndex - 1  >= 0)
                        Foo.getWebPage(currentTabIndex - 1).state = ""
                    Foo.getWebPage(currentTabIndex).state = ""
                    Foo.getStatusBarIndicator(currentTabIndex).state = ""
                    if (currentTabIndex + 1 < Foo.tabCount())
                        Foo.getWebPage(currentTabIndex + 1).state = ""
                }
            }
        }
    ]
}
