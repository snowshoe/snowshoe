include(../../snowshoe.pri)

TEMPLATE = app
QT += testlib sql script

INCLUDEPATH += \
    $$SNOWSHOE_SOURCE_TREE/core

SOURCES += \
    tst_database.cpp

SOURCES += \
    $$SNOWSHOE_SOURCE_TREE/core/BookmarkModel.cpp \
    $$SNOWSHOE_SOURCE_TREE/core/HistoryModel.cpp \
    $$SNOWSHOE_SOURCE_TREE/core/DatabaseManager.cpp

HEADERS += \
    $$SNOWSHOE_SOURCE_TREE/core/BookmarkModel.h \
    $$SNOWSHOE_SOURCE_TREE/core/HistoryModel.h \
    $$SNOWSHOE_SOURCE_TREE/core/DatabaseManager.h
