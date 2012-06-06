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

#include <QtCore/QDateTime>
#include <QtSql/QSqlError>
#include <QtSql/QSqlQuery>
#include <QtSql/QSqlRecord>

BookmarkModel::BookmarkModel(QSqlDatabase database, QObject *parent)
    : QSqlTableModel(parent,  database)
{
    connect(this, SIGNAL(rowsInserted(const QModelIndex&, int, int)), SIGNAL(countChanged()));
    connect(this, SIGNAL(rowsRemoved(const QModelIndex&, int, int)), SIGNAL(countChanged()));
    setEditStrategy(OnManualSubmit);
}

void BookmarkModel::generateRoleNames()
{
    for (int i = 0; i < this->columnCount(); i++)
        m_roles[Qt::UserRole + i] = this->headerData(i, Qt::Horizontal).toByteArray();

    setRoleNames(m_roles);
}

QString BookmarkModel::tableCreateQuery() const
{
    return QStringLiteral("CREATE TABLE IF NOT EXISTS bookmarks (id INTEGER PRIMARY KEY AUTOINCREMENT,"
                          "name VARCHAR, url VARCHAR, dateAdded DATE, thumbnail BLOB DEFAULT NULL);");
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
    if (contains(url))
        return;
    QSqlRecord record = this->record();
    record.setValue(QLatin1String("name"), name);
    record.setValue(QLatin1String("url"), url);
    record.setValue(QLatin1String("dateAdded"), QDateTime::currentDateTime().toTime_t());

    QModelIndex index = QModelIndex();
    beginInsertRows(index, rowCount(index), rowCount(index));
    insertRecord(-1, record);
    endInsertRows();
    submitAll();
}

void BookmarkModel::remove(const QString& url)
{
    if (!contains(url))
        return;

    QSqlQuery sqlQuery(database());
    sqlQuery.prepare(QLatin1String("SELECT id FROM bookmarks WHERE url = ?"));
    sqlQuery.addBindValue(url);
    sqlQuery.exec();
    sqlQuery.first();
    int indexToDelete = -1;
    for (int row = 0; row < rowCount(); ++row) {
        if (createIndex(row, 0).data(Qt::DisplayRole).toInt() == sqlQuery.value(0).toInt()) {
            indexToDelete = row;
            break;
        }
    }

    if (indexToDelete >= 0) {
        beginRemoveRows(createIndex(indexToDelete, 0), indexToDelete, indexToDelete);
        removeRow(indexToDelete);
        submitAll();
        endRemoveRows();
    }
}

void BookmarkModel::togglePin(const QString& url)
{
    if (contains(url))
        remove(url);
    else
        insert(url, url);
}

void BookmarkModel::update(int index, const QString& name, const QString& url)
{
    QModelIndex nameIndex = createIndex(index, 1);
    QModelIndex urlIndex = createIndex(index, 2);
    QModelIndex dateAddedIndex = createIndex(index, 3);
    setData(nameIndex, name);
    setData(urlIndex, url);
    setData(dateAddedIndex, QDateTime::currentDateTime().toTime_t());
    emit dataChanged(nameIndex, dateAddedIndex);
    submitAll();
}

bool BookmarkModel::contains(const QString& url)
{
    QSqlQuery sqlQuery(database());
    sqlQuery.prepare(QLatin1String("SELECT id FROM bookmarks WHERE url = ?"));
    sqlQuery.addBindValue(url);
    sqlQuery.exec();
    return sqlQuery.first();
}

QVariant BookmarkModel::data(const QModelIndex& index, int role) const
{
    if (role < Qt::UserRole)
        return QSqlQueryModel::data(index, role);

    const int columnId = role - Qt::UserRole;

    // FIXME: placeholder waiting for the time we can get some webpage thumbnails.
    if (columnId == fieldIndex("thumbnail")) {
        static QString defaultThumbnail = QStringLiteral("qrc:///mobile/grid/thumb_mysites_placeholder");
        return QVariant::fromValue(defaultThumbnail);
    }

    const QModelIndex modelIndex = createIndex(index.row(), columnId);
    return QSqlTableModel::data(modelIndex, Qt::DisplayRole);
}
