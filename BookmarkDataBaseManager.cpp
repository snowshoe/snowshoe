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

#include "BookmarkDataBaseManager.h"

#include <QtCore/QDir>
#include <QtCore/QFile>
#include <QtCore/QStringList>
#include <QtCore/QVariant>
#include <QtGui/QDesktopServices>
#include <QtSql/QSqlQuery>

BookmarkDataBaseManager* BookmarkDataBaseManager::create()
{
    static BookmarkDataBaseManager* instance = 0;
    if (!instance)
        instance = new BookmarkDataBaseManager();

    return instance;
}

BookmarkDataBaseManager::BookmarkDataBaseManager()
{
    const QString storagePath = QDesktopServices::storageLocation(QDesktopServices::DataLocation);
    QDir storageDir;
    if (!storageDir.exists(storagePath))
        storageDir.mkpath(storagePath);

    m_database = QSqlDatabase::addDatabase("QSQLITE");

    const QString dataBaseName = storagePath + "/snowshoe.db";
    m_database.setDatabaseName(dataBaseName);
}

BookmarkDataBaseManager::~BookmarkDataBaseManager()
{
    m_database.close();
}

bool BookmarkDataBaseManager::initialize()
{
    if (!m_database.open())
        return false;

    return buildTables();
}

bool BookmarkDataBaseManager::buildTables()
{
    QSqlQuery sqlQuery;

    const QString bookmarkQuery = "CREATE TABLE IF NOT EXISTS bookmarks (id INTEGER PRIMARY KEY AUTOINCREMENT,"
                                  "name VARCHAR, url VARCHAR, dateAdded DATE);";
    return sqlQuery.exec(bookmarkQuery);
}

QList<Bookmark> BookmarkDataBaseManager::bookmarks(const QString& whereClause)
{
    QSqlQuery sqlQuery;
    QString query = "SELECT id, name, url, dateAdded from bookmarks ";

    if (!whereClause.isEmpty()) {
        query += "WHERE " + whereClause;
    }

    sqlQuery.exec(query);

    Bookmark bookmark;
    QList<Bookmark> bookmarks;
    while (sqlQuery.next()) {
        bookmark.setId(sqlQuery.value(0).toInt());
        bookmark.setName(sqlQuery.value(1).toString());
        bookmark.setUrl(sqlQuery.value(2).toString());
        bookmark.setDate(sqlQuery.value(3).toDateTime());
        bookmarks << bookmark;
    }

    return bookmarks;
}

bool BookmarkDataBaseManager::data(Bookmark& bookmark)
{
    QSqlQuery sqlQuery;
    const QString query = "SELECT id, name, url, dateAdded from bookmarks WHERE ";

    if (!bookmark.url().isEmpty()) {
        sqlQuery.prepare(query +  "url like :url");
        sqlQuery.bindValue(":url", QString("%%1%").arg(bookmark.url()));
    } else if (!bookmark.name().isEmpty()) {
        sqlQuery.prepare(query + "name like :name");
        sqlQuery.bindValue(":name", QString("%%1%").arg(bookmark.name()));
    } else if (!bookmark.date().isNull()) {
        sqlQuery.prepare(query + "dateAdded = :dateAdded");
        sqlQuery.bindValue(":dateAdded", bookmark.date());
    }

    sqlQuery.exec();

    if (sqlQuery.first()) {
        bookmark.setId(sqlQuery.value(0).toInt());
        bookmark.setName(sqlQuery.value(1).toString());
        bookmark.setUrl(sqlQuery.value(2).toString());
        bookmark.setDate(sqlQuery.value(3).toDateTime());

        return true;
    }

    return false;
}

bool BookmarkDataBaseManager::store(const Bookmark& bookmark)
{
    QSqlQuery sqlQuery;

    sqlQuery.prepare("INSERT INTO bookmarks (name, url, dateAdded) "
                     "VALUES(:name, :url, :dateAdded)");
    sqlQuery.bindValue(":name", bookmark.name());
    sqlQuery.bindValue(":url", bookmark.url());
    sqlQuery.bindValue(":dateAdded", bookmark.date());

    return sqlQuery.exec();
}

bool BookmarkDataBaseManager::update(const Bookmark& data)
{
    QSqlQuery sqlQuery;

    sqlQuery.prepare("UPDATE bookmarks SET name = :name, url = :url, dateAdded = :dateAdded "
                     "WHERE id = :id");
    sqlQuery.bindValue(":id", data.id());
    sqlQuery.bindValue(":name",  data.name());
    sqlQuery.bindValue(":url", data.url());
    sqlQuery.bindValue(":dateAdded", data.date());

    return sqlQuery.exec();
}

bool BookmarkDataBaseManager::remove(const Bookmark& data)
{
    QSqlQuery sqlQuery;

    sqlQuery.prepare("DELETE FROM bookmarks WHERE id = :id");
    sqlQuery.bindValue(":id", data.id());

    return sqlQuery.exec();
}
