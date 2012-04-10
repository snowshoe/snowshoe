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

import QtQuick 2.0
import "UiConstants.js" as UiConstants

BorderImage {
    id: scrollbar
    border { top: 2; left: 2; right: 2; bottom: 2 }
    source: ":/mobile/scrollbar/bg_image"
    property Flickable list

    BorderImage {
        id: bullet
        property int offset: 20
        property int maximumY: scrollbar.height - bullet.height - 2*offset
        border { top: 2; left: 2; right: 2; bottom: 2 }
        source: ":/mobile/scrollbar/bullet"
        height: 40
        y: Math.max(0.0, Math.min(1.0,(list.contentY / (list.contentHeight - list.height)))) * maximumY + offset
    }
}
