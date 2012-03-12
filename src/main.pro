TEMPLATE = app
TARGET = ../snowshoe

QT += declarative sql widgets webkit-private quick core-private gui-private

LIBS += -Lcore/ -lsnowshoe

INCLUDEPATH += core

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
    mobile/qml/FavoritesPanel.qml \
    mobile/qml/tabmanager.js \
    mobile/qml/Main.qml \
    mobile/qml/main-harmattan.qml \
    mobile/qml/NavigationPanel.qml \
    mobile/qml/PanelToggle.qml \
    mobile/qml/PanelToggleButton.qml \
    mobile/qml/StatusBarIndicator.qml \
    mobile/qml/UiConstants.js \
    mobile/qml/UrlBar.qml \
    mobile/qtc_packaging/debian_harmattan/rules \
    mobile/qtc_packaging/debian_harmattan/README \
    mobile/qtc_packaging/debian_harmattan/manifest.aegis \
    mobile/qtc_packaging/debian_harmattan/copyright \
    mobile/qtc_packaging/debian_harmattan/control \
    mobile/qtc_packaging/debian_harmattan/compat \
    mobile/qtc_packaging/debian_harmattan/changelog
