import QtQuick 2.0

Row {
    id: panelToggle

    property bool navigationEnabled: true
    property int _defaultSpacing: -30

    signal favoritesSelected()
    signal navigationSelected()

    function resetToNavigation() {
        // FIXME: Can we disable explicit disable the transition? It isn't affecting the UI at the time of the
        // commit, but ideally we don't want it to run at all in this case.
        state = "navigation";
    }

    function selectFavorites() {
        if (panelToggle.state === "favorites")
            return;
        panelToggle.state = "favorites";
        panelToggle.favoritesSelected();
    }

    onNavigationEnabledChanged: {
        if (!navigationEnabled)
            selectFavorites();
    }

    spacing: _defaultSpacing
    state: "favorites"

    states: [
        State {
            name: "favorites"
            PropertyChanges { target: favorites; active: true }
            PropertyChanges { target: navigation; active: false }
        },
        State {
            name: "navigation"
            PropertyChanges { target: favorites; active: false }
            PropertyChanges { target: navigation; active: true }
        }
    ]

    transitions: Transition {
        SequentialAnimation {
            PropertyAnimation { target: panelToggle; properties: "spacing"; to: (-1) * _defaultSpacing; duration: 200 }
            PropertyAnimation { target: panelToggle; properties: "spacing"; to: _defaultSpacing; duration: 200 }
        }
    }

    PanelToggleButton {
        id: favorites
        text: "FAVORITES"
        onClicked: panelToggle.selectFavorites()
    }

    PanelToggleButton {
        id: navigation
        text: "CURRENT"
        onClicked: {
            if (!navigationEnabled)
                return;
            panelToggle.state = "navigation";
            panelToggle.navigationSelected();
        }
    }
}

