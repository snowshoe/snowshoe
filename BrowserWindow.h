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

#ifndef BrowserWindow_h
#define BrowserWindow_h

#include <QtGui/QMainWindow>

class MainView;
class QTabWidget;
class QUrl;

class BrowserWindow : public QMainWindow {
    Q_OBJECT

public:
    virtual ~BrowserWindow();

    static BrowserWindow* create();

public slots:
    void openInNewTab(const QString& urlFromUserInput);
    BrowserWindow* openInNewWindow(const QString& urlFromUserInput);
    void openNewWindow();

    void jumpToNextTab();
    void jumpToPreviousTab();

private slots:
    void onPageTitleChanged(const QString&);
    void onPageLoadingStateChanged(bool);

private:
    void setFancyWindowTitle(const QString&);
    virtual void timerEvent(QTimerEvent*);

    BrowserWindow();
    MainView* m_mainView;
    int m_spinnerIndex;
    int m_spinnerTimer;
};

#endif
