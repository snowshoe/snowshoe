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

#include "DeclarativeDesktopWebView.h"

#include <QtDeclarative/QDeclarativeItem>

MainView::MainView(QWidget* parent)
    : QDeclarativeView(parent)
{
    setAlignment(Qt::AlignLeft | Qt::AlignTop);
    setSource(QUrl("qrc:/qml/main.qml"));

    m_root = qobject_cast<QDeclarativeItem*>(rootObject());
    Q_ASSERT(m_root);

    m_view = m_root->findChild<DeclarativeDesktopWebView*>();
    Q_ASSERT(m_view);

    m_urlEdit = m_root->findChild<QDeclarativeItem*>("urlEdit");
    Q_ASSERT(m_urlEdit);

    connect(m_view, SIGNAL(titleChanged(QString)), this, SIGNAL(titleChanged(QString)));
    connect(m_view, SIGNAL(statusBarMessageChanged(QString)), this, SIGNAL(statusBarMessageChanged(QString)));
    connect(m_view, SIGNAL(loadStarted()), this, SIGNAL(loadStarted()));
    connect(m_view, SIGNAL(loadSucceeded()), this, SIGNAL(loadSucceeded()));
    connect(m_view, SIGNAL(loadProgress(int)), this, SIGNAL(loadProgress(int)));
    connect(m_view, SIGNAL(urlChanged(QUrl)), this, SIGNAL(urlChanged(QUrl)));

    connect(m_urlEdit, SIGNAL(urlEntered(QString)), this, SLOT(onUrlChanged(QString)));
}

MainView::~MainView()
{
}

void MainView::resizeEvent(QResizeEvent* event)
{
    QDeclarativeView::resizeEvent(event);

    m_root->setWidth(width());
    m_root->setHeight(height());
}

void MainView::onUrlChanged(const QString& url)
{
    QMetaObject::invokeMethod(m_view, "setUrl", Qt::AutoConnection, Q_ARG(QUrl, QUrl::fromUserInput(url)));
}
