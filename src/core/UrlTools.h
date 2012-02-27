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

#ifndef UrlTools_h
#define UrlTools_h

#include <QtCore/QObject>
#include <QtCore/QUrl>

class UrlTools : public QObject {
    Q_OBJECT

public:
    UrlTools(QObject* parent = 0)
        : QObject(parent) { }

    Q_INVOKABLE QUrl fromUserInput(const QString& input)
    {
        return QUrl::fromUserInput(input);
    }

    Q_INVOKABLE bool isValid(const QUrl& url)
    {
        return url.isValid();
    }

    Q_INVOKABLE bool isEmpty(const QUrl& url)
    {
        return url.isEmpty();
    }
};

#endif
