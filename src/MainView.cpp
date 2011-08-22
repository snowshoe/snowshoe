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

#include "MainView.h"

#include "BookmarkModel.h"
#include "BrowserObject.h"
#include "BrowserWindow.h"
#include "DatabaseManager.h"
#include "qdesktopwebview.h"
#include "PopupMenu.h"

#include <QtDeclarative/QDeclarativeContext>
#include <QtDeclarative/QDeclarativeEngine>
#include <QtDeclarative/QDeclarativeProperty>
#include <QtDeclarative/QSGItem>
#include <QtGui/QAction>
#include <QtGui/QApplication>
#include <QtGui/QLineEdit>
#include <QtGui/QToolBar>
#include <QtGui/QVBoxLayout>

#include <QUrl>

MainView::MainView(BrowserWindow* parent)
    : QSGView(parent)
    , m_tabWidget(0)
    , m_popupMenu(new PopupMenu(this))
{
    rootContext()->setContextProperty("BrowserObject", parent->browserObject());
    rootContext()->setContextProperty("BookmarkModel", DatabaseManager::instance()->bookmarkDataBaseModel());
    rootContext()->setContextProperty("PopupMenu", m_popupMenu);
    rootContext()->setContextProperty("View", this);
    setResizeMode(QSGView::SizeRootObjectToView);
    setSource(QUrl("qrc:/qml/main.qml"));

    connect(engine(), SIGNAL(quit()), QCoreApplication::instance(), SLOT(quit()));

    m_tabWidget = qobject_cast<QSGItem*>(rootObject());
    Q_ASSERT(m_tabWidget);

    setupActions();
}

MainView::~MainView()
{
}

QDesktopWebView* getWebViewForTab(QObject* tab)
{
    QObject* mainView = tab->property("mainView").value<QObject*>();
    // ### Using QObject::property() is giving me 0 here.
    QObject* webView = QDeclarativeProperty::read(mainView, "desktopView").value<QObject*>();
    return qobject_cast<QDesktopWebView*>(webView);
}

void MainView::openInCurrentTab(const QString& urlFromUserInput)
{
    QUrl url = QUrl::fromUserInput(urlFromUserInput);
    if (url.isEmpty())
        return;
    QObject* currentActiveTab = m_tabWidget->property("currentActiveTab").value<QObject*>();
    getWebViewForTab(currentActiveTab)->load(url);
}

QPoint MainView::mapToGlobal(int x, int y)
{
    return QWidget::mapToGlobal(QPoint(x, y));
}

QAction* MainView::createActionWithShortcut(const QKeySequence& shortcut)
{
    QAction* action = new QAction(this);
    action->setShortcut(shortcut);
    addAction(action);
    return action;
}

void MainView::setupActions()
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
