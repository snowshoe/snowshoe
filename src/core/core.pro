TEMPLATE = lib
CONFIG = staticlib qt
TARGET= snowshoe

QT +=  declarative sql widgets quick

SOURCES += \
    ApplicationStateTracker.cpp \
    BookmarkFilter.cpp \
    BookmarkModel.cpp \
    DatabaseManager.cpp \
    PopupWindow.cpp

HEADERS += \
    ApplicationStateTracker.h \
    BookmarkFilter.h \
    BookmarkModel.h \
    DatabaseManager.h \
    PopupWindow.h \
    UrlTools.h 
