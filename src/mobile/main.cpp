#include <QApplication>
#include <QQuickView>
#include <QUrl>
#include <qplatformdefs.h>

int main(int argc, char** argv)
{
    QApplication app(argc, argv);

    QQuickView viewer;
#if defined(MEEGO_EDITION_HARMATTAN)
    viewer.setSource(QUrl("qrc:/qml/main-harmattan.qml"));
    viewer.showFullScreen();
#else
    viewer.setSource(QUrl("qrc:/qml/main-desktop.qml"));
    viewer.show();
#endif

    return app.exec();
}
