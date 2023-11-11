import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material

ToolTip {
    property string tipText

    id: control
    text: qsTr(tipText)

    contentItem: Text {
        text: control.text
        font: control.font
        color: Material.color(Material.Grey)
    }

    background: Rectangle {
        color: "#80000000"
    }

    delay: 200
    timeout: 1500
}