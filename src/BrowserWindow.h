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

#ifndef BrowserWindow_h
#define BrowserWindow_h

#include "ApplicationStateTracker.h"
#include <QtGui/QKeySequence>
#include <QtQuick/QQuickView>
#include <QtWidgets/QAction>
#include <QtWidgets/QMainWindow>

class PopupMenu;
class QSGItem;

class BrowserWindow : public QQuickView {
    Q_OBJECT

public:
    BrowserWindow(const QStringList& urls);
    virtual ~BrowserWindow();

    void openUrlInNewTab(const QString& urlFromUserInput);

    Q_INVOKABLE QPoint mapToGlobal(int x, int y);

    // FIXME: Move those to appropriate objects to be exposed (for Settings and Download).
    Q_INVOKABLE void updateUrlsOpened(const QStringList&);
    Q_INVOKABLE QString decideDownloadPath(const QString& suggestedPath);

protected:
    virtual bool event(QEvent*);
    virtual void moveEvent(QMoveEvent*);
    virtual void resizeEvent(QResizeEvent*);

private:
    ApplicationStateTracker* stateTracker() { return &m_stateTracker; }

    void openNewEmptyTab();

    void setupDeclarativeEnvironment();

    QAction* createActionWithShortcut(const QKeySequence&);
    void setupShortcuts();

    ApplicationStateTracker m_stateTracker;
    QQuickItem* m_browserView;
    PopupMenu* m_popupMenu;
    QMap<QKeySequence, QAction*> m_shortcuts;
};

#endif
