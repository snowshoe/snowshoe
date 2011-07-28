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

#include "TripleClickMonitor.h"

#include <QtGui/QApplication>

TripleClickMonitor::TripleClickMonitor(QObject* parent)
    : QObject(parent)
    , m_timer(this)
    , m_target(0)
{
    m_timer.setSingleShot(true);
}

TripleClickMonitor::~TripleClickMonitor()
{
}

void TripleClickMonitor::setTarget(QSGItem* target)
{
    if (target == m_target)
        return;
    QSGItem* oldTarget = m_target;
    if (oldTarget)
        oldTarget->removeEventFilter(this);
    m_target = target;
    stopWatching();
    if (m_target)
        m_target->installEventFilter(this);
    emit targetChanged();
}

bool TripleClickMonitor::isWatching() const
{
    return m_timer.isActive();
}

void TripleClickMonitor::startWatching()
{
    m_timer.start(QApplication::doubleClickInterval());
}

void TripleClickMonitor::stopWatching()
{
    m_timer.stop();
}

bool TripleClickMonitor::eventFilter(QObject*, QEvent* event)
{
    const bool isDoubleClick = event->type() == QEvent::GraphicsSceneMouseDoubleClick;
    if (isDoubleClick || event->type() == QEvent::GraphicsSceneMousePress) {
        if (isWatching()) {
            stopWatching();
            emit tripleClicked();
            return true;
        }
        if (isDoubleClick)
            startWatching();
    }
    return false;
}
