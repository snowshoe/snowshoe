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

#include "ApplicationStateTracker.h"

#include "BrowserWindow.h"
#include <QtCore/QSettings>

const int IntervalForSavingStateInMilliseconds = 10000;

ApplicationStateTracker::ApplicationStateTracker(BrowserWindow* window)
    : QObject()
    , m_saveTimer()
    , m_window(window)
{
    m_saveTimer.setInterval(IntervalForSavingStateInMilliseconds);
    m_saveTimer.setSingleShot(true);
    connect(&m_saveTimer, SIGNAL(timeout()), SLOT(saveState()));
}

ApplicationStateTracker::~ApplicationStateTracker()
{
    saveState();
}

void ApplicationStateTracker::updateWindowGeometry()
{
    // FIXME : implement that in QWindow.
    // m_windowGeometry = m_window->saveGeometry();
}

void ApplicationStateTracker::restoreWindowGeometry()
{
    // FIXME : implement that in QWindow.
    // QSettings settings;
    // if (!m_window->restoreGeometry(settings.value("mainWindowGeometry").toByteArray()))
    m_window->resize(800, 600);
}

void ApplicationStateTracker::updateUrlsOpened(const QStringList& urls)
{
    m_urlsOpened = urls;
    startTimerIfNeeded();
}

bool ApplicationStateTracker::restoreUrlsOpened()
{
    QSettings settings;
    QStringList storedUrls = settings.value("urlsOpened").toStringList();
    m_urlsOpened = storedUrls;
    if (storedUrls.isEmpty())
        return false;
    for (int i = 0; i < storedUrls.size(); i++)
        m_window->openUrlInNewTab(storedUrls.at(i));
    return true;
}

void ApplicationStateTracker::saveState()
{
    QSettings settings;
    settings.setValue("mainWindowGeometry", m_windowGeometry);
    settings.setValue("urlsOpened", m_urlsOpened);
}

void ApplicationStateTracker::startTimerIfNeeded()
{
    if (!m_saveTimer.isActive())
        m_saveTimer.start();
}
