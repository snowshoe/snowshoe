TEMPLATE = lib
CONFIG = staticlib qt
TARGET= snowshoe

QT +=  declarative sql widgets quick

SOURCES += \
    ApplicationStateTracker.cpp \
    RowsRangeFilter.cpp \
    BookmarkModel.cpp \
    HistoryModel.cpp \
    TabsModel.cpp \
    DatabaseManager.cpp \
    PopupWindow.cpp

HEADERS += \
    ApplicationStateTracker.h \
    RowsRangeFilter.h \
    BookmarkModel.h \
    HistoryModel.h \
    TabsModel.h \
    DatabaseManager.h \
    PopupWindow.h \
    UrlTools.h 
