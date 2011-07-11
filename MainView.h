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

#include <QtDeclarative/QDeclarativeView>

class QDeclarativeItem;

class MainView : public QDeclarativeView {
    Q_OBJECT

public:
    MainView(QWidget* parent = 0);
    virtual ~MainView();

    void load(const QUrl&);

Q_SIGNALS:
    void titleChanged(const QString&);
    void statusBarMessageChanged(const QString&);
    void loadStarted();
    void loadSucceeded();
    void loadProgress(int progress);
    void urlChanged(const QUrl&);

protected:
    virtual void resizeEvent(QResizeEvent*);

private:
    QDeclarativeItem* m_view;
};

#endif
