import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15

Flickable {
    id: _root
    property string text: ""
    property enumeration boundsMovement: Flickable.StopAtBounds
    property enumeration boundsBehavior: Flickable.DragAndOvershootBounds


    Flickable {
        anchors.fill: parent
        contentHeight: _replyText.implicitWidth
        contentWidth: _replyText.implicitWidth
        clip: true

        boundsMovement: boundsMovement
        boundsBehavior: boundsBehavior
        Text {
            id: _replyText
            padding: 15
            horizontalAlignment: Text.AlignLeft
            wrapMode: Text.NoWrap
            text: _root.text
        }
    }
}
