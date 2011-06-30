#include "BrowserWindow.h"

#include <QtCore/QLatin1String>
#include <QtGui/QApplication>

int main(int argc, char** argv)
{
    QApplication app(argc, argv);
    app.setQuitOnLastWindowClosed(true);
    app.setApplicationName(QLatin1String("Lasso"));

    QStringList arguments = app.arguments();
    arguments.removeAt(0);

    BrowserWindow* window = BrowserWindow::create();

    if (arguments.isEmpty())
        window->openNewTab();
    else
        window->openInNewTab(arguments.at(0));

    window->show();
    app.exec();
    return 0;
}
