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

#include "TabsModel.h"

enum TabModelRole {
    UrlRole = Qt::UserRole + 1,
    ThumbnailRole
};

TabsModel::TabsModel(QObject* parent)
    : QAbstractListModel(parent)
    , m_currentWebViewIndex(-1)
{
    connect(this, SIGNAL(rowsInserted(const QModelIndex&, int, int)), SIGNAL(countChanged()));
    connect(this, SIGNAL(rowsRemoved(const QModelIndex&, int, int)), SIGNAL(countChanged()));
    generateRolenames();
}

QVariant TabsModel::data(const QModelIndex& index, int role) const
{

    if (!index.isValid() || index.row() >= m_list.size())
        return QVariant();

    const QPointer<QObject>& data = m_list.at(index.row());
    switch (role) {
    case UrlRole:
        if (data)
            return data->property("url");
        break;
    case ThumbnailRole:
        static QString defaultThumbnail = QStringLiteral("qrc:///mobile/grid/thumb_tabs_placeholder");
        return QVariant::fromValue(defaultThumbnail);
    }
    return QVariant();
}

void TabsModel::append(QObject* webView)
{
    QModelIndex index = QModelIndex();
    beginInsertRows(index, rowCount(index), rowCount(index));
    QPointer<QObject> item = webView;
    connect(webView, SIGNAL(urlChanged()), SLOT(onUrlChanged()));
    m_list.append(item);
    endInsertRows();
    setCurrentWebViewIndex(m_list.size() - 1);
}

void TabsModel::onUrlChanged()
{
    QObject* webView = sender();
    int i = 0;
    for (TabsList::iterator it = m_list.begin(); it != m_list.end(); ++it, ++i) {
        if (it->data() == webView) {
            QModelIndex modelIndex = createIndex(i, 0);
            emit dataChanged(modelIndex, modelIndex);
            return;
        }
    }
}

void TabsModel::remove(int pos)
{
    if (pos < 0 || pos >= m_list.size())
        return;

    beginRemoveRows(QModelIndex(), pos, pos);
    QPointer<QObject> item = m_list.takeAt(pos);
    endRemoveRows();
    delete item;
    if (currentWebViewIndex() < 0)
        return;

    if (m_list.empty())
        setCurrentWebViewIndex(-1);
    else {
        if (pos > 0)
            setCurrentWebViewIndex(pos - 1);
        else
            emit currentWebViewChanged();
    }
}

void TabsModel::generateRolenames()
{
    QHash<int, QByteArray> roles;
    roles[UrlRole] = QByteArray("url");
    roles[ThumbnailRole] = QByteArray("thumbnail");
    setRoleNames(roles);
}

void TabsModel::setCurrentWebViewIndex(int pos)
{
    if (m_currentWebViewIndex == pos || pos >= m_list.size())
        return;

    m_currentWebViewIndex = pos;
    emit currentWebViewIndexChanged();
    emit currentWebViewChanged();
}

QObject* TabsModel::currentWebView()
{
    if (m_currentWebViewIndex < 0)
        return 0;

    return m_list[m_currentWebViewIndex].data();
}

int TabsModel::rowCount(const QModelIndex&) const
{
    return m_list.count();
}
