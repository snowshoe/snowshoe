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
