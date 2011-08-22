TEMPLATE = app
TARGET = ../snowshoe

QT += declarative sql

SOURCES += \
    main.cpp \
    BookmarkModel.cpp \
    BrowserObject.cpp \
    BrowserWindow.cpp \
    DatabaseManager.cpp \
    PopupMenu.cpp \
    TripleClickMonitor.cpp \
    BookmarkFilter.cpp

HEADERS += \
    BookmarkModel.h \
    BrowserObject.h \
    BrowserWindow.h \
    DatabaseManager.h \
    PopupMenu.h \
    TripleClickMonitor.h \
    BookmarkFilter.h

RESOURCES += \
    snowshoe.qrc

MOC_DIR = .moc/
RCC_DIR = .rcc/
OBJECTS_DIR = .obj/

WEBKIT_SOURCE_DIR = $$(WEBKIT_SOURCE_DIR)
isEmpty(WEBKIT_SOURCE_DIR) {
    error(Please set WEBKIT_SOURCE_DIR environment variable)
} else {
    message(Using WebKit source from $$WEBKIT_SOURCE_DIR)
}

WEBKIT_BUILD_DIR = $$(WEBKIT_BUILD_DIR)
isEmpty(WEBKIT_BUILD_DIR) {
    WEBKIT_BUILD_DIR = $$WEBKIT_SOURCE_DIR/WebKitBuild/Release
}

message(Using WebKit build from $$WEBKIT_BUILD_DIR)

INCLUDEPATH += $$WEBKIT_SOURCE_DIR/Source/
INCLUDEPATH += $$WEBKIT_SOURCE_DIR/Source/WebKit2/UIProcess/API/qt
INCLUDEPATH += $$WEBKIT_SOURCE_DIR/Source/WebKit2/UIProcess/API/C
INCLUDEPATH += $$WEBKIT_SOURCE_DIR/Source/WebKit2/UIProcess/API/cpp
INCLUDEPATH += $$WEBKIT_SOURCE_DIR/Source/WebKit/qt/Api

INCLUDEPATH += $$WEBKIT_BUILD_DIR/include/
INCLUDEPATH += $$WEBKIT_BUILD_DIR/include/WebKit2

# WebKit needs to be the first, just in case the Qt build contains already a QtWebKit.
QMAKE_LFLAGS = -L$$WEBKIT_BUILD_DIR/lib $$QMAKE_LFLAGS

macx {
    QMAKE_LFLAGS = -F$$WEBKIT_BUILD_DIR/lib $$QMAKE_LFLAGS
    LIBS += -framework QtWebKit
} else {
    # Make sure that again the custom WebKit is the first in the rpath otherwise it will not pick the right one.
    unix : QMAKE_RPATHDIR = $$WEBKIT_BUILD_DIR/lib $$QMAKE_RPATHDIR
    LIBS += -lQtWebKit
}

OTHER_FILES += \
    qml/main.qml \
    qml/Tab.qml \
    qml/TabWidget.qml \
    qml/TabWidget.js \
    qml/UrlEdit.qml \
    qml/UrlBar.qml \
    qml/PageWidget.qml \
    qml/NewTab.qml \
    qml/BookmarBar.qml \
    qml/DrowDownMenuBookmark.qml \
    qml/BookmarkBarDelegate.qml \
    qml/DrowDownMenuBookmarkDelegate.qml
