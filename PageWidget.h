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

#ifndef PageWidget_h
#define PageWidget_h

#include <QtDeclarative/QDeclarativeView>

class DeclarativeDesktopWebView;
class MainView;
class QDeclarativeItem;
class QUrl;

class PageWidget : public QDeclarativeView {
    Q_OBJECT

public:
    PageWidget(QWidget* parent = 0);
    virtual ~PageWidget();

    bool isLoading() const;

    void setUrl(const QUrl&);

signals:
    void titleChanged(const QString&);
    void newWindowRequested();
    void newTabRequested();
    void closeTabRequested();
    void loadingStateChanged(bool);

private slots:
    void focusLocationBar();
    void focusWebView();

    void onLoadStarted();
    void onLoadFinished(bool);
    void onTitleChanged(const QString&);
    void onUrlChanged(const QString& url);

private:
    bool m_loading;
    QDeclarativeItem* m_root;
    QDeclarativeItem* m_urlEdit;
    DeclarativeDesktopWebView* m_view;
};

#endif
