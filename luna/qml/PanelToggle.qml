import QtQuick 1.1

Row {
    id: panelToggle

    property bool currentEnabled: false
    property int _defaultSpacing: -30

    signal favoritesSelected()
    signal currentSelected()

    function resetToCurrent() {
        // FIXME: Can we disable explicit disable the transition? It isn't affecting the UI at the time of the
        // commit, but ideally we don't want it to run at all in this case.
        state = "current";
    }

    function selectFavorites() {
        if (panelToggle.state === "favorites")
            return;
        panelToggle.state = "favorites";
        panelToggle.favoritesSelected();
    }

    onCurrentEnabledChanged: selectFavorites()

    spacing: _defaultSpacing
    state: "favorites"

    states: [
        State {
            name: "favorites"
            PropertyChanges { target: favorites; active: true }
            PropertyChanges { target: current; active: false }
        },
        State {
            name: "current"
            PropertyChanges { target: favorites; active: false }
            PropertyChanges { target: current; active: true }
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
        id: current
        text: "CURRENT"
        onClicked: {
            if (!currentEnabled)
                return;
            panelToggle.state = "current";
            panelToggle.currentSelected();
        }
    }
}

