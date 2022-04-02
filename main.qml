import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import MainWindow 1.0
import QtQuick.Layouts 1.3
import QtQuick.Dialogs 1.3
import "my_components" as MyComponents

ApplicationWindow {
    visible: true
    title: qsTr("Maxill Tablet app")

    minimumHeight: 900
    minimumWidth: 1500
    maximumWidth: minimumWidth
    maximumHeight: minimumHeight

    MainWindow {
        id: _backend
        Component.onCompleted: {
            refreshComPorts();
        }
    }

    Rectangle{
        id: _mainBackGround
        z: -100
        anchors.fill: parent
        color: "lightsteelblue"
    }

    Label {
        id: _responseLabel
        text: "Response"
        font.pointSize: 20
        anchors.top: _comPortRow.bottom
        anchors.topMargin: 10
        anchors.horizontalCenter: _responseField.horizontalCenter
    }

    Label {
        id: _requestLabel
        text: "Request"
        font.pointSize: 20
        anchors.top: _comPortRow.bottom
        anchors.topMargin: 10
        anchors.horizontalCenter: _requestField.horizontalCenter
    }

    MyComponents.FlickableText {
        id: _requestField
        anchors {
            top: _requestLabel.bottom
            topMargin: 25
            bottom: parent.bottom
            bottomMargin: 10
            right: _responseField.left
            rightMargin: 10
        }
        color: "cornsilk"
        border.width: 2
        border.color: "black"
        width: 350
        radius: 5
        text:_backend.requestString

        horizontalScrollBar: ScrollBar {
            policy: ScrollBar.AsNeeded
        }

        verticalScrollBar: ScrollBar {
            policy: ScrollBar.AsNeeded
        }
    }

    MyComponents.FlickableText {
        id: _responseField
        anchors {
            top: _responseLabel.bottom
            topMargin: 25
            bottom: parent.bottom
            bottomMargin: 10
            right: parent.right
            rightMargin: 10
        }
        color: "gainsboro"
        border.width: 2
        border.color: "black"
        width: 350
        radius: 5
        text: _backend.responseString

        horizontalScrollBar: ScrollBar {
            policy: ScrollBar.AsNeeded
        }

        verticalScrollBar: ScrollBar {
            policy: ScrollBar.AsNeeded
        }
    }

    BusyIndicator {
        anchors.centerIn: _responseField
        running: true;
        visible: _backend.replyWaiting
    }


    ColumnLayout {
        id: _requestColumn
        spacing: 10
        anchors.top: parent.top
        anchors.topMargin: 10
        anchors.left: parent.left
        anchors.leftMargin: 15
        width: 700

        Rectangle {
            border.width: 1
            border.color:  "black"
            Layout.preferredHeight: 70
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignLeft
            color: "honeydew"
            radius: 5
            Label {
                anchors.left: parent.left
                anchors.leftMargin: 15
                anchors.verticalCenter: parent.verticalCenter
                text: "Get wells status"
                font.pointSize: 20
            }

            Button {
                anchors.right: parent.right
                anchors.rightMargin: 15
                anchors.verticalCenter: parent.verticalCenter
                width: 150
                height: 40
                text: "send"
                font.pointSize: 15
                background: Rectangle {
                    anchors.fill: parent
                    radius: 5
                    color: parent.pressed ? "greenyellow" : "Lime"
                }
                onClicked: {
                    _backend.sendRequestGetWellStatus();
                }
            }
        }

        Rectangle {
            border.width: 1
            border.color:  "black"
            Layout.preferredHeight: 70
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignLeft
            color: "honeydew"
            radius: 5
            Label {
                anchors.left: parent.left
                anchors.leftMargin: 15
                anchors.verticalCenter: parent.verticalCenter
                text: "Get UCID list"
                font.pointSize: 20
            }

            Button {
                anchors.right: parent.right
                anchors.rightMargin: 15
                anchors.verticalCenter: parent.verticalCenter
                width: 150
                height: 40
                text: "send"
                font.pointSize: 15
                background: Rectangle {
                    anchors.fill: parent
                    radius: 5
                    color: parent.pressed ? "greenyellow" : "Lime"
                }
                onClicked: {
                    _backend.sendRequestGetUcidList();
                }
            }
        }

        Rectangle {
            border.width: 1
            border.color:  "black"
            Layout.preferredHeight: 130
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignLeft
            color: "honeydew"
            radius: 5

            Label {
                anchors.left: parent.left
                anchors.leftMargin: 15
                anchors.top: parent.top
                anchors.topMargin: 15
                text: "Get sterilization result"
                font.pointSize: 20
            }

            Button {
                anchors.right: parent.right
                anchors.rightMargin: 15
                anchors.top: parent.top
                anchors.topMargin: 15
                width: 150
                height: 40
                text: "send"
                font.pointSize: 15
                background: Rectangle {
                    anchors.fill: parent
                    radius: 5
                    color: parent.pressed ? "greenyellow" : "Lime"
                }
                onClicked: {
                    _backend.sendRequestGetResult(_ucidGetResult.text)
                }
            }

            RowLayout {
                anchors.left: parent.left
                anchors.leftMargin: 15
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 15
                spacing: 10
                Label {
                    text: "UCID:"
                }
                TextInput {
                    id: _ucidGetResult
                    Layout.preferredHeight: 30
                    Layout.preferredWidth: 250
                    verticalAlignment: Qt.AlignVCenter
                    padding: 5
                    Rectangle {
                        anchors.fill: parent
                        color: "transparent"
                        border.width: parent.focus ? 2 : 1
                        border.color: parent.focus ? "blue" : "black"
                    }
                }
            }
        }

        Rectangle {
            border.width: 1
            border.color:  "black"
            Layout.preferredHeight: 130
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignLeft
            color: "honeydew"
            radius: 5

            Label {
                anchors.left: parent.left
                anchors.leftMargin: 15
                anchors.top: parent.top
                anchors.topMargin: 15
                text: "Get raw data"
                font.pointSize: 20
            }

            Button {
                anchors.right: parent.right
                anchors.rightMargin: 15
                anchors.top: parent.top
                anchors.topMargin: 15
                width: 150
                height: 40
                text: "send"
                font.pointSize: 15
                background: Rectangle {
                    anchors.fill: parent
                    radius: 5
                    color: parent.pressed ? "greenyellow" : "Lime"
                }
                onClicked: {
                    _backend.sendRequestGetRawData(_ucidGetRawData.text)
                }
            }

            RowLayout {
                anchors.left: parent.left
                anchors.leftMargin: 15
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 15
                spacing: 10
                Label {
                    text: "UCID:"
                }
                TextInput {
                    id: _ucidGetRawData
                    Layout.preferredHeight: 30
                    Layout.preferredWidth: 250
                    verticalAlignment: Qt.AlignVCenter
                    padding: 5
                    Rectangle {
                        anchors.fill: parent
                        color: "transparent"
                        border.width: parent.focus ? 2 : 1
                        border.color: parent.focus ? "blue" : "black"
                    }
                }
            }
        }

        Rectangle {
            border.width: 1
            border.color:  "black"
            Layout.preferredHeight: 130
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignLeft
            color: "honeydew"
            radius: 5

            Label {
                anchors.left: parent.left
                anchors.leftMargin: 15
                anchors.top: parent.top
                anchors.topMargin: 15
                text: "Flash data logger"
                font.pointSize: 20
            }

            Button {
                anchors.right: parent.right
                anchors.rightMargin: 15
                anchors.top: parent.top
                anchors.topMargin: 15
                width: 150
                height: 40
                text: "send"
                font.pointSize: 15
                background: Rectangle {
                    anchors.fill: parent
                    radius: 5
                    color: parent.pressed ? "greenyellow" : "Lime"
                }
                onClicked: {
                    _backend.sendRequestFlashDataLogger(_wellComboBox.currentText, _fileNameLabel.text)
                }
            }

            RowLayout {
                anchors.left: parent.left
                anchors.leftMargin: 15
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 15
                spacing: 10
                Label {
                    text: "well:"
                }
                ComboBox {
                    id: _wellComboBox
                    Layout.preferredHeight: 30
                    model: ["well_1", "well_2", "well_3", "well_4"]
                }
            }

            RowLayout {
                anchors.right: parent.right
                anchors.rightMargin: 15
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 15
                spacing: 10
                Label {
                    text: "file:"
                }

                Label {
                    id: _fileNameLabel
                    text: "not chosen"
                }
                Button {
                    text: "Browse..."
                    Layout.preferredHeight: 30
                    background: Rectangle {
                        anchors.fill: parent
                        radius: 5
                        color: parent.pressed ? "darkorange" : "orange"
                    }

                    onClicked: {
                        fileDialog.open()
                    }
                }

                FileDialog {
                    id: fileDialog
                    title: "Please choose a file"
                    folder: shortcuts.home
                    selectMultiple: false
                    selectExisting: true

                    onAccepted: {
                        var path = fileDialog.fileUrl.toString();
                        path = path.replace(/^(file:\/{3})/,"");
                        var cleanPath = decodeURIComponent(path);
                        console.log("You chose: " + cleanPath)
                        _fileNameLabel.text = cleanPath;
                    }
                    onRejected: {

                    }
                }
            }
        }

        Rectangle {
            border.width: 1
            border.color:  "black"
            Layout.preferredHeight: 300
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignLeft
            color: "honeydew"
            radius: 5

            Label {
                anchors.left: parent.left
                anchors.leftMargin: 15
                anchors.top: parent.top
                anchors.topMargin: 15
                text: "Setup data logger"
                font.pointSize: 20
            }

            Button {
                anchors.right: parent.right
                anchors.rightMargin: 15
                anchors.top: parent.top
                anchors.topMargin: 15
                width: 150
                height: 40
                text: "send"
                font.pointSize: 15
                background: Rectangle {
                    anchors.fill: parent
                    radius: 5
                    color: parent.pressed ? "greenyellow" : "Lime"
                }
                onClicked: {
                    _backend.sendRequestSetupDataLogger(
                        _wellSetupBox.currentText, _samplePeriod.currentValue, _startTemperature.value, _startPressure.realValue(), _confirmationPeriod.value, Date.now() / 1000 | 0,
                        _targetTemperature.value, _targetPressure.realValue(), _criticalTemperature.value, _criticalPressure.realValue(), _targetTime.value, _deviationPeriod.value)
                }
            }

            ColumnLayout {
                anchors.left: parent.left
                anchors.leftMargin: 15
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 15
                RowLayout {
                    spacing: 10
                    Label {

                        text: "well:"
                        Layout.preferredWidth: 100
                    }
                    ComboBox {
                        id: _wellSetupBox
                        Layout.preferredHeight: 30
                        model: ["well_1", "well_2", "well_3", "well_4"]
                    }
                }

                RowLayout {
                    spacing: 10

                    Label {
                        text: "sample period(s):"
                        Layout.preferredWidth: 100
                    }

                    ComboBox {
                        id: _samplePeriod
                        Layout.preferredHeight: 30
                        model: [1, 2, 5, 10, 30, 60, 120, 300]
                    }
                }

                RowLayout {
                    spacing: 10

                    Label {
                        text: "start temperature:"
                        Layout.preferredWidth: 100
                    }

                    SpinBox {
                        id: _startTemperature
                        Layout.preferredHeight: 30
                        from: 50
                        to: 135
                        editable: false
                    }
                }

                RowLayout {
                    spacing: 10

                    Label {
                        text: "start pressure:"
                        Layout.preferredWidth: 100
                    }

                    MyComponents.DoubleSpinBox {
                        id: _startPressure
                        Layout.preferredHeight: 30
                        width: 140
                        decimals: 1
                        realFrom: 0.1
                        realTo: 2.0
                        realStepSize: 0.1
                    }
                }

                RowLayout {
                    spacing: 10

                    Label {
                        text: "confirmation period:"
                        Layout.preferredWidth: 100
                    }

                    SpinBox {
                        id: _confirmationPeriod
                        Layout.preferredHeight: 30
                        from: 1
                        to: 120
                        editable: false
                    }
                }
            }

            ColumnLayout {
                anchors.right: parent.right
                anchors.rightMargin: 15
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 15
                RowLayout {
                    spacing: 10
                    Label {
                        text: "target temperature:"
                        Layout.preferredWidth: 100
                    }
                    SpinBox {
                        id: _targetTemperature
                        Layout.preferredHeight: 30
                        from: 50
                        to: 135
                        editable: false
                    }
                }

                RowLayout {
                    spacing: 10
                    Label {
                        text: "target pressure:"
                        Layout.preferredWidth: 100
                    }
                    MyComponents.DoubleSpinBox {
                        id: _targetPressure
                        Layout.preferredHeight: 30
                        width: 140
                        decimals: 1
                        realFrom: 0.1
                        realTo: 2.0
                        realStepSize: 0.1
                    }
                }

                RowLayout {
                    spacing: 10
                    Label {
                        text: "critical temperature:"
                        Layout.preferredWidth: 100
                    }
                    SpinBox {
                        id: _criticalTemperature
                        Layout.preferredHeight: 30
                        from: 50
                        to: 135
                        editable: false
                    }
                }

                RowLayout {
                    spacing: 10
                    Label {
                        text: "critical pressure:"
                        Layout.preferredWidth: 100
                    }
                    MyComponents.DoubleSpinBox {
                        id: _criticalPressure
                        Layout.preferredHeight: 30
                        width: 140
                        decimals: 1
                        realFrom: 0.1
                        realTo: 2.0
                        realStepSize: 0.1
                    }
                }

                RowLayout {
                    spacing: 10

                    Label {
                        text: "target time (min):"
                        Layout.preferredWidth: 100
                    }

                    SpinBox {
                        id: _targetTime
                        Layout.preferredHeight: 30
                        from: 10
                        to: 60
                        editable: false
                    }
                }
                RowLayout {
                    spacing: 10

                    Label {
                        text: "deviation period (s):"
                        Layout.preferredWidth: 100
                    }

                    SpinBox {
                        id: _deviationPeriod
                        Layout.preferredHeight: 30
                        from: 10
                        to: 300
                        editable: false
                    }
                }
            }
        }
    }

    Rectangle {
        id: _dimmRect
        anchors.fill: parent
        color: "black"
        opacity: 0.8
        visible: !_backend.connected
    }
    Row {
        id: _comPortRow
        anchors {
            margins: 10
            verticalCenterOffset: 40
            verticalCenter: parent.top
            right: parent.right
        }
        spacing: 10
        Label {
            anchors.verticalCenter: parent.verticalCenter
            text: "COM-PORT:"
            color: "white"
            font.bold: true
            font.pixelSize: 15
        }
        ComboBox {
            id: _comPortsList
            width: 100
            height: 30
            model: _backend.comPorts
            enabled: !_backend.connected
        }

        Button {
            id: _connectButton
            width: 100
            height: 30
            text: _backend.connected ? "Connected" : "Connect"
            enabled: !_backend.connected
            onClicked: {
                _backend.connect(_comPortsList.currentText)
            }
        }
    }
}
