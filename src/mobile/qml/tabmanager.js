.pragma library

var WINDOW_WIDTH = 480;
var WINDOW_HEIGHT = 767;
var TAB_Y_OFFSET = 24 * 2 + /*BUTTON HEIGHT*/ 56;
var TAB_SIZE_TABLE = [ null,        // invalid state
                      [400, 582],   // just one tab (gridsize = 1)
                      [192, 286] ]; // 4 tabs in a grid (gridsize = 2)

var NAVBAR_HEIGHT

var FULLSCREEN_LAYOUT = 1;
var OVERVIEW_LAYOUT = 2;

var MAX_GRID_SIZE = 2;

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
    for (var i = index; i < tabs.length - 1; i++)
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
    return webView;
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
    if (currentTab < tabs.length - 1)
        setCurrentTab(currentTab + 1);
}

function goToPreviousTab()
{
    if (currentTab)
        setCurrentTab(currentTab - 1);
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
    var size = TAB_SIZE_TABLE[overviewGridSize];
    var xMargin = 40;
    var yMargin = 16;
    var xStep = (WINDOW_WIDTH - xMargin * 2) / overviewGridSize;
    var yStep = (WINDOW_HEIGHT - yMargin * 2) / overviewGridSize;

    var line = 0;
    var col = 0;
    var tabsPerView = overviewGridSize * overviewGridSize;
    var firstTabToShow = Math.floor(currentTab / tabsPerView) * tabsPerView;
    var lastTabToShow = firstTabToShow + overviewGridSize * overviewGridSize;
    for (var i in tabs)
    {
        var tab = tabs[i][0];
        tab.active = false;

        if (i >= lastTabToShow || i < firstTabToShow) {
            tab.visible = false;
            continue;
        }

        if (col >= overviewGridSize) {
            line++;
            col = 0;
        }

        tab.visible = true;
        tab.x = xMargin + col * xStep;
        tab.y = TAB_Y_OFFSET + yMargin * line * yStep;
        tab.width = size[0];
        tab.height = size[1];
        col++;
        tab.visibility = currentTabLayout === OVERVIEW_LAYOUT && overviewGridSize === 1;
    }
}

function doTabFullScreenLayout()
{
    for (var i in tabs)
    {
        var tab = tabs[i][0];
        tab.width = WINDOW_WIDTH;
        tab.height = WINDOW_HEIGHT;
        tab.x = WINDOW_WIDTH * (i - currentTab);
        tab.y = NAVBAR_HEIGHT;
        tab.visible = tab.x === 0;
        tab.active = tab.x === 0;
        tab.visibility = false;
    }
}

function doTabResetY()
{
    if (currentTab !== -1) {
        tabs[currentTab][0].y = 0;
        tabs[currentTab][0].active = true;
    }
}
