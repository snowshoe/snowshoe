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

#include "DialogRunner.h"

#include <QVariant>

DialogRunner::DialogRunner(QObject *parent)
    : QObject(parent)
    , m_fileDialog(0)
{
}

void DialogRunner::openFileDialog(QObject* filePickerModel)
{
    if (!filePickerModel)
        return;

    if (!m_fileDialog) {
        m_fileDialog.reset(new QFileDialog);
        connect(m_fileDialog.data(), SIGNAL(rejected()), this, SIGNAL(fileDialogRejected()));
        connect(m_fileDialog.data(), SIGNAL(filesSelected(QStringList)), this, SIGNAL(fileDialogAccepted(QStringList)));
    }

    m_fileDialog->setAcceptMode(QFileDialog::AcceptOpen);
    m_fileDialog->setFileMode(filePickerModel->property("allowMultipleFiles").toBool() ? QFileDialog::ExistingFiles : QFileDialog::ExistingFiles);
    m_fileDialog->setWindowTitle(QLatin1String("Open File - Snowshoe"));

    foreach (const QString &filePath, filePickerModel->property("fileList").toStringList())
        m_fileDialog->selectFile(filePath);
    m_fileDialog->open();
}

void DialogRunner::openColorDialog(QObject* colorDialogModel)
{
    if (!colorDialogModel)
        return;

    if (!m_colorDialog) {
        m_colorDialog.reset(new QColorDialog);
        connect(m_colorDialog.data(), SIGNAL(rejected()), this, SIGNAL(colorDialogRejected()));
        connect(m_colorDialog.data(), SIGNAL(colorSelected(const QColor&)), this, SIGNAL(colorDialogAccepted(const QColor&)));
    }

    m_colorDialog->setCurrentColor(colorDialogModel->property("currentColor").value<QColor>());
    m_colorDialog->setWindowTitle(QLatin1String("Choose Color - Snowshoe"));
    m_colorDialog->open();
}

