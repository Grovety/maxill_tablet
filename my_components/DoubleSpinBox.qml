import QtQuick 2.15
import QtQuick.Controls 2.15

Item {
    property int decimals: 2
    property real realValue: 0.0
    property real realFrom: 0.0
    property real realTo: 100.0
    property real realStepSize: 1.0
    property bool editable: false

    SpinBox{
        property real factor: Math.pow(10, decimals)
        width: parent.width
        height: parent.height
        id: spinbox
        stepSize: realStepSize*factor
        value: realValue*factor
        to : realTo*factor
        from : realFrom*factor
        editable: parent.editable
        validator: DoubleValidator {
            bottom: Math.min(spinbox.from, spinbox.to)*spinbox.factor
            top:  Math.max(spinbox.from, spinbox.to)*spinbox.factor
        }

        textFromValue: function(value, locale) {
            return parseFloat(value*1.0/factor).toFixed(decimals);
        }
        onFocusChanged: {
            console.debug("here")
        }
    }
}
