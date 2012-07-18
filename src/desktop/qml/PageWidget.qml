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

import QtQuick 2.0
import QtWebKit 3.0
import QtWebKit.experimental 1.0
import Snowshoe 1.0

Item {
    id: root

    property alias url: webView.url
    property alias webView: webView
    property bool isLoading: false
    property string title: "New Tab"
    property string currentUrl
    property bool active: false
    state: "inspectorHidden"

    property variant tab;

    onActiveChanged: { currentUrl = urlBar.text }

    WebView {
        id: webView

        // anchors.fill : root doesn't play nice with when using AnchorChanges we set them explicitely.
        anchors.top: root.top
        anchors.left: root.left
        anchors.right: root.right
        anchors.bottom: root.bottom

        visible: false

        onLoadingChanged: {
            switch (loadRequest.status) {
                case WebView.LoadStartedStatus: {
                    root.isLoading = true;
                    visible = true;
                    newTab.visible = false;
                    if (tab && tab.active && !focus)
                        forceActiveFocus();
                    break;
                }
                case WebView.LoadFailedStatus : {
                    root.isLoading = false;
                    if (loadRequest.errorDomain == WebView.NetworkErrorDomain && loadRequest.errorCode == NetworkReply.OperationCanceledError)
                        return;
                    loadUrl(fallbackUrl(loadRequest.url));
                    break;
                }
                case WebView.LoadSucceededStatus :
                    root.isLoading = false;
                    break;
            }
        }

        onUrlChanged: {
            currentUrl = url
        }

        onLinkHovered: {
            hoveredLink.text = hoveredUrl.toString()
        }

        onTitleChanged: { root.title = title }


        experimental.preferences.fullScreenEnabled: true
        experimental.preferences.developerExtrasEnabled: true
        experimental.preferences.webGLEnabled: true
        experimental.itemSelector: ItemSelector {
            contentArea: root.parent
            // FIXME: We should be able to use Screen.height from QtQuick.Window to
            // calculate this but it isn't working yet.
            maxHeight: 600
        }

        experimental.filePicker: Item {
            id: picker
            // We can't use the model directly in the Connection below.
            property QtObject filePickerModel: model
            Connections {
                target: DialogRunner
                onFileDialogAccepted: picker.filePickerModel.accept(selectedFiles)
                onFileDialogRejected: picker.filePickerModel.reject()
            }

            Component.onCompleted: {
                DialogRunner.openFileDialog(filePickerModel)
            }
        }

        experimental.colorChooser: Item {
            id: colorChooser
            // We can't use the model directly in the Connection below.
            property QtObject colorChooserModel: model
            Connections {
                target: DialogRunner
                onColorDialogAccepted: colorChooser.colorChooserModel.accept(selectedColor)
                onColorDialogRejected: colorChooser.colorChooserModel.reject()
            }

            Component.onCompleted: {
                DialogRunner.openColorDialog(colorChooserModel)
            }
        }

        experimental.alertDialog: Item {
            id: alertBox
            // We can't use the model directly in the Connection below.
            property QtObject alertBoxModel: model
            Connections {
                target: DialogRunner
                onMessageBoxRejected: alertBox.alertBoxModel.dismiss()
                onMessageBoxAccepted: alertBox.alertBoxModel.dismiss()
            }

            Component.onCompleted: {
                DialogRunner.openAlert(alertBoxModel)
            }
        }

        experimental.confirmDialog: Item {
            id: confirmBox
            // We can't use the model directly in the Connection below.
            property QtObject confirmBoxModel: model
            Connections {
                target: DialogRunner
                onMessageBoxRejected: confirmBox.confirmBoxModel.reject()
                onMessageBoxAccepted: confirmBox.confirmBoxModel.accept()
            }

            Component.onCompleted: {
                DialogRunner.openConfirm(confirmBoxModel)
            }
        }

        experimental.promptDialog: Item {
            id: promptDialog
            // We can't use the model directly in the Connection below.
            property QtObject promptDialogModel: model
            Connections {
                target: DialogRunner
                onInputDialogRejected: promptDialog.promptDialogModel.reject()
                onInputDialogAccepted: promptDialog.promptDialogModel.accept(text)
            }

            Component.onCompleted: {
                DialogRunner.openPrompt(promptDialogModel)
            }
        }

        experimental.onDownloadRequested: {
            downloadItem.destinationPath = BrowserWindow.decideDownloadPath(downloadItem.suggestedFilename)
            downloadItem.start()
        }

        onNavigationRequested: {
            if (request.mouseButton == Qt.MiddleButton
                || (request.mouseButton == Qt.LeftButton && request.keyboardModifiers & Qt.ControlModifier)) {
                browserView.openTabWithUrl(request.url)
                request.action = WebView.IgnoreRequest
                return
            }
            request.action = WebView.AcceptRequest
        }

        experimental.onEnterFullScreenRequested : {
            toggleFullScreen();
        }

        experimental.onExitFullScreenRequested : {
            toggleFullScreen();
        }
    }

    Rectangle {
        id: sizeGrip
        color: "gray"
        visible: false
        height: 10
        anchors {
            left: root.left
            right: root.right
        }
        y: Math.round(root.height * 2 / 3)

        MouseArea {
            anchors.fill: parent
            drag.target: sizeGrip
            drag.minimumY: 0
            drag.maximumY: root.height
            drag.axis: Drag.YAxis
        }
    }

    WebView {
        id: inspector
        visible: false
        anchors {
            left: root.left
            right: root.right
            top: sizeGrip.bottom
            bottom: root.bottom
        }
    }

    function loadUrl(url)
    {
        webView.url = url
        currentUrl = url
    }

    function fallbackUrl(url)
    {
        return "http://www.google.com/search?q=" + url;
    }

    function toggleInspector() {
        if (!UrlTools.isValid(webView.url))
            return;
        if (state == "inspectorHidden")
            state = "inspectorShown";
        else
            state = "inspectorHidden";
    }

    NewTab {
        id: newTab
        anchors.fill: parent
    }

    HoveredLinkBar {
        id: hoveredLink
        anchors.bottom: parent.bottom
        anchors.left: parent.left
    }

    states: [
        State {
            name: "inspectorShown"
            PropertyChanges {
                target: inspector
                visible: true
            }
            PropertyChanges {
                target: sizeGrip
                visible: true
            }
            PropertyChanges {
                target: inspector
                url: webView.experimental.remoteInspectorUrl
            }
            AnchorChanges {
                target: webView
                anchors.bottom: sizeGrip.top
            }
        },
        State {
            name: "inspectorHidden"
            PropertyChanges {
                target: inspector
                visible: false
            }
            PropertyChanges {
                target: sizeGrip
                visible: false
            }
            PropertyChanges {
                target: inspector
                url: ""
            }
            AnchorChanges {
                target: webView
                anchors.bottom: root.bottom
            }
        }

    ]
}
