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


#ifndef BookmarkDataBaseManager_h
#define BookmarkDataBaseManager_h

#include "Bookmark.h"

#include <QtCore/QList>
#include <QtCore/QString>
#include <QtSql/QSqlDatabase>

class BookmarkDataBaseManager
{
public:
    static BookmarkDataBaseManager* create();
    ~BookmarkDataBaseManager();

    bool initialize();

    QList<Bookmark> bookmarks(const QString& whereClause = QString());
    bool data(Bookmark&);
    bool store(const Bookmark&);
    bool update(const Bookmark&);
    bool remove(const Bookmark&);

protected:
    BookmarkDataBaseManager();

    bool buildTables();

private:
    QSqlDatabase m_database;
};

#endif
