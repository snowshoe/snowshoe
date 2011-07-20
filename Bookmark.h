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

#ifndef Bookmark_h
#define Bookmark_h

#include "AbstractDataBaseType.h"

#include <QtCore/QDateTime>
#include <QtCore/QObject>

class Bookmark : public AbstractDataBaseType
{
    Q_OBJECT
    Q_PROPERTY(QString name READ name WRITE setName)
    Q_PROPERTY(QString url READ url WRITE setUrl)
    Q_PROPERTY(QDateTime date READ date WRITE setDate)

public:
    Bookmark(QObject* parent = 0);
    Bookmark(const Bookmark&);
    ~Bookmark();

    QString name() const;
    void setName(const QString&);

    QString url() const;
    void setUrl(const QString&);

    QDateTime date() const;
    void setDate(const QDateTime&);

private:
    QDateTime m_date;
    QString m_name;
    QString m_url;
};

#endif
