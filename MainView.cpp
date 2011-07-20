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

#include "BrowserWindow.h"
#include "DeclarativeDesktopWebView.h"
#include "TripleClickMonitor.h"

#include <QtDeclarative/QDeclarativeEngine>
#include <QtDeclarative/QDeclarativeItem>
#include <QtGui/QAction>
#include <QtGui/QApplication>
#include <QtGui/QLineEdit>
#include <QtGui/QToolBar>
#include <QtGui/QVBoxLayout>

#include <QUrl>

MainView::MainView(QWidget* parent)
    : QDeclarativeView(parent)
    , m_tabWidget(0)
{
    setResizeMode(QDeclarativeView::SizeRootObjectToView);
    setSource(QUrl("qrc:/qml/main.qml"));

    connect(engine(), SIGNAL(quit()), QCoreApplication::instance(), SLOT(quit()));

    m_tabWidget = qobject_cast<QDeclarativeItem*>(rootObject());
    Q_ASSERT(m_tabWidget);

    connect(m_tabWidget, SIGNAL(tabAdded(QVariant)), this, SLOT(onTabAdded(QVariant)));
    connect(m_tabWidget, SIGNAL(currentTabChanged()), this, SLOT(onCurrentTabChanged()));

    onTabAdded(m_tabWidget->property("currentActiveTab"));

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

void MainView::onTabAdded(QVariant tab)
{
    QObject* mainView = tab.value<QObject*>()->property("mainView").value<QObject*>();
    QDeclarativeItem* urlEdit = mainView->findChild<QDeclarativeItem*>("urlEdit");
    connect(urlEdit, SIGNAL(urlEntered(QString)), this, SLOT(onUrlChanged(QString)));
    QObject* webView = getWebViewForUrlEdit(urlEdit);
    connect(webView, SIGNAL(titleChanged(QString)), this, SIGNAL(titleChanged(QString)));
    QDeclarativeItem* urlInput = urlEdit->findChild<QDeclarativeItem*>("urlInput");
    TripleClickMonitor* urlEditMonitor = new TripleClickMonitor(mainView);
    urlInput->installEventFilter(urlEditMonitor);
    connect(urlEditMonitor, SIGNAL(tripleClicked()), urlInput, SLOT(selectAll()));
}

void MainView::onCurrentTabChanged()
{
    QObject* currentActiveTab = m_tabWidget->property("currentActiveTab").value<QObject*>();
    emit titleChanged(currentActiveTab->property("text").toString());
}

void MainView::onTitleChanged(const QString& title)
{
    emit titleChanged(title);
}

DeclarativeDesktopWebView* MainView::getWebViewForUrlEdit(QObject* urlEdit)
{
    QObject* view = urlEdit->property("view").value<QObject*>();
    return qobject_cast<DeclarativeDesktopWebView* >(view);
}

void MainView::onUrlChanged(const QString& url)
{
    getWebViewForUrlEdit(sender())->setUrl(QUrl::fromUserInput(url));
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
