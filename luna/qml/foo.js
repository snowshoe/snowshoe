.pragma library

/// I just want a writable list!!! why qml.... why!!!!!!????????????
var webPages = new Array()

function pushWebPage(webView, webViewStatus)
{
    webPages.push( [webView, webViewStatus] );
}

function getWebPageElem(index)
{
    return webPages[index][0];
}

function getWebPageStatusElem(index)
{
    return webPages[index][1];
}

function pageCount()
{
    return webPages.length;
}

function setAllStatusElemStatesBut(newState, excludedId)
{
    for (var i in webPages) {
        if (i != excludedId)
            webPages[i][1].state = newState
    }
}