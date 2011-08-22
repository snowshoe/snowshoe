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

#ifndef BookmarkModel_h
#define BookmarkModel_h

#include <QtSql/QSqlDatabase>
#include <QtSql/QSqlTableModel>

class BookmarkModel : public QSqlTableModel {
    Q_OBJECT

public:
    BookmarkModel(QSqlDatabase, QObject* parent = 0);
    void generateRoleNames();
    QString tableCreateQuery() const;

    QVariant data(const QModelIndex&, int role) const;

    Q_INVOKABLE void setFilter(const QString&);
    Q_INVOKABLE bool select();

    Q_INVOKABLE void insert(const QString& name, const QString& url);
    Q_INVOKABLE void remove(const QString& url);
    Q_INVOKABLE void update(int index, const QString& name, const QString& url);
    Q_INVOKABLE bool contains(const QString& url);
    Q_INVOKABLE int rowCount() { return QSqlTableModel::rowCount(); };

private:
    QHash<int, QByteArray> m_roles;
};

#endif
