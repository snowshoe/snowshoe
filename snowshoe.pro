TEMPLATE = app
TARGET = snowshoe

SOURCES += \
    main.cpp \
    BrowserWindow.cpp \
    CrashGraphicsItem.cpp \
    PageGraphicsView.cpp \
    PageWidget.cpp \

HEADERS += \
    BrowserWindow.h \
    CrashGraphicsItem.h \
    PageGraphicsView.h \
    PageWidget.h \

RESOURCES += \
    snowshoe.qrc

MOC_DIR = .moc/
RCC_DIR = .rcc/
OBJECTS_DIR = .obj/

WEBKIT_SOURCE_DIR = $$(WEBKIT_SOURCE_DIR)
isEmpty(WEBKIT_SOURCE_DIR) {
    error(Please set WEBKIT_SOURCE_DIR environment variable)
} else {
    message(Using WebKit from $$WEBKIT_SOURCE_DIR)
}
WEBKIT_BUILD_DIR = $$WEBKIT_SOURCE_DIR/WebKitBuild/Release

INCLUDEPATH += $$WEBKIT_SOURCE_DIR/Source/
INCLUDEPATH += $$WEBKIT_SOURCE_DIR/Source/WebKit2/UIProcess/API/qt
INCLUDEPATH += $$WEBKIT_SOURCE_DIR/Source/WebKit2/UIProcess/API/C
INCLUDEPATH += $$WEBKIT_SOURCE_DIR/Source/WebKit2/UIProcess/API/cpp
INCLUDEPATH += $$WEBKIT_SOURCE_DIR/Source/WebKit/qt/Api

INCLUDEPATH += $$WEBKIT_BUILD_DIR/include/
INCLUDEPATH += $$WEBKIT_BUILD_DIR/include/WebKit2

macx {
    QMAKE_LFLAGS += -F$$WEBKIT_BUILD_DIR/lib/
    LIBS += -framework QtWebKit
} else {
    LIBS += -L$$WEBKIT_BUILD_DIR/lib
    LIBS += -lQtWebKit
}
