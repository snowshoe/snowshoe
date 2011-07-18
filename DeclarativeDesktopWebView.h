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

#ifndef DeclarativeDesktopWebView_h
#define DeclarativeDesktopWebView_h

#include <QtDeclarative/QDeclarativeItem>

class DeclarativeDesktopWebViewPrivate;
class QWebError;

class DeclarativeDesktopWebView : public QDeclarativeItem
{
    Q_OBJECT
    Q_PROPERTY(QString title READ title NOTIFY titleChanged)
    Q_PROPERTY(QUrl url READ url WRITE setUrl NOTIFY urlChanged)
    Q_PROPERTY(int loadProgress READ loadProgress NOTIFY loadProgressChanged)
public:
    DeclarativeDesktopWebView(QDeclarativeItem *parent = 0);
    ~DeclarativeDesktopWebView();

    QUrl url() const;
    QString title() const;

    int loadProgress();

    Q_INVOKABLE bool isUrlEmpty() { return url().isEmpty(); }

public Q_SLOTS:
    void setUrl(const QUrl&);
    void back();
    void forward();
    void reload();
    void stop();

protected:
    virtual void geometryChanged(const QRectF&, const QRectF&);

Q_SIGNALS:
    void titleChanged(const QString&);
    void statusBarMessageChanged(const QString&);
    void loadStarted();
    void loadSucceeded();
    void loadFailed(const QWebError&);
    void loadProgressChanged();
    void urlChanged(const QUrl&);

private:
    DeclarativeDesktopWebViewPrivate* d;

    friend class DeclarativeDesktopWebViewPrivate;

    Q_PRIVATE_SLOT(d, void _q_loadProgressChanged(int))
};

#endif // DeclarativeDesktopWebView_h
