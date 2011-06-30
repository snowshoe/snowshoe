/***************************************************************************
 *   Copyright (c) 2011  Andreas Kling <awesomekling@gmail.com>            *
 *                                                                         *
 *   This program is free software; you can redistribute it and/or modify  *
 *   it under the terms of the GNU General Public License as published by  *
 *   the Free Software Foundation; either version 2 of the License, or     *
 *   (at your option) any later version.                                   *
 *                                                                         *
 *   This program is distributed in the hope that it will be useful,       *
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of        *
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the         *
 *   GNU General Public License for more details.                          *
 *                                                                         *
 *   You should have received a copy of the GNU General Public License     *
 *   along with this program; if not, write to the                         *
 *   Free Software Foundation, Inc.,                                       *
 *   51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA .        *
 ***************************************************************************/

#include "CrashGraphicsItem.h"

#include <QtGui/QPainter>

CrashGraphicsItem::CrashGraphicsItem(QGraphicsItem* parent)
    : QGraphicsItem(parent)
{ }

CrashGraphicsItem::~CrashGraphicsItem()
{ }

void CrashGraphicsItem::setGeometry(const QRectF& rect)
{
    m_geometry = rect;
}

QRectF CrashGraphicsItem::boundingRect() const
{
    return m_geometry;
}

void CrashGraphicsItem::paint(QPainter* painter, const QStyleOptionGraphicsItem*, QWidget*)
{
    painter->drawText(m_geometry, Qt::AlignCenter, QLatin1String("The web process has crashed. You can try reloading the page."));
}
