TEMPLATE = app
TARGET = ../snowshoe

QT += declarative sql widgets webkit-private quick core-private gui-private quick-private

LIBS += -Lcore/ -lsnowshoe

PRE_TARGETDEPS += core/libsnowshoe.a

INCLUDEPATH += core

linux-g++-maemo {
    DEFINES += SNOWSHOE_MEEGO_HARMATTAN
}

SOURCES += \
    desktop/BrowserWindow.cpp \
    desktop/Shortcut.cpp \
    mobile/BrowserWindowMobile.cpp \
    main.cpp

HEADERS += \
    desktop/BrowserWindow.h \
    mobile/BrowserWindowMobile.h \
    desktop/Shortcut.h \

RESOURCES += \
    desktop/snowshoe.qrc \
    mobile/snowshoe-mobile.qrc

MOC_DIR = .moc/
RCC_DIR = .rcc/
OBJECTS_DIR = .obj/

OTHER_FILES += \
    desktop/qml/BookmarkBar.qml \
    desktop/qml/BookmarkBarDelegate.qml \
    desktop/qml/Button.qml \
    desktop/qml/DropDownMenuBookmark.qml \
    desktop/qml/DropDownMenuBookmarkDelegate.qml \
    desktop/qml/HoveredLinkBar.qml \
    desktop/qml/NewTab.qml \
    desktop/qml/PageWidget.qml \
    desktop/qml/Tab.qml \
    desktop/qml/TabWidget.js \
    desktop/qml/TabWidget.qml \
    desktop/qml/UrlBar.qml \
    desktop/qml/UrlEdit.qml \
    desktop/qml/main.qml \
    mobile/qml/Button.qml \
    mobile/qml/TabsPanel.qml \
    mobile/qml/TopSitesPanel.qml \
    mobile/qml/IndicatorRow.qml \
    mobile/qml/UrlInputPanel.qml \
    mobile/qml/Main.qml \
    mobile/qml/main-harmattan.qml \
    mobile/qml/NavigationBar.qml \
    mobile/qml/NavigationPanel.qml \
    mobile/qml/NavigationOverlay.qml \
    mobile/qml/OverlayBar.qml \
    mobile/qml/PanelToggle.qml \
    mobile/qml/PanelToggleButton.qml \
    mobile/qml/PagedGrid.qml \
    mobile/qml/PageFillGrid.qml \
    mobile/qml/PageThumbUrl.qml \
    mobile/qml/StatusBarIndicator.qml \
    mobile/qml/SnowshoeWebView.qml \
    mobile/qml/UiConstants.js \
    mobile/qml/UrlBar.qml \
    mobile/qml/UrlSuggestions.qml \
    mobile/qml/Scrollbar.qml \
    mobile/qml/SuggestionItem.qml \
    mobile/qml/Scrollbar.qml \
    mobile/qml/SwipeArea.qml \
    mobile/qtc_packaging/debian_harmattan/rules \
    mobile/qtc_packaging/debian_harmattan/README \
    mobile/qtc_packaging/debian_harmattan/manifest.aegis \
    mobile/qtc_packaging/debian_harmattan/copyright \
    mobile/qtc_packaging/debian_harmattan/control \
    mobile/qtc_packaging/debian_harmattan/compat \
    mobile/qtc_packaging/debian_harmattan/changelog

# Extra files and install rules for N9.
# TODO support desktop install paths

desktop.path = /usr/share/applications/
icon.files = icons/snowshoe80.png

linux-g++-maemo {
    target.path = /usr/share/snowshoe/

    launcher.files = mobile/snowshoe_launcher
    launcher.path = /usr/bin

    desktop.files = mobile/snowshoe_harmattan.desktop
    icon.path = /usr/share/themes/base/meegotouch/icons/

    # powervr ini file
    powervr.files = mobile/snowshoe.ini
    powervr.path = /etc/powervr.d/

    INSTALLS += launcher powervr

} else {
    target.path = /usr/bin
    desktop.files = desktop/snowshoe.desktop
    icon.path = /usr/share/pixmaps/
}

INSTALLS += target desktop icon
