/****************************************************************************
 *   Copyright (C) 2011  Andreas Kling <awesomekling@gmail.com>             *
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

#include "BrowserWindowMobile.h"

#include "BookmarkModel.h"
#include "DatabaseManager.h"
#include "HistoryModel.h"
#include "TabsModel.h"
#include "UrlTools.h"
#include <QtCore/QCoreApplication>
#include <QtQml/QQmlContext>
#include <QtQml/QQmlEngine>
#include <QtQuick/QQuickItem>

BrowserWindowMobile::BrowserWindowMobile()
    : m_browserView(0)
{
    setFlags(Qt::Window | Qt::WindowSystemMenuHint | Qt::WindowTitleHint | Qt::WindowMinMaxButtonsHint | Qt::WindowCloseButtonHint);
    setupDeclarativeEnvironment();
    m_browserView = qobject_cast<QQuickItem*>(rootObject());
    Q_ASSERT(m_browserView);
}

void BrowserWindowMobile::setupDeclarativeEnvironment()
{
    QQmlContext* context = rootContext();
    context->setContextProperty("BrowserWindow", this);

    DatabaseManager* dbManager = DatabaseManager::instance();
    context->setContextProperty("HistoryModel", dbManager->historyDataBaseModel());
    context->setContextProperty("BookmarkModel", dbManager->bookmarkDataBaseModel());
    context->setContextProperty("TabsModel", new TabsModel(this));
    context->setContextProperty("UrlTools", new UrlTools(this));

    QObject::connect(engine(), SIGNAL(quit()), qApp, SLOT(quit()));

    setResizeMode(QQuickView::SizeRootObjectToView);
#if defined(SNOWSHOE_MEEGO_HARMATTAN)
    reportContentOrientationChange(Qt::PortraitOrientation);
    setSource(QUrl("qrc:///mobile/qml/main-harmattan.qml"));
#else
    setSource(QUrl("qrc:///mobile/qml/Main.qml"));
#endif
}
