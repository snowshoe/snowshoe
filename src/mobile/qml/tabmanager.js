.pragma library

var WINDOW_WIDTH = null;
var WINDOW_HEIGHT = null;
var TAB_SCALE_TABLE = [ null, 0.7, 0.35, 0.1 ];

var FULLSCREEN_LAYOUT = 1;
var OVERVIEW_LAYOUT = 2;

var tabs = new Array()
var currentTab = -1;
var overviewGridSize = 2;
var currentTabLayout = FULLSCREEN_LAYOUT;

function tabCount()
{
    return tabs.length;
}

function removeTab(index)
{
    var end = tabs.length - 1;
    tabs[index][0].destroy();
    tabs[index][1].destroy();
    for (var i in tabs)
        tabs[i] = tabs[i+1];
    tabs.pop();
    if (currentTab !== 0)
        currentTab--;
    setTabLayout(currentTabLayout);
}

function createTab(url, webViewParent, statusParent)
{
    var webView = Qt.createComponent("SnowshoeWebView.qml").createObject(webViewParent,
                                                                         { "url" : url,
                                                                           "width" : WINDOW_WIDTH,
                                                                           "height" : WINDOW_HEIGHT });
    var statusBarIndicator = Qt.createComponent("StatusBarIndicator.qml").createObject(statusParent);
    webView.statusIndicator = statusBarIndicator;

    tabs.push([webView, statusBarIndicator]);
    setCurrentTab(tabs.length - 1);
}

function getCurrentTab()
{
    return tabs[currentTab][0];
}

function setCurrentTab(tabIndex)
{
    if (currentTab !== -1) {
        tabs[currentTab][1].active = false;
        tabs[currentTab][0].state = ""
    }
    currentTab = tabIndex;
    tabs[currentTab][1].active = true;
    setTabLayout(FULLSCREEN_LAYOUT);
}

function goToNextTab()
{
    if (currentTab < tabs.length - 1) {
        setCurrentTab(currentTab + 1);
        doTabNavBar();
    }
}

function goToPreviousTab()
{
    if (currentTab) {
        setCurrentTab(currentTab - 1);
        doTabNavBar();
    }
}

function setTabLayout(layout, option)
{
    if (layout === OVERVIEW_LAYOUT) {
        if (option)
            overviewGridSize = option;
        doTabOverviewLayout();
    } else if (layout === FULLSCREEN_LAYOUT) {
        doTabFullScreenLayout();
    }
}

function doTabOverviewLayout()
{
    var scale = TAB_SCALE_TABLE[overviewGridSize];
    var xOffset = (WINDOW_WIDTH * (1 - scale))/2;
    var yOffset = (WINDOW_HEIGHT * (1 - scale))/2;
    var xStep = WINDOW_WIDTH / overviewGridSize;
    var yStep = WINDOW_HEIGHT / overviewGridSize;

    var line = 0;
    var col = 0;
    for (var i in tabs)
    {
        if (col >= overviewGridSize) {
            line++;
            col = 0;
        }

        var tab = tabs[i][0];
        tab.x = xOffset + col * xStep;
        tab.y = yOffset + line * yStep;
        // FIXME: Use scale here instead of crop the web page
        tab.width = WINDOW_WIDTH * scale;
        tab.height = WINDOW_HEIGHT * scale;
        tab.active = false;
        col++;
    }
}

function doTabFullScreenLayout()
{
    for (var i in tabs)
    {
        var tab = tabs[i][0];
        // FIXME: Use scale here instead of crop the web page
        tab.width = WINDOW_WIDTH;
        tab.height = WINDOW_HEIGHT;
        tab.x = WINDOW_WIDTH * (i - currentTab);
        tab.y = 0;
        tab.active = true;
    }
}

function doTabNavBar()
{
    tabs[currentTab][0].y = 80;
    tabs[currentTab][0].height -= 80;
}
