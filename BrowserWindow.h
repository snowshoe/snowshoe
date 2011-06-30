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

#ifndef BrowserWindow_h
#define BrowserWindow_h

#include <QtGui/QMainWindow>

class PageWidget;
class QTabWidget;
class QUrl;
class QWKContext;

class BrowserWindow : public QMainWindow {
    Q_OBJECT

public:
    virtual ~BrowserWindow();

    static BrowserWindow* create(QWKContext* context = 0);

public slots:
    PageWidget* openInNewTab(const QString& urlFromUserInput);
    BrowserWindow* openInNewWindow(const QString& urlFromUserInput);

    PageWidget* openNewTab();
    BrowserWindow* openNewWindow();

    void closeCurrentTab();
    void jumpToNextTab();
    void jumpToPreviousTab();

private slots:
    void onCurrentTabChanged(int tabIndex);
    void onTabCloseRequested(int tabIndex);
    void onPageTitleChanged(const QString&);
    void onPageLoadingStateChanged(bool);

private:
    void setFancyWindowTitle(const QString&);
    void closePageWidget(PageWidget*);
    virtual void timerEvent(QTimerEvent*);

    BrowserWindow(QWKContext*);
    QTabWidget* m_tabs;
    QWKContext* m_context;
    int m_spinnerIndex;
    int m_spinnerTimer;
};

#endif
