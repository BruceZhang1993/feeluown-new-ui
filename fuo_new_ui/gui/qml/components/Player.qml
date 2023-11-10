import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15
import QtQuick.Controls.Material 2.15
import QtQml
import Qt5Compat.GraphicalEffects

ColumnLayout {
    id: playerMain
    Layout.fillWidth: true
    Layout.preferredHeight: 80
    Layout.maximumHeight: 95
    spacing: 0

    property var playState: player ? player.status.state : null
    property var shuffle: player ? player.status.random : false
    property var repeat: player ? player.status.repeat : false
    property var cover: "../../../asset/image/cover.png"

    Item {
        Layout.fillHeight: true
        Layout.fillWidth: true

        GaussianBlur {
            anchors.fill: blurCover
            source: blurCover
            radius: 100
            samples: 201
            z: -98
            cached: true
        }

        Image {
            id: blurCover
            anchors.fill: parent
            source: playerMain.cover
            fillMode: Image.PreserveAspectCrop
            opacity: 0.7
            smooth: true
            visible: false
            z: -99
        }

        RowLayout {
            anchors.fill: parent
            spacing: 10

            Image {
                source: playerMain.cover
                fillMode: Image.PreserveAspectCrop
                Layout.preferredHeight: hoverHandler.hovered ? 80 : 90
                Layout.preferredWidth: hoverHandler.hovered ? 80 : 90

                Behavior on Layout.preferredHeight {
                    NumberAnimation { duration: 400 }
                }
                Behavior on Layout.preferredWidth {
                    NumberAnimation { duration: 400 }
                }
            }

            ColumnLayout {
                Layout.fillHeight: true
                Layout.preferredWidth: 100
                spacing: 3
                Layout.alignment: Qt.AlignTop

                Text {
                    font.pointSize: 12
                    topPadding: 4
                    text: player ? player.status.song.title : ""
                    font.bold: true
                    color: Material.color(Material.BlueGrey)
                }

                Text {
                    text: player ? player.status.song.artists_name : ""
                }

                Text {
                    bottomPadding: 4
                    Layout.fillHeight: true
                    verticalAlignment: Text.AlignBottom
                    text: player ? player.status.song.album_name : ""
                    color: Material.color(Material.Grey)
                }
            }

            Rectangle {
                Layout.fillWidth: true
                Layout.fillHeight: true
                color: "transparent"

                Text {
                    function formatDate(timestamp) {
                        var dateObj = new Date(timestamp * 1000);
                        var hours = dateObj.getUTCHours();
                        var minutes = dateObj.getUTCMinutes();
                        var seconds = dateObj.getSeconds();

                        return hours.toString().padStart(2, '0') + ':' +
                        minutes.toString().padStart(2, '0') + ':' +
                        seconds.toString().padStart(2, '0');
                    }

                    anchors.bottom: parent.bottom
                    anchors.right: parent.right
                    text: formatDate(progressBar.value) + " / " + formatDate(progressBar.to)
                    verticalAlignment: Text.AlignBottom
                    horizontalAlignment: Text.AlignRight
                    padding: 4
                    anchors.rightMargin: 4
                    color: Material.color(Material.Grey)
                }
            }

            RoundButton {
                flat: true
                icon.source: "../../../asset/icon/prev.svg"
                icon.color: Material.color(Material.Grey)
                icon.width: 30
                icon.height: 30
                onClicked: player.prev()
            }

            RoundButton {
                flat: true
                icon.source: "../../../asset/icon/" + (playState ? playerMain.playState : "stopped") + ".svg"
                icon.color: Material.color(Material.Grey)
                icon.width: 40
                icon.height: 40
                onClicked: player.toggle()
            }

            RoundButton {
                flat: true
                icon.source: "../../../asset/icon/next.svg"
                icon.color: Material.color(Material.Grey)
                icon.width: 30
                icon.height: 30
                onClicked: player.next()
            }

            RoundButton {
                flat: true
                checkable: true
                checked: playerMain.shuffle
                icon.source: "../../../asset/icon/shuffle.svg"
                icon.color: Material.color(Material.Grey)
                icon.width: 26
                icon.height: 26
                onClicked: player.shuffle()
            }

            RoundButton {
                flat: true
                checkable: true
                checked: playerMain.repeat
                icon.source: "../../../asset/icon/repeat.svg"
                icon.color: Material.color(Material.Grey)
                icon.width: 26
                icon.height: 26
                onClicked: player.repeat()
            }

            RowLayout {
                id: volumeSlider
                Layout.fillHeight: true
                Layout.alignment: Qt.AlignRight
                Layout.rightMargin: 10

                RoundButton {
                    flat: true
                    icon.source: "../../../asset/icon/volume.svg"
                    icon.color: Material.color(Material.Grey)
                    icon.width: 30
                    icon.height: 30
                    onClicked: player.silent()
                }

                Slider {
                    Layout.preferredWidth: volumeHover.hovered ? 160 : 0
                    Layout.alignment: Qt.AlignRight
                    from: 0
                    value: player ? player.status.volume : 0
                    to: 100
                    handle: null

                    Behavior on Layout.preferredWidth {
                        NumberAnimation { duration: 400 }
                    }
                }

                HoverHandler {
                    id: volumeHover
                }
            }
        }
    }

    ProgressBar {
        id: progressBar
        from: 0
        to: player ? player.status.duration : 1
        value: player ? player.status.position : 0
        Layout.fillWidth: true
        Layout.preferredHeight: hoverHandler.hovered ? 15 : 5;

        Timer {
            interval: 1000
            running: playerMain.playState == "playing"
            repeat: true
            onTriggered: progressBar.value += 1
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
                color: playerMain.playState == "playing" ? Material.accent : Material.color(Material.Grey)

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