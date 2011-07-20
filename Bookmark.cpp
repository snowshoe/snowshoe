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

#include "Bookmark.h"

Bookmark::Bookmark(QObject* parent)
    : AbstractDataBaseType(parent)
{
}

Bookmark::Bookmark(const Bookmark& bookmark)
    : AbstractDataBaseType(bookmark.parent())
    , m_date(bookmark.date())
    , m_name(bookmark.name())
    , m_url(bookmark.url())
{
}

Bookmark::~Bookmark()
{
}

QString Bookmark::name() const
{
    return m_name;
}

void Bookmark::setName(const QString& name)
{
    m_name = name;
}

QString Bookmark::url() const
{
    return m_url;
}

void Bookmark::setUrl(const QString& url)
{
    m_url = url;
}

QDateTime Bookmark::date() const
{
    return m_date;
}

void Bookmark::setDate(const QDateTime& date)
{
    m_date = date;
}
