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

#include "BookmarkModel.h"

#include <QtSql/QSqlError>
#include <QtSql/QSqlRecord>

BookmarkModel::BookmarkModel(QSqlDatabase database, QObject *parent)
    : QSqlTableModel(parent,  database)
{
}

void BookmarkModel::generateRoleNames()
{
    for (int i = 0; i < this->columnCount(); i++)
        m_roles[Qt::UserRole + i] = this->headerData(i, Qt::Horizontal).toByteArray();

    setRoleNames(m_roles);
}

QString BookmarkModel::tableCreateQuery() const
{
    const QString bookmarkQuery = "CREATE TABLE IF NOT EXISTS bookmarks (id INTEGER PRIMARY KEY AUTOINCREMENT,"
                                  "name VARCHAR, url VARCHAR, dateAdded DATE);";

    return bookmarkQuery;

}

void BookmarkModel::setFilter(const QString& filter)
{
    QSqlTableModel::setFilter(filter);
}

bool BookmarkModel::select()
{
    return QSqlTableModel::select();
}

void BookmarkModel::insert(const QString& name, const QString& url)
{
    QSqlRecord record = this->record();
    record.setValue("name", name);
    record.setValue("url", url);

    insertRecord(-1, record);
}

void BookmarkModel::remove(int index)
{
    removeRow(index);
}

void BookmarkModel::update(int index, const QString& name, const QString& url)
{
    setData(this->index(index, 1), name);
    setData(this->index(index, 2), url);
}

QVariant BookmarkModel::data(const QModelIndex& index, int role) const
{
    QVariant value;
    if (role < Qt::UserRole)
        value = QSqlQueryModel::data(index, role);
    else {
        const int columnId = role - Qt::UserRole;
        const QModelIndex modelIndex = this->index(index.row(), columnId);
        value = QSqlTableModel::data(modelIndex, Qt::DisplayRole);
    }
    return value;
}
