import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15
import QtQuick.Controls.Material 2.15
import "./components"

ApplicationWindow {
    id: window
    visible: true
    width: Screen.width / 1.8
    height: Screen.height / 1.5
    title: "FeelUOwn"

    property bool darkMode: systemPalette.windowText.hsvValue > systemPalette.window.hsvValue
    Material.theme: darkMode ? Material.Dark : Material.Light

    SystemPalette {
        id: systemPalette
    }

    Tray {}

    ColumnLayout {
        spacing: 0
        anchors.fill: parent

        RowLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true

            Rectangle {
                color: "blue"
                Layout.fillHeight: true
                Layout.preferredWidth: 200
            }

            Rectangle {
                Layout.fillHeight: true
                Layout.fillWidth: true
            }
        }

        Player {}
    }
}
