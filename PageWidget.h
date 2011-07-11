/****************************************************************************
 *   Copyright (C) 2011  Andreas Kling <awesomekling@gmail.com>             *
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

#include <QtGui/QWidget>

class MainView;
class QUrl;

class PageWidget : public QWidget {
    Q_OBJECT

public:
    PageWidget(QWidget* parent = 0);
    virtual ~PageWidget();

    bool isLoading() const;

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

private:
    MainView* m_view;
    bool m_loading;
};

#endif
