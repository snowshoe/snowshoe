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
#include <QtDeclarative/QQuickView>
#include <QtGui/QKeySequence>
#include <QtWidgets/QAction>
#include <QtWidgets/QMainWindow>

class BrowserObject;
class PopupMenu;
class QSGItem;

class BrowserWindow : public QQuickView {
    Q_OBJECT

public:
    BrowserWindow(const QStringList& urls);
    virtual ~BrowserWindow();

    BrowserObject* browserObject() { return m_browserObject; }

    void openUrlInNewTab(const QString& urlFromUserInput);

public slots:
    QPoint mapToGlobal(int x, int y);

protected:
    virtual bool event(QEvent*);
    virtual void moveEvent(QMoveEvent*);
    virtual void resizeEvent(QResizeEvent*);

private:
    friend class BrowserObject;
    ApplicationStateTracker* stateTracker() { return &m_stateTracker; }

    void openNewEmptyTab();

    void setupDeclarativeEnvironment();

    QAction* createActionWithShortcut(const QKeySequence&);
    void setupShortcuts();

    ApplicationStateTracker m_stateTracker;
    BrowserObject* m_browserObject;
    QQuickItem* m_browserView;
    PopupMenu* m_popupMenu;
    QMap<QKeySequence, QAction*> m_shortcuts;
};

#endif
