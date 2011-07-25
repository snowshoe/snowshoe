include(../../snowshoe.pri)

TEMPLATE = app
QT += testlib sql script

INCLUDEPATH += \
    $$SNOWSHOE_SOURCE_TREE

SOURCES += \
    tst_database.cpp

SOURCES += \
    $$SNOWSHOE_SOURCE_TREE/BookmarkModel.cpp \
    $$SNOWSHOE_SOURCE_TREE/DatabaseManager.cpp

HEADERS += \
    $$SNOWSHOE_SOURCE_TREE/BookmarkModel.h \
    $$SNOWSHOE_SOURCE_TREE/DatabaseManager.h
