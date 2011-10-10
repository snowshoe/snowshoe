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

#ifndef BookmarkFilter_h
#define BookmarkFilter_h

#include <QtWidgets/QSortFilterProxyModel>

class BookmarkFilter : public QSortFilterProxyModel {
    Q_OBJECT
    Q_PROPERTY(QAbstractItemModel* sourceModel READ sourceModel WRITE setSourceModel)
    Q_PROPERTY(int startRow READ startRow WRITE setStartRow NOTIFY startRowChanged)
    Q_PROPERTY(int endRow READ endRow WRITE setEndRow NOTIFY endRowChanged)
    Q_PROPERTY(int rowCount READ rowCount NOTIFY rowCountChanged)

public:
    BookmarkFilter(QObject *parent = 0);

    bool filterAcceptsRow(int, const QModelIndex&) const;

    int startRow() const;
    void setStartRow(int);

    int endRow() const;
    void setEndRow(int);

signals:
    void startRowChanged();
    void endRowChanged();
    void rowCountChanged();

private slots:
    void onRowsChanged(QModelIndex, int, int);

private:
    int m_startRow;
    int m_endRow;
};

#endif // BookmarkFilter_h
