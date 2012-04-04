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

#ifndef HistoryModel_h
#define HistoryModel_h

#include <QtSql/QSqlDatabase>
#include <QtSql/QSqlTableModel>

class HistoryModel : public QSqlTableModel {
    Q_OBJECT
    Q_PROPERTY(QString filterString READ filterString WRITE setFilterString NOTIFY filterStringChanged)
public:
    HistoryModel(QSqlDatabase, QObject* parent = 0);
    void generateRoleNames();
    QString tableCreateQuery() const;
    QString filterString() const { return m_filterString; };
    void setFilterString(const QString&);

    QVariant data(const QModelIndex&, int role) const;

    Q_INVOKABLE void insert(const QString& url, const QString& title);
    void populate();

Q_SIGNALS:
    void filterStringChanged();

private:
    void sortByRecentlyVisited();
    void sortByMostVisited();
    int visitsCount(const QString& url);

    enum Column {
        Id,
        Url,
        Title,
        VisitsCount,
        LastVisit
    };

    QHash<int, QByteArray> m_roles;
    QString m_filterString;
};

#endif
