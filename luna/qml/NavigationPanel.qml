import QtQuick 1.1
// What to do on Qt5 !?
import "UiConstants.js" as UiConstants
import "foo.js" as Foo

Item {
    id: navigationPanel
    width: parent.width
    height: parent.height
    property int currentWebPageIndex: -1
    property int pageCount: 0

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
                        Foo.removeWebPage(currentWebPageIndex)
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
                if (currentWebPageIndex === 0)
                    return
                Foo.getWebPageStatusElem(currentWebPageIndex).active = false
                currentWebPageIndex -= 1
                Foo.getWebPageStatusElem(currentWebPageIndex).active = true
                Foo.getWebPageElem(currentWebPageIndex).scale = 1
                if (currentWebPageIndex - 1 >= 0)
                    Foo.getWebPageElem(currentWebPageIndex - 1).scale = 1
                webViewRow.x = -currentWebPageIndex * navigationPanel.width
            }
        }
        states: [
            State {
                name: "notFullScreen"
                StateChangeScript {
                    script: {
                        Foo.setAllStatusElemStatesBut("hide", currentWebPageIndex)
                        Foo.getWebPageStatusElem(currentWebPageIndex).state = "likeAUrlBar"
                    }
                }
            },
            State {
                name: ""
                StateChangeScript {
                    script: {
                        Foo.setAllStatusElemStatesBut("", -1)
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
        var webViewStatus = Qt.createComponent("StatusBarIndicator.qml").createObject(tabBarRow)
        Foo.pushWebPage(webView, webViewStatus)

        // reset previous status bullet
        if (currentWebPageIndex !== -1) {
            var prevStatusElem = Foo.getWebPageStatusElem(currentWebPageIndex)
            prevStatusElem.active = false
            prevStatusElem.state = ""
            Foo.getWebPageElem(currentWebPageIndex).state = ""
        }
        currentWebPageIndex = Foo.pageCount() - 1
        webViewRow.x = -currentWebPageIndex * navigationPanel.width

        webView.text = url
        webViewStatus.url = url

        pageCount += 1
    }

    states: [
        State {
            name: ""
            PropertyChanges { target: tabBar; state: "notFullScreen" }
            StateChangeScript {
                script: Foo.getWebPageElem(currentWebPageIndex).state = "minimized"
            }
        },
        State {
            name: "fullscreen"
            PropertyChanges { target: tabBar; state: "" }
            StateChangeScript {
                script: {
                    if (currentWebPageIndex - 1  >= 0)
                        Foo.getWebPageElem(currentWebPageIndex - 1).state = ""
                    Foo.getWebPageElem(currentWebPageIndex).state = ""
                    Foo.getWebPageStatusElem(currentWebPageIndex).state = ""
                    if (currentWebPageIndex + 1 < Foo.pageCount())
                        Foo.getWebPageElem(currentWebPageIndex + 1).state = ""
                }
            }
        }
    ]
}
