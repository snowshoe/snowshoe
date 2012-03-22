import QtQuick 2.0

Image {
    z: 1
    property bool active: true

    source: active ? ":/mobile/pagination_active" : ":/mobile/pagination_inactive"
}
