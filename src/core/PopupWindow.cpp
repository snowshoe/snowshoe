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

#include "PopupWindow.h"

#include <QtCore/QTimer>

PopupWindow::PopupWindow(QWindow* parent)
    : QQuickCanvas(parent)
{
    setWindowFlags(Qt::Popup);
    QSurfaceFormat surfaceFormat;
    surfaceFormat.setAlphaBufferSize(8);
    setFormat(surfaceFormat);
    setClearBeforeRendering(true);
    setClearColor(QColor(Qt::transparent));
}

void PopupWindow::showEvent(QShowEvent* ev)
{
    QQuickCanvas::showEvent(ev);
    // In XCB, we are only guaranteed to grab the mouse if there's a platformWindow
    // created. This happens right after this event is sent.
    QTimer::singleShot(0, this, SLOT(setMouseGrab()));
}

// FIXME: I couldn't make the PopupWindow show its contents when hidden then shown again.
// So we now discard during hideEvent. This is convenient if we want to dismiss the window.
// See https://bugreports.qt.nokia.com/browse/QTBUG-23571.
void PopupWindow::hideEvent(QHideEvent* ev)
{
    QQuickCanvas::hideEvent(ev);
    setMouseGrabEnabled(false);
    deleteLater();
}

void PopupWindow::mousePressEvent(QMouseEvent* ev)
{
    QQuickCanvas::mousePressEvent(ev);
    const bool outsideWindow = ev->x() < 0 || ev->x() > width() || ev->y() < 0 || ev->y() > height();
    if (outsideWindow)
        hide();
}

void PopupWindow::setMouseGrab()
{
    setMouseGrabEnabled(true);
}
