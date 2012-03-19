import QtQuick 2.0

Item {
    id: delegate
    height: 80
    width: delegate.ListView.view.width

    function bestDelegate(isSearch) {
        if(isSearch)
            return searchDelegate;
        return suggestionDelegate;
    }

    Component {
        id: searchDelegate
        SearchItem {
            onSearchSelected: delegate.ListView.view.searchSelected()
        }
    }

    Component {
        id: suggestionDelegate
        SuggestionItem {
            url: itemUrl
            title: itemTitle
            onSuggestionSelected: delegate.ListView.view.suggestionSelected(url)
        }
    }

    Loader {
        id: itemDisplay
        anchors.fill: parent
        sourceComponent: bestDelegate(isSearch)
    }
}
