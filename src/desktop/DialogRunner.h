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

#include <QColorDialog>
#include <QFileDialog>
#include <QInputDialog>
#include <QMessageBox>
#include <QObject>
#include <QStringList>

class DialogRunner : public QObject {
    Q_OBJECT
public:
    explicit DialogRunner(QObject* parent = 0);

    Q_INVOKABLE void openFileDialog(QObject* filePickerModel);
    Q_INVOKABLE void openColorDialog(QObject* colorDialogModel);
    Q_INVOKABLE void openAlert(QObject* alertModel);
    Q_INVOKABLE void openConfirm(QObject* confirmModel);
    Q_INVOKABLE void openPrompt(QObject* promptModel);

Q_SIGNALS:
    void fileDialogAccepted(const QStringList& selectedFiles);
    void fileDialogRejected();

    void colorDialogAccepted(const QColor& selectedColor);
    void colorDialogRejected();

    void messageBoxAccepted();
    void messageBoxRejected();

    void inputDialogAccepted(const QString& text);
    void inputDialogRejected();

private slots:
    void onMessageBoxButtonClicked(QAbstractButton*);

private:
    void ensureMessageBox();
    void openMessageBox();
    QScopedPointer<QFileDialog> m_fileDialog;
    QScopedPointer<QColorDialog> m_colorDialog;
    QScopedPointer<QMessageBox> m_messageBox;
    QScopedPointer<QInputDialog> m_inputDialog;
};

#endif // DialogRunner_h
