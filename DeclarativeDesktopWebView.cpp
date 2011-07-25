/****************************************************************************
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

#include "DeclarativeDesktopWebView.h"

#include "qdesktopwebview.h"

class DeclarativeDesktopWebViewPrivate {
public:
    DeclarativeDesktopWebViewPrivate(DeclarativeDesktopWebView* v)
        : q(v)
        , loadProgress(0)
        , view(new QDesktopWebView())
    {
        view->setParentItem(q);
        view->setPos(0, 0);

        QObject::connect(view, SIGNAL(titleChanged(QString)), q, SIGNAL(titleChanged(QString)));
        QObject::connect(view, SIGNAL(statusBarMessageChanged(QString)), q, SIGNAL(statusBarMessageChanged(QString)));
        QObject::connect(view, SIGNAL(loadStarted()), q, SIGNAL(loadStarted()));
        QObject::connect(view, SIGNAL(loadSucceeded()), q, SIGNAL(loadSucceeded()));
        QObject::connect(view, SIGNAL(loadFailed(QWebError)), q, SIGNAL(loadFailed(QWebError)));
        QObject::connect(view, SIGNAL(loadProgress(int)), q, SLOT(_q_loadProgressChanged(int)));
        QObject::connect(view, SIGNAL(urlChanged(QUrl)), q, SIGNAL(urlChanged(QUrl)));
    }

    ~DeclarativeDesktopWebViewPrivate()
    {
        delete view;
    }

    void _q_loadProgressChanged(int progress)
    {
        loadProgress = progress;
        emit q->loadProgressChanged();
    }

    DeclarativeDesktopWebView* q;
    int loadProgress;
    QDesktopWebView* view;
};

DeclarativeDesktopWebView::DeclarativeDesktopWebView(QDeclarativeItem *parent)
     : QDeclarativeItem(parent)
     , d(new DeclarativeDesktopWebViewPrivate(this))
{
}

DeclarativeDesktopWebView::~DeclarativeDesktopWebView()
{
    delete d;
}

QString DeclarativeDesktopWebView::title() const
{
    return d->view->title();
}

QUrl DeclarativeDesktopWebView::url() const
{
    return d->view->url();
}

void DeclarativeDesktopWebView::setUrl(const QUrl& url)
{
    d->view->load(url);
}

void DeclarativeDesktopWebView::back()
{
    d->view->navigationAction(QtWebKit::Back)->trigger();
}

void DeclarativeDesktopWebView::forward()
{
    d->view->navigationAction(QtWebKit::Forward)->trigger();
}

void DeclarativeDesktopWebView::reload()
{
    d->view->navigationAction(QtWebKit::Reload)->trigger();
}

void DeclarativeDesktopWebView::stop()
{
    d->view->navigationAction(QtWebKit::Stop)->trigger();
}

int DeclarativeDesktopWebView::loadProgress()
{
    return d->loadProgress;
}

void DeclarativeDesktopWebView::geometryChanged(const QRectF &newGeometry, const QRectF &oldGeometry)
{
    QDeclarativeItem::geometryChanged(newGeometry, oldGeometry);
    d->view->setGeometry(0, 0, newGeometry.width(), newGeometry.height());
}

void DeclarativeDesktopWebView::setFocusOnView()
{
    d->view->setFocus();
}

bool DeclarativeDesktopWebView::hasViewFocus()
{
    return d->view->hasFocus();
}

#include "moc_DeclarativeDesktopWebView.cpp"
