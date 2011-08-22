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
#include "DatabaseManager.h"

#include <QtCore/QDir>
#include <QtCore/QString>
#include <QtGui/QDesktopServices>
#include <QtSql/QSqlError>
#include <QtSql/QSqlQuery>

DatabaseManager* DatabaseManager::m_instance = 0;

DatabaseManager* DatabaseManager::instance()
{
    if (!m_instance)
        m_instance = new DatabaseManager;
    return m_instance;
}

void DatabaseManager::destroy()
{
    if (m_instance) {
        delete m_instance;
        m_instance = 0;
    }
}

DatabaseManager::DatabaseManager()
{
    const QString storagePath = QDesktopServices::storageLocation(QDesktopServices::DataLocation);
    QDir storageDir;
    if (!storageDir.exists(storagePath))
        storageDir.mkpath(storagePath);

    m_database = QSqlDatabase::addDatabase("QSQLITE");

    const QString dataBaseName = storagePath + "/snowshoe.db";
    m_database.setDatabaseName(dataBaseName);

    m_bookmarkModel = new BookmarkModel(m_database);
    m_bookmarkModel->setEditStrategy(QSqlTableModel::OnFieldChange);
}

DatabaseManager::~DatabaseManager()
{
    delete m_bookmarkModel;

    m_database.close();
}

bool DatabaseManager::initialize()
{
    if (m_database.isOpen())
        return true;

    if (!m_database.open())
        return false;

    const bool createdTables = createTables();

    m_bookmarkModel->setTable("bookmarks");
    if (m_bookmarkModel->lastError().isValid())
        return false;

    m_bookmarkModel->generateRoleNames();
    // Populate the model.
    m_bookmarkModel->select();

    return createdTables;
}

bool DatabaseManager::createTables()
{
    QSqlQuery sqlQuery;
    return sqlQuery.exec(m_bookmarkModel->tableCreateQuery());
}

BookmarkModel* DatabaseManager::bookmarkDataBaseModel() const
{
    return m_bookmarkModel;
}
