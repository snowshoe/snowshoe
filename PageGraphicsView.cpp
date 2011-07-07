/***************************************************************************
 *   Copyright (c) 2011  Andreas Kling <awesomekling@gmail.com>            *
 *                                                                         *
 *   This program is free software; you can redistribute it and/or modify  *
 *   it under the terms of the GNU General Public License as published by  *
 *   the Free Software Foundation; either version 2 of the License, or     *
 *   (at your option) any later version.                                   *
 *                                                                         *
 *   This program is distributed in the hope that it will be useful,       *
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of        *
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the         *
 *   GNU General Public License for more details.                          *
 *                                                                         *
 *   You should have received a copy of the GNU General Public License     *
 *   along with this program; if not, write to the                         *
 *   Free Software Foundation, Inc.,                                       *
 *   51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA .        *
 ***************************************************************************/

#include "PageGraphicsView.h"

#include "CrashGraphicsItem.h"
#include <QtGui/QGraphicsScene>

#include "qdesktopwebview.h"

PageGraphicsView::PageGraphicsView(QWidget* parent)
    : QGraphicsView(parent)
    , m_crashItem(0)
{
    m_webViewItem = new QDesktopWebView();
    setScene(new QGraphicsScene(this));
    scene()->addItem(m_webViewItem);
    m_webViewItem->setFocus();

    setFrameShape(QFrame::NoFrame);
    setHorizontalScrollBarPolicy(Qt::ScrollBarAlwaysOff);
    setVerticalScrollBarPolicy(Qt::ScrollBarAlwaysOff);

    connect(m_webViewItem, SIGNAL(titleChanged(QString)), this, SIGNAL(titleChanged(QString)));
    connect(m_webViewItem, SIGNAL(statusBarMessageChanged(QString)), this, SIGNAL(statusBarMessageChanged(QString)));
    connect(m_webViewItem, SIGNAL(loadStarted()), this, SIGNAL(loadStarted()));
    connect(m_webViewItem, SIGNAL(loadSucceeded()), this, SIGNAL(loadSucceeded()));
    connect(m_webViewItem, SIGNAL(loadProgress(int)), this, SIGNAL(loadProgress(int)));
    connect(m_webViewItem, SIGNAL(urlChanged(QUrl)), this, SIGNAL(urlChanged(QUrl)));

    // Keeping this feature commented out until we have support for it in the new API.
//    connect(page(), SIGNAL(engineConnectionChanged(bool)), SLOT(onEngineConnectionChanged(bool)));
}

PageGraphicsView::~PageGraphicsView()
{
    delete m_webViewItem;
    m_webViewItem = 0;
}

void PageGraphicsView::resizeEvent(QResizeEvent* event)
{
    QGraphicsView::resizeEvent(event);
    QRectF rect(QPoint(0, 0), event->size());
    m_webViewItem->setGeometry(rect);
    if (m_crashItem)
        m_crashItem->setGeometry(rect);
    scene()->setSceneRect(rect);
}

void PageGraphicsView::load(const QUrl& url)
{
    return m_webViewItem->load(url);
}

void PageGraphicsView::onEngineConnectionChanged(bool connected)
{
    if (connected) {
        delete m_crashItem;
        m_crashItem = 0;
        return;
    }

    m_crashItem = new CrashGraphicsItem;
    m_crashItem->setZValue(1);
    m_crashItem->setGeometry(scene()->sceneRect());
    scene()->addItem(m_crashItem);
    m_crashItem->setVisible(true);
}
