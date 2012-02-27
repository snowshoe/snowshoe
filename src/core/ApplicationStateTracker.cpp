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

#include <QtCore/QSettings>

const int IntervalForSavingStateInMilliseconds = 10000;

ApplicationStateTracker::ApplicationStateTracker()
    : QObject()
    , m_saveTimer()
{
    m_saveTimer.setInterval(IntervalForSavingStateInMilliseconds);
    m_saveTimer.setSingleShot(true);
    connect(&m_saveTimer, SIGNAL(timeout()), SLOT(saveState()));
    loadState();
}

ApplicationStateTracker::~ApplicationStateTracker()
{
    saveState();
}

void ApplicationStateTracker::setWindowGeometry(const QRect& geometry)
{
    m_windowGeometry = geometry;
    startTimerIfNeeded();
}

void ApplicationStateTracker::setUrlsOpened(const QStringList& urls)
{
    if (urls == m_urlsOpened)
        return;
    m_urlsOpened = urls;
    startTimerIfNeeded();
    emit urlsOpenedChanged();
}

void ApplicationStateTracker::loadState()
{
    QSettings settings;
    m_windowGeometry = settings.value("mainWindowGeometry").toRect();
    m_urlsOpened = settings.value("urlsOpened").toStringList();
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
