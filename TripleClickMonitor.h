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

#ifndef TripleClickMonitor_h
#define TripleClickMonitor_h

#include <QtCore/QEvent>
#include <QtCore/QObject>
#include <QtCore/QTimer>
#include <QtDeclarative/QSGItem>

class TripleClickMonitor : public QObject {
    Q_OBJECT
    Q_PROPERTY(QSGItem* target READ target WRITE setTarget NOTIFY targetChanged)

public:
    TripleClickMonitor(QObject* parent = 0);
    ~TripleClickMonitor();

    QSGItem* target() const { return m_target; }
    void setTarget(QSGItem*);

signals:
    void targetChanged();
    void tripleClicked();

protected:
    bool eventFilter(QObject* object, QEvent* event);

private:
    bool isWatching() const;
    void startWatching();
    void stopWatching();

    QTimer m_timer;
    QSGItem* m_target;
};

#endif // TripleClickMonitor_h
