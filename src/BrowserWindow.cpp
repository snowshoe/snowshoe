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

#include "BrowserWindow.h"

#include "BookmarkModel.h"
#include "DatabaseManager.h"
#include "PopupMenu.h"
#include "UrlTools.h"
#include <QtCore/QCoreApplication>
#include <QtCore/QDir>
#include <QtCore/QFileInfo>
#include <QtCore/QSettings>
#include <QtCore/QStandardPaths>
#include <QtCore/QUrl>
#include <QtDeclarative/QDeclarativeContext>
#include <QtDeclarative/QDeclarativeEngine>
#include <QtDeclarative/QDeclarativeProperty>
#include <QtQuick/QQuickItem>
#include <QtGui/private/qguiapplication_p.h>

BrowserWindow::BrowserWindow(const QStringList& urls)
    : QQuickView(0)
    , m_stateTracker(this)
    , m_browserView(0)
    , m_popupMenu(new PopupMenu(this))
{
    setupDeclarativeEnvironment();

    m_browserView = qobject_cast<QQuickItem*>(rootObject());
    Q_ASSERT(m_browserView);

    m_stateTracker.restoreWindowGeometry();

    const bool restoredUrls = m_stateTracker.restoreUrlsOpened();
    if (!urls.isEmpty()) {
        for (int i = 0; i < urls.size(); i++)
            openUrlInNewTab(urls.at(i));
    } else if (!restoredUrls)
        openNewEmptyTab();
}

BrowserWindow::~BrowserWindow()
{
}

QPoint BrowserWindow::mapToGlobal(int x, int y)
{
    return QWindow::mapToGlobal(QPoint(x, y));
}

void BrowserWindow::updateUrlsOpened(const QStringList& urls)
{
    m_stateTracker.updateUrlsOpened(urls);
}

QString BrowserWindow::decideDownloadPath(const QString& suggestedFilename)
{
    QString filename(suggestedFilename);
    if (filename.isEmpty())
        filename = "download";

    const QDir homeDir(QStandardPaths::writableLocation(QStandardPaths::HomeLocation));
    if (!homeDir.exists(filename))
        return homeDir.filePath(filename);

    QString suffix;
    if (filename.endsWith(".tar.bz2"))
        suffix = "tar.bz2";
    else if (filename.endsWith(".tar.gz"))
        suffix = "tar.gz";
    else
        suffix = QFileInfo(homeDir, filename).suffix();

    if (!suffix.isEmpty()) {
        suffix.prepend('.');
        filename = filename.left(filename.lastIndexOf(suffix));
    }

    int i = 0;
    const QString fallbackFilename(filename + "_%1" + suffix);
    // FIXME: Using exists() might lead to a race condition with other apps.
    while (homeDir.exists(fallbackFilename.arg(i)))
        ++i;

    return homeDir.filePath(fallbackFilename.arg(i));
}

void BrowserWindow::moveEvent(QMoveEvent* event)
{
    m_stateTracker.updateWindowGeometry(geometry());
    QQuickView::moveEvent(event);}

void BrowserWindow::resizeEvent(QResizeEvent* event)
{
    m_stateTracker.updateWindowGeometry(geometry());
    QQuickView::resizeEvent(event);
}

bool BrowserWindow::event(QEvent* event)
{
    if (event->type() == QEvent::Close)
        deleteLater();

    // FIXME: workarounds the fact that QApplication doesn't process shortcuts for QWindow.
    if (event->type() == QEvent::KeyPress) {
        if (QGuiApplicationPrivate::instance()->shortcutMap.tryShortcutEvent(this, static_cast<QKeyEvent *>(event)))
            return true;
    }
    return QQuickView::event(event);
}

void BrowserWindow::openNewEmptyTab()
{
    QMetaObject::invokeMethod(m_browserView, "addNewEmptyTab");
}

void BrowserWindow::openUrlInNewTab(const QString& urlFromUserInput)
{
    QUrl url = QUrl::fromUserInput(urlFromUserInput);
    QMetaObject::invokeMethod(m_browserView, "addNewTabWithUrl", Q_ARG(QVariant, url));
}

void BrowserWindow::setupDeclarativeEnvironment()
{
    QDeclarativeContext* context = rootContext();
    context->setContextProperty("BookmarkModel", DatabaseManager::instance()->bookmarkDataBaseModel());
    context->setContextProperty("PopupMenu", m_popupMenu);
    context->setContextProperty("BrowserWindow", this);
    context->setContextProperty("UrlTools", new UrlTools(this));

    QObject::connect(engine(), SIGNAL(quit()), qApp, SLOT(quit()));

    setResizeMode(QQuickView::SizeRootObjectToView);
    setSource(QUrl("qrc:/qml/main.qml"));
}
