import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15

Rectangle {
    id: _root
    property string text: ""
    property int boundsMovement: Flickable.StopAtBounds
    property int boundsBehavior: Flickable.DragAndOvershootBounds
    property var verticalScrollBar: ScrollBar {}
    property var horizontalScrollBar: ScrollBar {}

    Flickable {
        anchors.fill: parent
        contentHeight: _replyText.implicitHeight
        contentWidth: _replyText.implicitWidth
        clip: true

        boundsMovement: _root.boundsMovement
        boundsBehavior: _root.boundsMovement
        Text {
            id: _replyText
            padding: 15
            horizontalAlignment: Text.AlignLeft
            wrapMode: Text.WrapAnywhere
            text: _root.text
        }

        ScrollBar.vertical: {
            _root.verticalScrollBar
        }
        ScrollBar.horizontal: {
            _root.horizontalScrollBar
        }
    }
}
