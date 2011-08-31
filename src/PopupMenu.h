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

#ifndef PopupMenu_h
#define PopupMenu_h

#include <QtGui/QDialog>

QT_BEGIN_NAMESPACE
class QSGView;
QT_END_NAMESPACE

class PopupMenu : public QDialog {
    Q_OBJECT
    Q_PROPERTY(QString qmlComponent READ qmlComponent WRITE setQmlComponent NOTIFY qmlComponentChanged)
    Q_PROPERTY(int maxWidth READ maxWidth NOTIFY maxWidthChanged)
    Q_PROPERTY(int maxHeight READ maxHeight NOTIFY maxHeightChanged)
public:
    PopupMenu(QWidget* parent = 0);

    void setQmlComponent(const QString&);
    QString qmlComponent() const;

    int maxWidth() const;
    int maxHeight() const;

Q_SIGNALS:
    void qmlComponentChanged();
    void maxWidthChanged();
    void maxHeightChanged();

public slots:
    void movePopup(int, int);
    void setContextProperty(const QString&, const QVariant&);
    void showAtPosition(int, int);

private:
    QString m_qmlComponent;
    QSGView* m_view;
};

#endif // PopupMenu_h
