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

#include "HistoryModel.h"

#include <QtCore/QDateTime>
#include <QtSql/QSqlError>
#include <QtSql/QSqlQuery>
#include <QtSql/QSqlRecord>

HistoryModel::HistoryModel(QSqlDatabase database, QObject *parent)
    : QSqlTableModel(parent,  database)
{
}

void HistoryModel::generateRoleNames()
{
    for (int i = 0; i < this->columnCount(); i++)
        m_roles[Qt::UserRole + i] = this->headerData(i, Qt::Horizontal).toByteArray();

    setRoleNames(m_roles);
}

QString HistoryModel::tableCreateQuery() const
{
    const QLatin1String historyQuery("CREATE TABLE IF NOT EXISTS history (id INTEGER PRIMARY KEY AUTOINCREMENT,"
                                     "url VARCHAR, title VARCHAR, visitsCount INTEGER, lastVisit DATE);");
    return historyQuery;
}

void HistoryModel::populate()
{
    sortByRecentlyVisited();
    select();
}

void HistoryModel::insert(const QString& url, const QString& title)
{
    if (url.isEmpty())
        return;

    QSqlQuery query(database());
    int visits = visitsCount(url);
    if (visits) {
        static QString updateStatement = QLatin1String("UPDATE history SET visitsCount = ?, title = ?, lastVisit = ? WHERE url = ?");
        query.prepare(updateStatement);
    } else {
        static QString insertStatement = QLatin1String("INSERT INTO history (visitsCount, title, lastVisit, url) VALUES (?, ?, ?, ?)");
        query.prepare(insertStatement);
    }
    query.addBindValue(++visits);
    query.addBindValue(title);
    query.addBindValue(QDateTime::currentDateTime().toTime_t());
    query.addBindValue(url);
    query.exec();
    select();
}

int HistoryModel::visitsCount(const QString& url)
{
    QSqlQuery query(database());
    static QString selectStatement = QLatin1String("SELECT visitsCount FROM history WHERE url = '%1'");
    query.prepare(selectStatement.arg(url));
    query.exec();
    return query.first() ? query.value(0).toInt() : 0;
}

QVariant HistoryModel::data(const QModelIndex& index, int role) const
{
    if (role < Qt::UserRole)
        return QVariant();

    const int columnId = role - Qt::UserRole;
    const QModelIndex modelIndex = createIndex(index.row(), columnId);
    return QSqlTableModel::data(modelIndex, Qt::DisplayRole);
}


void HistoryModel::setFilterString(const QString& filterString)
{
    if (m_filterString == filterString)
        return;

    if (filterString.isEmpty()) {
        sortByRecentlyVisited();
        setFilter("");
    } else {
        static QString filterBase = QLatin1String("url like '%%1%' OR title like '%%1%'");
        sortByMostVisited();
        setFilter(filterBase.arg(filterString));
    }
    m_filterString = filterString;
    emit filterStringChanged();

    // FIXME: explicit call here to avoid not displaying results when user provides
    // a filter with a sql query injected. Injection wont work but for a bit the internal
    // select on setFilter won't be triggered.
    select();
}

void HistoryModel::sortByRecentlyVisited()
{
    setSort(HistoryModel::LastVisit, Qt::DescendingOrder);
}

void HistoryModel::sortByMostVisited()
{
    setSort(HistoryModel::VisitsCount, Qt::DescendingOrder);
}
