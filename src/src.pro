TEMPLATE = app
TARGET = ../snowshoe

QT += declarative sql widgets webkit quick core-private gui-private

SOURCES += \
    ApplicationStateTracker.cpp \
    BookmarkFilter.cpp \
    BookmarkModel.cpp \
    BrowserWindow.cpp \
    DatabaseManager.cpp \
    PopupWindow.cpp \
    Shortcut.cpp \
    main.cpp

HEADERS += \
    ApplicationStateTracker.h \
    BookmarkFilter.h \
    BookmarkModel.h \
    BrowserWindow.h \
    DatabaseManager.h \
    PopupWindow.h \
    Shortcut.h \
    UrlTools.h

RESOURCES += \
    snowshoe.qrc

MOC_DIR = .moc/
RCC_DIR = .rcc/
OBJECTS_DIR = .obj/

OTHER_FILES += \
    qml/BookmarkBar.qml \
    qml/BookmarkBarDelegate.qml \
    qml/Button.qml \
    qml/DropDownMenuBookmark.qml \
    qml/DropDownMenuBookmarkDelegate.qml \
    qml/HoveredLinkBar.qml \
    qml/NewTab.qml \
    qml/PageWidget.qml \
    qml/Tab.qml \
    qml/TabWidget.js \
    qml/TabWidget.qml \
    qml/UrlBar.qml \
    qml/UrlEdit.qml \
    qml/main.qml
