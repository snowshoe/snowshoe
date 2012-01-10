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

#ifndef PopupWindow_h
#define PopupWindow_h

#include <QtQuick/QQuickCanvas>

class PopupWindow : public QQuickCanvas {
    Q_OBJECT

public:
    PopupWindow(QWindow* parent = 0);

protected:
    virtual void showEvent(QShowEvent*);
    virtual void hideEvent(QHideEvent*);

    virtual void mousePressEvent(QMouseEvent*);

private Q_SLOTS:
    void setMouseGrab();
};

#endif
