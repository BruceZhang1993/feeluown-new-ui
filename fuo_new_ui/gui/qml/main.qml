import QtCore
import QtQuick
import QtQuick.Window
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Controls.Material
import QtWebSockets
import "./components"

ApplicationWindow {
    id: window
    visible: true
    width: Screen.width / 1.8
    height: Screen.height / 1.5
    title: player ? player.const["APP_NAME"] : ""

    Settings {
        property alias x: window.x
        property alias y: window.y
        property alias width: window.width
        property alias height: window.height
    }

    property bool darkMode: systemPalette.windowText.hsvValue > systemPalette.window.hsvValue
    Material.theme: darkMode ? Material.Dark : Material.Light

    SystemPalette {
        id: systemPalette
    }

    Tray {}

    Setting { id: settingDialog }

    FullPlayer { id: playerFull }

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

        Player { id: playerItem }

        TapHandler {
            target: playerItem
            onTapped: {
                playerFull.visible = true
                playerFull.updateImageSize()
                playerFull.offsetY = 0
            }
        }
    }

    property bool needUpdateFullImage: false

    onWidthChanged: {
        if (playerFull.visible) resizeTimer.running = true
    }

    onHeightChanged: {
        if (playerFull.visible) resizeTimer.running = true
    }

    Timer {
        id: resizeTimer
        repeat: false
        interval: 600
        running: false
        onTriggered: {
            window.needUpdateFullImage = false
            playerFull.updateImageSize()
        }
    }

    WebSocket {
        id: ws
        active: true
        url: "ws://127.0.0.1:23332/signal/v1"

        onStatusChanged: (status) => {
            console.log(status)
            if (status == WebSocket.Open) {
                player.updateState()
            }
        }

        onTextMessageReceived: (msg) => {
            console.log(msg)
            var object = JSON.parse(msg)
            var needUpdateState = ["player.metadata_changed", "player.state_changed", "player.duration_changed", "player.seeked"]
            if (needUpdateState.includes(object.topic)) {
                player.updateState()
            } else if (object.topic == "live_lyric.sentence_changed") {
                var data = JSON.parse(object.data)
                innerLyric.text = data.join(" ")
            } else {
                console.warn("Unhandled event topic: " + object.topic)
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
