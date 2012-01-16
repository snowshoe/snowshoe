.pragma library

/// I just want a writable list!!! why qml.... why!!!!!!????????????
var tabs = new Array()

function pushTab(webView, statusBarIndicator)
{
    tabs.push( [webView, statusBarIndicator] );
}

function getWebPage(tabIndex)
{
    return tabs[tabIndex][0];
}

function getStatusBarIndicator(tabIndex)
{
    return tabs[tabIndex][1];
}

function tabCount()
{
    return tabs.length;
}

function setAllStatusBarIndicatorStatusBut(newState, excludedId)
{
    for (var i in tabs) {
        if (i !== excludedId)
            tabs[i][1].state = newState;
    }
}

function removeTab(index)
{
    var end = tabs.length - 1;
    tabs[index][0].destroy();
    tabs[index][1].destroy();
    for (var i = index; i < end; ++i)
        tabs[i] = tabs[i+1];
    tabs.pop();
}
