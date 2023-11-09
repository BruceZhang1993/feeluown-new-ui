import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15
import QtQuick.Controls.Material 2.15
import QtWebSockets 1.6
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
                color: Material.primary
                Layout.fillHeight: true
                Layout.preferredWidth: 200
            }

            Rectangle {
                Layout.fillHeight: true
                Layout.fillWidth: true
            }
        }

        Rectangle {
            color: "transparent"
            Layout.fillWidth: true
            Layout.preferredHeight: 25

            Text {
                id: innerLyric
                anchors.horizontalCenter: parent.horizontalCenter
                text: player ? player.status["lyric-s"] : ""
                horizontalAlignment: Text.AlignCenter
            }
        }

        Player {}
    }

    WebSocket {
        id: ws
        active: true
        url: "ws://127.0.0.1:23332/signal/v1"

        onStatusChanged: (status) => {
            console.log(status)
            if (status == WebSocket.Open) {
                player.updateStatus()
            }
        }

        onTextMessageReceived: (msg) => {
            console.log(msg)
            var object = JSON.parse(msg);
            if (object.topic == "player.state_changed") {
                player.updateState()
            } else if (object.topic == "live_lyric") {
                innerLyric.text = object.data
            }
        }
    }

    Timer {
        id: timer
        repeat: true
        interval: 5000
        running: ws.status == WebSocket.Error
        onTriggered: {
            var url = ws.url
            ws.url = ""
            ws.url = url
        }
    }
}
