import QtQuick 2.0

Image {
    z: 1
    property bool active: true

    source: active ? ":/mobile/tabs/pagination_active" : ":/mobile/tabs/pagination_inactive"
}
