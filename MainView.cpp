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

#include "BrowserObject.h"
#include "BrowserWindow.h"
#include "DeclarativeDesktopWebView.h"

#include <QtDeclarative/QDeclarativeContext>
#include <QtDeclarative/QDeclarativeEngine>
#include <QtDeclarative/QDeclarativeItem>
#include <QtGui/QAction>
#include <QtGui/QApplication>
#include <QtGui/QLineEdit>
#include <QtGui/QToolBar>
#include <QtGui/QVBoxLayout>

#include <QUrl>

MainView::MainView(BrowserWindow* parent)
    : QDeclarativeView(parent)
    , m_tabWidget(0)
{
    rootContext()->setContextProperty("BrowserObject", parent->browserObject());
    setResizeMode(QDeclarativeView::SizeRootObjectToView);
    setSource(QUrl("qrc:/qml/main.qml"));

    connect(engine(), SIGNAL(quit()), QCoreApplication::instance(), SLOT(quit()));

    m_tabWidget = qobject_cast<QDeclarativeItem*>(rootObject());
    Q_ASSERT(m_tabWidget);

    setupActions();
}

MainView::~MainView()
{
}

void MainView::openInNewTab(const QString& urlFromUserInput)
{
    QUrl url = QUrl::fromUserInput(urlFromUserInput);
    if (!url.isEmpty()) {
        QObject* currentActiveTab = m_tabWidget->property("currentActiveTab").value<QObject*>();
        QObject* mainView = currentActiveTab->property("mainView").value<QObject*>();
        QObject* urlEdit = mainView->findChild<QDeclarativeItem*>("urlEdit");
        urlEdit->setProperty("text", url.toString());
        getWebViewForUrlEdit(urlEdit)->setUrl(url);
    }
}

DeclarativeDesktopWebView* MainView::getWebViewForUrlEdit(QObject* urlEdit)
{
    QObject* view = urlEdit->property("view").value<QObject*>();
    return qobject_cast<DeclarativeDesktopWebView* >(view);
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
