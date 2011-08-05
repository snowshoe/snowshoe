/****************************************************************************
 *   Copyright (C) 2011  Andreas Kling <awesomekling@gmail.com>             *
 *                                                                          *
 *   This file may be used under the terms of the GNU Lesser                *
 *   General Public License version 2.1 as published by the Free Software   *
 *   Foundation and appearing in the file LICENSE.LGPL included in the      *
 *   packaging of this file.  Please review the following information to    *
 *   ensure the GNU Lesser General Public License version 2.1 requirements  *
 *   will be met: http://www.gnu.org/licenses/old-licenses/lgpl-2.1.html.   *
 *                                                                          *
 *   This program is distributed in the hope that it will be useful,        *
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of         *
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the          *
 *   GNU Lesser General Public License for more details.                    *
 ****************************************************************************/

#include "BrowserWindow.h"

#include "BrowserObject.h"
#include "MainView.h"
#include <QtCore/QCoreApplication>
#include <QtCore/QSettings>
#include <QtCore/QUrl>
#include <QtGui/QAction>
#include <QtGui/QImageReader>

BrowserWindow* BrowserWindow::create()
{
    return new BrowserWindow();
}

BrowserWindow::BrowserWindow()
    : QMainWindow(0)
    , m_browserObject(new BrowserObject(this))
{

    setAttribute(Qt::WA_DeleteOnClose);

    m_mainView = new MainView(this);

    QAction* newWindowAction = new QAction(this);
    newWindowAction->setShortcut(QKeySequence(Qt::CTRL | Qt::Key_N));
    connect(newWindowAction, SIGNAL(triggered()), this, SLOT(openNewWindow()));
    addAction(newWindowAction);

    setCentralWidget(m_mainView);

    QSettings settings;

    if (!restoreGeometry(settings.value("mainWindowGeometry").toByteArray()))
        resize(800, 600);

    restoreState(settings.value("mainWindowState").toByteArray());
}

void BrowserWindow::openInNewTab(const QString& urlFromUserInput)
{
    m_mainView->openInNewTab(urlFromUserInput);
}

BrowserWindow* BrowserWindow::openInNewWindow(const QString& url)
{
    BrowserWindow* window = BrowserWindow::create();
    openInNewTab(url);
    window->show();
    return window;
}

void BrowserWindow::openNewWindow()
{
    openInNewWindow(QString());
}

BrowserWindow::~BrowserWindow()
{
}

void BrowserWindow::closeEvent(QCloseEvent*)
{
    QSettings settings;
    settings.setValue("mainWindowGeometry", saveGeometry());
    settings.setValue("mainWindowState", saveState());
}
