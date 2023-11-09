import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15
import QtQuick.Controls.Material 2.15

ColumnLayout {
    Layout.fillWidth: true
    Layout.preferredHeight: 80
    Layout.maximumHeight: 80
    spacing: 0

    RowLayout {
        Layout.fillHeight: true

        Text {
            text: player ? (player.status.song.title + " -- " + player.status.song.artists_name) : ""
        }

        Button {
            text: player ? (player.status.state) : "--"
            onClicked: player.toggle()
        }

        Slider {
            Layout.alignment: Qt.AlignRight
            from: 0
            value: player ? player.status.volume : 0
            to: 100
        }
    }

    ProgressBar {
        id: progressBar
        from: 0
        to: player ? player.status.duration : 0
        value: player ? player.status.position : 0
        Layout.fillWidth: true
        Layout.preferredHeight: hoverHandler.hovered ? 15 : 4;

        ToolTip {
            visible: hoverHandler.hovered
            text: progressBar.value + " / " + progressBar.to
        }

        Behavior on Layout.preferredHeight {
            NumberAnimation { duration: 400 }
        }

        background: Rectangle {
            implicitHeight: progressBar.height
            color: "transparent"
        }

        contentItem: Item {
            implicitHeight: progressBar.height

            Rectangle {
                id: progressRect
                width: progressBar.visualPosition * parent.width
                height: parent.height
                radius: 2
                color: Material.accent

                Behavior on width {
                    NumberAnimation { duration: 400 }
                }
            }
        }

        HoverHandler {
            id: hoverHandler
        }
    }
}