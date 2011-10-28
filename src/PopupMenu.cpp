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
#include <QtDeclarative/QQuickItem>
#include <QtDeclarative/QQuickView>
#include <QtWidgets/QApplication>
#include <QtWidgets/QDesktopWidget>

PopupMenu::PopupMenu(QWindow* parent)
    : QQuickView(parent)
{
    setResizeMode(QQuickView::SizeViewToRootObject);
    rootContext()->setContextProperty("View", this);
    setWindowModality(Qt::WindowModal);
    setWindowFlags(Qt::Popup | Qt::Dialog);
    hide();

    connect(QApplication::desktop(), SIGNAL(resized(int)), this, SIGNAL(maxWidthChanged()));
    connect(QApplication::desktop(), SIGNAL(resized(int)), this, SIGNAL(maxHeightChanged()));
}

void PopupMenu::setQmlComponent(const QString& qmlComponent)
{
    m_qmlComponent = qmlComponent;
    setSource(QUrl(QString("qrc:/qml/%1.qml").arg(qmlComponent)));
    emit qmlComponentChanged();
}

QString PopupMenu::qmlComponent() const
{
    return m_qmlComponent;
}

int PopupMenu::maxWidth() const
{
    return QApplication::desktop()->screenGeometry().width();
}

int PopupMenu::maxHeight() const
{
    return QApplication::desktop()->screenGeometry().height();
}

void PopupMenu::movePopup(int x, int y)
{
    QPoint newPos(x, y);
    QQuickItem* root = rootObject();
    newPos.setX(x + root->property("rightOffset").toInt());
    newPos.setY(y + root->property("topOffset").toInt());
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
    rootContext()->setContextProperty(name, variant);
}

void PopupMenu::showAtPosition(int x, int y)
{
    show();
    movePopup(x, y);
}
