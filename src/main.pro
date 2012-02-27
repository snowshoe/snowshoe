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
    desktop/qml/main.qml
