/****************************************************************************
 *   Copyright (C) 2011  Andreas Kling <awesomekling@gmail.com>             *
 *   Copyright (C) 2011  Instituto Nokia de Tecnologia (INdT)               *
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

#include "BookmarkModel.h"
#include "BrowserObject.h"
#include "DatabaseManager.h"
#include "PopupMenu.h"
#include "qdesktopwebview.h"
#include <QtCore/QCoreApplication>
#include <QtCore/QSettings>
#include <QtCore/QUrl>
#include <QtDeclarative/QDeclarativeContext>
#include <QtDeclarative/QDeclarativeEngine>
#include <QtDeclarative/QDeclarativeProperty>
#include <QtDeclarative/QSGItem>
#include <QtGui/QAction>



BrowserWindow::BrowserWindow()
    : QMainWindow(0)
    , m_browserObject(new BrowserObject(this))
    , m_view(new QSGView(this))
    , m_tabWidget(0)
    , m_popupMenu(new PopupMenu(this))
{
    setAttribute(Qt::WA_DeleteOnClose);
    setCentralWidget(m_view);

    setupDeclarativeEnvironment();

    m_tabWidget = qobject_cast<QSGItem*>(m_view->rootObject());
    Q_ASSERT(m_tabWidget);

    setupShortcuts();

    restoreSettings();
}

BrowserWindow::~BrowserWindow()
{
}

QPoint BrowserWindow::mapToGlobal(int x, int y)
{
    return QWidget::mapToGlobal(QPoint(x, y));
}

QDesktopWebView* getWebViewForTab(QObject* tab)
{
    QObject* mainView = tab->property("mainView").value<QObject*>();
    // ### Using QObject::property() is giving me 0 here.
    QObject* webView = QDeclarativeProperty::read(mainView, "desktopView").value<QObject*>();
    return qobject_cast<QDesktopWebView*>(webView);
}

void BrowserWindow::openInCurrentTab(const QString& urlFromUserInput)
{
    QUrl url = QUrl::fromUserInput(urlFromUserInput);
    if (url.isEmpty())
        return;
    QObject* currentActiveTab = m_tabWidget->property("currentActiveTab").value<QObject*>();
    getWebViewForTab(currentActiveTab)->load(url);
}

void BrowserWindow::closeEvent(QCloseEvent*)
{
    saveSettings();
}

void BrowserWindow::saveSettings()
{
    QSettings settings;
    settings.setValue("mainWindowGeometry", saveGeometry());
    // ### We don't have QToolbar or QDockWidget, is "saveState()" used for something else?
    settings.setValue("mainWindowState", saveState());
}

void BrowserWindow::restoreSettings()
{
    QSettings settings;
    if (!restoreGeometry(settings.value("mainWindowGeometry").toByteArray()))
        resize(800, 600);
    restoreState(settings.value("mainWindowState").toByteArray());
}

void BrowserWindow::setupDeclarativeEnvironment()
{
    QDeclarativeContext* context = m_view->rootContext();
    context->setContextProperty("BrowserObject", browserObject());
    context->setContextProperty("BookmarkModel", DatabaseManager::instance()->bookmarkDataBaseModel());
    context->setContextProperty("PopupMenu", m_popupMenu);
    context->setContextProperty("View", this);

    QObject::connect(m_view->engine(), SIGNAL(quit()), QCoreApplication::instance(), SLOT(quit()));

    m_view->setResizeMode(QSGView::SizeRootObjectToView);
    m_view->setSource(QUrl("qrc:/qml/main.qml"));
}

QAction* BrowserWindow::createActionWithShortcut(const QKeySequence& shortcut)
{
    QAction* action = new QAction(this);
    action->setShortcut(shortcut);
    addAction(action);
    return action;
}

void BrowserWindow::setupShortcuts()
{
    QAction* focusLocationBarAction = createActionWithShortcut(QKeySequence(Qt::CTRL | Qt::Key_L));
    connect(focusLocationBarAction, SIGNAL(triggered()), m_tabWidget, SLOT(focusUrlBar()));

    QAction* newTabAction = createActionWithShortcut(QKeySequence(Qt::CTRL | Qt::Key_T));
    connect(newTabAction, SIGNAL(triggered()), m_tabWidget, SLOT(addNewTab()));

    QAction* closeTabAction = createActionWithShortcut(QKeySequence(Qt::CTRL | Qt::Key_W));
    connect(closeTabAction, SIGNAL(triggered()), m_tabWidget, SLOT(closeActiveTab()));

    QAction* nextTabAction = createActionWithShortcut(QKeySequence(Qt::CTRL | Qt::Key_PageDown));
    connect(nextTabAction, SIGNAL(triggered()), m_tabWidget, SLOT(jumpToNextTab()));

    QAction* previousTabAction = createActionWithShortcut(QKeySequence(Qt::CTRL | Qt::Key_PageUp));
    connect(previousTabAction, SIGNAL(triggered()), m_tabWidget, SLOT(jumpToPreviousTab()));
}
