#include <QApplication>
#include <QDeclarativeView>
#include <QUrl>
#include <qplatformdefs.h>

#if defined(MEEGO_EDITION_HARMATTAN)
    #include <MDeclarativeCache>
    #define NEW_QAPPLICATION(x, y) MDeclarativeCache::qApplication((x), (y))
    Q_DECL_EXPORT
#else
    #define NEW_QAPPLICATION(x, y) new QApplication((x), (y))
#endif

int main(int argc, char** argv)
{
    QApplication* app = NEW_QAPPLICATION(argc, argv);

    QDeclarativeView viewer;
#if defined(MEEGO_EDITION_HARMATTAN)
    viewer.setSource(QUrl("qrc:/qml/main-harmattan.qml"));
    viewer.showFullScreen();
#else
    viewer.setSource(QUrl("qrc:/qml/main-desktop.qml"));
    viewer.show();
#endif

    return app->exec();
}
