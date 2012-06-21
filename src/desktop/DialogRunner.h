/****************************************************************************
 *   Copyright (C) 2012  Instituto Nokia de Tecnologia (INdT)               *
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

#ifndef DialogRunner_h
#define DialogRunner_h

#include <QFileDialog>
#include <QObject>
#include <QStringList>

class DialogRunner : public QObject
{
    Q_OBJECT
public:
    explicit DialogRunner(QObject *parent = 0);

    Q_INVOKABLE void openFileDialog(QObject* filePickerModel);

Q_SIGNALS:
    void fileDialogAccepted(const QStringList& selectedFiles);
    void fileDialogRejected();

private:
    QScopedPointer<QFileDialog> m_fileDialog;
};

#endif // DialogRunner_h
