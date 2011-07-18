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
    , m_watchTripleClick(false)
    , m_timer(this)
{
    m_timer.setSingleShot(true);
}

TripleClickMonitor::~TripleClickMonitor()
{
}

bool TripleClickMonitor::eventFilter(QObject*, QEvent* event)
{
    if (event->type() == QEvent::GraphicsSceneMouseDoubleClick
        || event->type() == QEvent::GraphicsSceneMousePress) {
        if (m_watchTripleClick) {
            m_watchTripleClick = false;
            if (m_timer.isActive()) {
                m_timer.stop();
                emit tripleClicked();
                return true;
            }
        }
        if (event->type() == QEvent::GraphicsSceneMouseDoubleClick) {
            m_watchTripleClick = true;
            m_timer.start(QApplication::doubleClickInterval());
        }
    }
    return false;
}
