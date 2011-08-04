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

#include "PopupMenu.h"

#include <QtDeclarative/QDeclarativeContext>
#include <QtDeclarative/QSGView>
#include <QtGui/QApplication>
#include <QtGui/QDesktopWidget>

class SGView : public QSGView
{
public:
    SGView(QWidget* parent = 0) : QSGView(parent)
    {}
protected:
    void resizeEvent(QResizeEvent* event)
    {
        QSGView::resizeEvent(event);
        parentWidget()->resize(size());
    }
};

PopupMenu::PopupMenu(QWidget* parent)
    : QDialog(parent)
    , m_view(new SGView(this))
{
    m_view->setResizeMode(QSGView::SizeViewToRootObject);
    m_view->rootContext()->setContextProperty("View", this);
    setModal(true);
    setWindowFlags(Qt::Popup);
    hide();
}

void PopupMenu::setQmlComponent(const QString& qmlComponent)
{
    m_qmlComponent = qmlComponent;
    m_view->setSource(QUrl(QString("qrc:/qml/%1.qml").arg(qmlComponent)));
    emit qmlComponentChanged();
}

QString PopupMenu::qmlComponent()
{
    return m_qmlComponent;
}

void PopupMenu::movePopup(int x, int y)
{
    QPoint newPos(x, y);
    QDesktopWidget* desktopWidget = QApplication::desktop();
    int right = x + geometry().width();
    int bottom = y + geometry().height();
    if (right > desktopWidget->screenGeometry().width())
        newPos.setX(x - (right - desktopWidget->screenGeometry().width()));
    if (bottom > desktopWidget->screenGeometry().height())
        newPos.setY(y - (bottom - desktopWidget->screenGeometry().height()));
    move(newPos);
}

void PopupMenu::setContextProperty(const QString& name, const QVariant& variant)
{
    m_view->rootContext()->setContextProperty(name, variant);
}
