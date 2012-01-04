#include <QApplication>
#include <QDeclarativeView>
#include <QUrl>

int main(int argc, char** argv)
{
    // FIXME: Use the (new?) harmattan booster!!
    QApplication app(argc, argv);

    QDeclarativeView viewer;
    viewer.setSource(QUrl("qrc:/qml/main.qml"));
    viewer.showFullScreen();

    return app.exec();
}
