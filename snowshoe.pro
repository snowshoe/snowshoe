TEMPLATE = subdirs
CONFIG += ordered

SUBDIRS = \
    src

contains(CONFIG, test) {
    SUBDIRS += \
        tests
}
