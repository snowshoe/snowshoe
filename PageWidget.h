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

#ifndef PageWidget_h
#define PageWidget_h

#include <QtGui/QWidget>

class PageGraphicsView;
class QLineEdit;
class QUrl;
class QWKContext;
class QWKPage;

class PageWidget : public QWidget {
    Q_OBJECT

public:
    PageWidget(QWKContext*, QWidget* parent = 0);
    virtual ~PageWidget();

    bool isLoading() const;

public slots:
    void load(const QUrl&);

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
    void onLoadProgress(int);
    void onTitleChanged(const QString&);
    void onUrlChanged(const QUrl&);
    void onUrlEditReturnPressed();

private:
    QWKPage* page() const;
    friend QWKPage* newPageCallback(QWKPage*);

    QLineEdit* m_urlEdit;
    PageGraphicsView* m_view;
    bool m_loading;
};

#endif
