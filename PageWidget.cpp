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

#include "PageWidget.h"

#include "BrowserWindow.h"
#include "DeclarativeDesktopWebView.h"

#include <QtDeclarative/QDeclarativeItem>
#include <QtGui/QAction>
#include <QtGui/QApplication>
#include <QtGui/QLineEdit>
#include <QtGui/QToolBar>
#include <QtGui/QVBoxLayout>

#include <QUrl>

// Keeping this feature commented out until we have support for it in the new API.
//QWKPage* newPageCallback(QWKPage* parentPage)
//{
//    BrowserWindow* window = BrowserWindow::create(parentPage->context());
//    PageWidget* page = window->openNewTab();
//    window->show();
//    return page->page();
//}

PageWidget::PageWidget(QWidget* parent)
    : QDeclarativeView(parent)
    , m_loading(false)
    , m_view(0)
{
    setResizeMode(QDeclarativeView::SizeRootObjectToView);
    setSource(QUrl("qrc:/qml/main.qml"));

    m_root = qobject_cast<QDeclarativeItem*>(rootObject());
    Q_ASSERT(m_root);

    m_view = m_root->findChild<DeclarativeDesktopWebView*>();
    Q_ASSERT(m_view);

    m_urlEdit = m_root->findChild<QDeclarativeItem*>("urlEdit");
    Q_ASSERT(m_urlEdit);

    QAction* focusLocationBarAction = new QAction(this);
    focusLocationBarAction->setShortcut(QKeySequence(Qt::CTRL | Qt::Key_L));
    connect(focusLocationBarAction, SIGNAL(triggered()), this, SLOT(focusLocationBar()));
    addAction(focusLocationBarAction);

    QAction* newWindowAction = new QAction(this);
    newWindowAction->setShortcut(QKeySequence(Qt::CTRL | Qt::Key_N));
    connect(newWindowAction, SIGNAL(triggered()), this, SIGNAL(newWindowRequested()));
    addAction(newWindowAction);

    QAction* newTabAction = new QAction(this);
    newTabAction->setShortcut(QKeySequence(Qt::CTRL | Qt::Key_T));
    connect(newTabAction, SIGNAL(triggered()), this, SIGNAL(newTabRequested()));
    addAction(newTabAction);

    QAction* closeTabAction = new QAction(this);
    closeTabAction->setShortcut(QKeySequence(Qt::CTRL | Qt::Key_W));
    connect(closeTabAction, SIGNAL(triggered()), this, SIGNAL(closeTabRequested()));
    addAction(closeTabAction);

    connect(m_view, SIGNAL(loadStarted()), SLOT(focusWebView()));
    connect(m_view, SIGNAL(loadStarted()), SLOT(onLoadStarted()));
//    connect(m_view, SIGNAL(loadFinished(bool)), SLOT(onLoadFinished(bool)));
    connect(m_view, SIGNAL(titleChanged(QString)), SLOT(onTitleChanged(QString)));

//    page()->setCreateNewPageFunction(newPageCallback);
    connect(m_urlEdit, SIGNAL(urlEntered(QString)), this, SLOT(onUrlChanged(QString)));
}

PageWidget::~PageWidget()
{
}

void PageWidget::onTitleChanged(const QString& title)
{
    emit titleChanged(title);
}

void PageWidget::focusLocationBar()
{
    // FIXME.
}

void PageWidget::focusWebView()
{
    setFocus();
}

void PageWidget::onLoadStarted()
{
    m_loading = true;
    emit loadingStateChanged(true);
}

void PageWidget::onLoadFinished(bool /*ok*/)
{
    m_loading = false;
    emit loadingStateChanged(false);
}

bool PageWidget::isLoading() const
{
    return m_loading;
}

void PageWidget::setUrl(const QUrl& url)
{
    QMetaObject::invokeMethod(m_view, "setUrl", Qt::AutoConnection, Q_ARG(QUrl, url));
}

void PageWidget::onUrlChanged(const QString& url)
{
    QMetaObject::invokeMethod(m_view, "setUrl", Qt::AutoConnection, Q_ARG(QUrl, QUrl::fromUserInput(url)));
}
