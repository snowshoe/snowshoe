import QtQuick 2.0

Item {
    id: swipeArea

    property int swipeLength: 50

    signal swipeRight()
    signal swipeLeft()
    signal clicked()

    MouseArea {
        property int lastX
        property int lastY

        anchors.fill: parent

        onPressed: {
            lastX = mouse.x;
            lastY = mouse.y;
        }

        onReleased: {
            var horizontalDelta = mouse.x - lastX;
            var verticalDelta = mouse.y - lastY;
            var swipeLength = swipeArea.swipeLength;

            if (Math.abs(horizontalDelta) < swipeLength) {
                if (Math.abs(verticalDelta) < swipeLength)
                    swipeArea.clicked();
                return;
            }

            if (horizontalDelta > 0)
                swipeArea.swipeRight();
            else
                swipeArea.swipeLeft();
        }
    }
}
