#include <QApplication>
#include <QDeclarativeView>
#include <QUrl>
#include <MDeclarativeCache>

Q_DECL_EXPORT int main(int argc, char** argv)
{
    QApplication* app = MDeclarativeCache::qApplication(argc, argv);

    QDeclarativeView viewer;
    viewer.setSource(QUrl("qrc:/qml/main.qml"));
    viewer.showFullScreen();

    return app->exec();
}
