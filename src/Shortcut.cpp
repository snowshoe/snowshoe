/****************************************************************************
 *   Copyright (C) 2012  Instituto Nokia de Tecnologia (INdT)               *
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

#include "Shortcut.h"

#include <QtGui/private/qguiapplication_p.h>
#include <QtGui/private/qshortcutmap_p.h>

static bool alwaysAcceptContextMatcher(QObject*, Qt::ShortcutContext)
{
    // FIXME: We accept all shortcuts. This will need to be changed when we deal with multiple QWindows.
    return true;
}

Shortcut::Shortcut()
    : m_id(0)
{
}

Shortcut::~Shortcut()
{
    updateShortcutMap(m_keySequence, QKeySequence());
}

bool Shortcut::event(QEvent* ev)
{
    if (ev->type() == QEvent::Shortcut) {
        emit triggered();
        return true;
    }
    return QObject::event(ev);
}

void Shortcut::setKey(const QString& key)
{
    QKeySequence newSequence(key);
    if (newSequence == m_keySequence)
        return;

    QKeySequence old = m_keySequence;
    m_keySequence = newSequence;
    updateShortcutMap(old, m_keySequence);

    emit keyChanged();
}

void Shortcut::updateShortcutMap(const QKeySequence& oldSequence, const QKeySequence& newSequence)
{
    QShortcutMap& shortcutMap = QGuiApplicationPrivate::instance()->shortcutMap;
    if (!oldSequence.isEmpty())
        shortcutMap.removeShortcut(m_id, this);
    if (!newSequence.isEmpty())
        m_id = shortcutMap.addShortcut(this, newSequence, Qt::WindowShortcut, alwaysAcceptContextMatcher);
}
