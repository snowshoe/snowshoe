# If your application uses the Qt Mobility libraries, uncomment the following
# lines and add the respective components to the MOBILITY variable.
# CONFIG += mobility
# MOBILITY +=

QT += widgets quick webkit

# The .cpp file which was generated for your project. Feel free to hack it.
SOURCES += main.cpp

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
    qml/UrlSuggestions.qml \
    qtc_packaging/debian_harmattan/rules \
    qtc_packaging/debian_harmattan/README \
    qtc_packaging/debian_harmattan/manifest.aegis \
    qtc_packaging/debian_harmattan/copyright \
    qtc_packaging/debian_harmattan/control \
    qtc_packaging/debian_harmattan/compat \
    qtc_packaging/debian_harmattan/changelog

RESOURCES += \
    snowshoe-mobile.qrc

# Install procedures
installPrefix = /opt/snowshoe-mobile

desktopfile.files = mobile_harmattan.desktop
desktopfile.path = /usr/share/applications
icon.files = snowshoe-mobile80.png
icon.path = /usr/share/icons/hicolor/80x80/apps
target.path = /opt/snowshoe-mobile/bin
INSTALLS += icon desktopfile target
