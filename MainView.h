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

#ifndef MainView_h
#define MainView_h

#include <QtCore/QVariant>
#include <QtDeclarative/QDeclarativeView>

class DeclarativeDesktopWebView;
class QDeclarativeItem;
class QUrl;
class QWebError;

class MainView : public QDeclarativeView {
    Q_OBJECT

public:
    MainView(QWidget* parent = 0);
    virtual ~MainView();

    bool isLoading() const;

    void openInNewTab(const QString& urlFromUserInput);
    void jumpToNextTab();
    void jumpToPreviousTab();

signals:
    void titleChanged(const QString&);
    void loadingStateChanged(bool);

private slots:
    void onTitleChanged(const QString&);
    void onUrlChanged(const QString& url);
    void newTabRequested();
    void closeTabRequested();
    void focusUrlBarRequested();

    void onTabAdded(QVariant);
    void onCurrentTabChanged();

private:
    DeclarativeDesktopWebView* getWebViewForUrlEdit(QObject* urlEdit);

    QDeclarativeItem* m_tabWidget;
};

#endif
