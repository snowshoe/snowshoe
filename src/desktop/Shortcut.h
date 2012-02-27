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

#ifndef Shortcut_h
#define Shortcut_h

#include <QtCore/QObject>
#include <QtGui/QKeySequence>

// FIXME: This a candidate to be polished and added to Qt5.

class Shortcut : public QObject {
    Q_OBJECT
    Q_PROPERTY(QString key READ key WRITE setKey NOTIFY keyChanged)

public:
    Shortcut();
    virtual ~Shortcut();

    virtual bool event(QEvent*);

    QString key() const { return m_keySequence.toString(); }
    void setKey(const QString&);

signals:
    void keyChanged();
    void triggered();

private:
    QKeySequence m_keySequence;
    int m_id;

    void updateShortcutMap(const QKeySequence& oldSequence, const QKeySequence& newSequence);
};

#endif
