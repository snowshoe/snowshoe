import QtQuick 2.0

Row {
    id: panelToggle

    property bool navigationEnabled: true

    signal topSitesSelected()
    signal tabsSelected()

    function resetToTabs() {
        state = "tabs";
    }

    function selectFavorites() {
        if (panelToggle.state === "topsites")
            return;
        panelToggle.state = "topsites";
        topSitesSelected();
    }

    onNavigationEnabledChanged: {
        if (!navigationEnabled)
            selectFavorites();
    }

    state: "topsites"


    Image {
        id: topsites
        source: ":/mobile/view_menu_topsites" + (active ? "_pressed" : "")
        property bool active;

        MouseArea {
            anchors.fill: parent
            onClicked: panelToggle.selectFavorites()
        }
    }
    Image {
        id: tabs
        source: ":/mobile/view_menu_tabs" + (active ? "_pressed" : "")
        property bool active;

        MouseArea {
            anchors.fill: parent
            onClicked: {
                if (!navigationEnabled)
                    return;
                panelToggle.state = "tabs";
                tabsSelected();
            }
        }
    }

    states: [
        State {
            name: "topsites"
            PropertyChanges { target: topsites; active: true }
            PropertyChanges { target: tabs; active: false }
        },
        State {
            name: "tabs"
            PropertyChanges { target: topsites; active: false }
            PropertyChanges { target: tabs; active: true }
        }
    ]

}

