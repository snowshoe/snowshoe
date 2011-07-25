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

#include "BrowserObject.h"

#include "BrowserWindow.h"

BrowserObject::BrowserObject(BrowserWindow* window)
    : QObject(window)
    , m_window(window)
{
}

QString BrowserObject::windowTitle() const
{
    return m_window->windowTitle();
}

void BrowserObject::setWindowTitle(const QString& title)
{
    m_window->setWindowTitle(title);
    emit windowTitleChanged();
}

QUrl BrowserObject::urlFromUserInput(const QString& url)
{
    return QUrl::fromUserInput(url);
}

bool BrowserObject::isUrlValid(const QUrl& url)
{
    return url.isValid();
}

bool BrowserObject::isUrlEmpty(const QUrl& url)
{
    return url.isEmpty();
}
