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

#include "BookmarkFilter.h"

BookmarkFilter::BookmarkFilter(QObject *parent)
    : QSortFilterProxyModel(parent)
    , m_startRow(-1)
    , m_endRow(-1)
{

}

bool BookmarkFilter::filterAcceptsRow(int sourceRow, const QModelIndex&) const
{
    return sourceRow >= m_startRow && (sourceRow <= m_endRow || m_endRow == -1);
}

int BookmarkFilter::startRow() const
{
    return m_startRow;
}

void BookmarkFilter::setStartRow(int row)
{
    m_startRow = row;
    emit startRowChanged();
    invalidate();
    reset();
}

int BookmarkFilter::endRow() const
{
    return m_endRow;
}

void BookmarkFilter::setEndRow(int row)
{
    m_endRow = row;
    emit endRowChanged();
    invalidate();
    reset();
}
