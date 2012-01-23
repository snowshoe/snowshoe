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

#include "LunaWebView.h"

LunaWebView::LunaWebView(QDeclarativeItem *parent)
    : QDeclarativeWebView(parent)
{
    LunaWebPage* webPage = new LunaWebPage(this);
    setPage(webPage);
}

LunaWebView::~LunaWebView()
{
}

LunaWebPage::LunaWebPage(QDeclarativeWebView *parent)
    : QDeclarativeWebPage(parent)
{
}

LunaWebPage::~LunaWebPage()
{
}

QString LunaWebPage::userAgentForUrl(const QUrl& url) const
{
    Q_UNUSED(url);
    // NOTE: Currently using iPhone's user agent.
    // iPhone: "Mozilla/5.0 (iPhone; CPU OS 3_2 like Mac OS X) AppleWebKit/531.21.10 (KHTML, like Gecko) Version/4.0.4 Mobile/7B334b Safari/531.21.10"
    // N9: "Mozilla/5.0 (Meego; NokiaN9) AppleWebKit/534.13 (KHTML, like Gecko) NokiaBrowser/8.5.0 Mobile Safari/534.13"
    // iPad: "Mozilla/5.0 (iPad; U; CPU OS 3_2 like Mac OS X; en-us) AppleWebKit/531.21.10 (KHTML, like Gecko) Version/4.0.4 Mobile/7B334b Safari/531.21.10"
    // Opera: "Opera/9.80 (Windows NT 6.0; U; en) Presto/2.8.99 Version/11.10"
    return QString::fromLatin1("Mozilla/5.0 (iPhone; CPU OS 3_2 like Mac OS X) AppleWebKit/531.21.10 (KHTML, like Gecko) Version/4.0.4 Mobile/7B334b Safari/531.21.10");
}
