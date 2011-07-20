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

#include "AbstractDataBaseType.h"

AbstractDataBaseType::AbstractDataBaseType(QObject* parent)
    : QObject(parent)
    , m_id(-1)
{
}

AbstractDataBaseType::AbstractDataBaseType(const AbstractDataBaseType& abstractDataBaseType)
    : QObject(abstractDataBaseType.parent())
    , m_id (abstractDataBaseType.id())
{
}

int AbstractDataBaseType::id() const
{
    return m_id;
}

void AbstractDataBaseType::setId(int id)
{
    m_id = id;
}
