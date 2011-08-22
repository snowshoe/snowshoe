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

#ifndef MainView_h
#define MainView_h

#include <QtCore/QVariant>
#include <QtDeclarative/QSGView>
#include <QtGui/QKeySequence>

class BrowserWindow;
class PopupMenu;
class QDesktopWebView;
class QSGItem;
class QUrl;
class QWebError;

class MainView : public QSGView {
    Q_OBJECT

public:
    MainView(BrowserWindow*);
    virtual ~MainView();

    void openInNewTab(const QString& urlFromUserInput);

public slots:
    QPoint mapToGlobal(int x, int y);

private:
    QAction* createActionWithShortcut(const QKeySequence&);
    void setupActions();

    QDesktopWebView* getWebViewForUrlEdit(QObject* urlEdit);

    QSGItem* m_tabWidget;
    PopupMenu* m_popupMenu;
};

#endif
