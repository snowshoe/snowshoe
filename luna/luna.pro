# If your application uses the Qt Mobility libraries, uncomment the following
# lines and add the respective components to the MOBILITY variable.
# CONFIG += mobility
# MOBILITY +=

# Speed up launching on MeeGo/Harmattan when using applauncherd daemon
CONFIG += qdeclarative-boostable

QT += declarative webkit

# Add dependency to Symbian components
# CONFIG += qt-components

# The .cpp file which was generated for your project. Feel free to hack it.
SOURCES += qdeclarativewebview.cpp \
    LunaWebView.cpp \
    main.cpp

HEADERS += qdeclarativewebview_p.h \
    LunaWebView.h

OTHER_FILES += \
    qml/FavoritesPanel.qml \
    qml/tabmanager.js \
    qml/Main.qml \
    qml/main-desktop.qml \
    qml/main-harmattan.qml \
    qml/NavigationPanel.qml \
    qml/PanelToggle.qml \
    qml/PanelToggleButton.qml \
    qml/StatusBarIndicator.qml \
    qml/UiConstants.js \
    qml/UrlBar.qml \
    qtc_packaging/debian_harmattan/rules \
    qtc_packaging/debian_harmattan/README \
    qtc_packaging/debian_harmattan/manifest.aegis \
    qtc_packaging/debian_harmattan/copyright \
    qtc_packaging/debian_harmattan/control \
    qtc_packaging/debian_harmattan/compat \
    qtc_packaging/debian_harmattan/changelog

RESOURCES += \
    luna.qrc

# Install procedures
installPrefix = /opt/luna

desktopfile.files = luna_harmattan.desktop
desktopfile.path = /usr/share/applications
icon.files = luna80.png
icon.path = /usr/share/icons/hicolor/80x80/apps
target.path = /opt/luna/bin
INSTALLS += icon desktopfile target
