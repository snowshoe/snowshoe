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

#ifndef ApplicationStateTracker_h
#define ApplicationStateTracker_h

#include <QtCore/QObject>
#include <QtCore/QStringList>
#include <QtCore/QTimer>

class BrowserWindow;

class ApplicationStateTracker : public QObject {
    Q_OBJECT

public:
    ApplicationStateTracker(BrowserWindow*);
    virtual ~ApplicationStateTracker();

    void updateWindowGeometry();
    void restoreWindowGeometry();

    void updateUrlsOpened(const QStringList&);
    bool restoreUrlsOpened();

private slots:
    void saveState();

private:
    Q_DISABLE_COPY(ApplicationStateTracker)

    void startTimerIfNeeded();

    QTimer m_saveTimer;
    BrowserWindow* m_window;
    QByteArray m_windowGeometry;
    QStringList m_urlsOpened;
};

#endif
