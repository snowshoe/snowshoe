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

#ifndef TabsModel_h
#define TabsModel_h

#include <QtCore/QAbstractListModel>
#include <QtCore/QPointer>
#include <QtCore/QList>
#include <QtCore/QObject>

class TabsModel : public QAbstractListModel {
    Q_OBJECT

    Q_PROPERTY(int count READ rowCount() NOTIFY countChanged())
    Q_PROPERTY(int currentWebViewIndex READ currentWebViewIndex() WRITE setCurrentWebViewIndex() NOTIFY currentWebViewIndexChanged())
    Q_PROPERTY(QObject* currentWebView READ currentWebView() NOTIFY currentWebViewChanged())
public:
    TabsModel(QObject* parent = 0);

    int rowCount(const QModelIndex& parent = QModelIndex()) const;
    QVariant data(const QModelIndex&, int role) const;

    QObject* currentWebView();
    int currentWebViewIndex() { return m_currentWebViewIndex; };
    void setCurrentWebViewIndex(int);

public slots:
    void append(QObject* webView);
    void remove(int pos);

private slots:
    void onUrlChanged();

Q_SIGNALS:
    void countChanged();
    void currentWebViewIndexChanged();
    void currentWebViewChanged();

private:
    void generateRolenames();

    typedef QList<QPointer<QObject> > TabsList;
    TabsList m_list;
    int m_currentWebViewIndex;
};


#endif
