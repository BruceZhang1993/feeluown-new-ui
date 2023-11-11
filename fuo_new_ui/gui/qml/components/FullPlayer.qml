import QtQuick
import QtQuick.Window
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQml
import Qt5Compat.GraphicalEffects

ColumnLayout {
    id: playerFull
    visible: true
    anchors.fill: parent
    anchors.topMargin: height
    spacing: 0
    z: 100

    Behavior on anchors.topMargin {
        SmoothedAnimation { duration: 300 }
    }

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
            radius: 200
            samples: 401
            z: -97
            cached: true
        }

        Image {
            id: blurCover
            anchors.fill: parent
            source: playerFull.cover
            fillMode: Image.PreserveAspectCrop
            opacity: 0.7
            smooth: true
            visible: false
            z: -99
        }

        ColumnLayout {
            anchors.fill: parent
            spacing: 10

            RoundButton {
                flat: true
                onClicked: playerFull.anchors.topMargin = playerFull.height
                icon.width: 20
                icon.height: 20
                icon.source: "../../../asset/icon/arrow-down.svg"
                Layout.alignment: Qt.AlignRight
            }

            Image {
                Layout.topMargin: 10
                Layout.alignment: Qt.AlignHCenter
                source: playerFull.cover
                fillMode: Image.PreserveAspectCrop
                Layout.preferredHeight: 220
                Layout.preferredWidth: 220
                smooth: true
                sourceSize.width: 300
                sourceSize.height: 300
            }

            ColumnLayout {
                Layout.topMargin: 30
                Layout.fillWidth: true
                Layout.fillHeight: true
                spacing: 3
                Layout.alignment: Qt.AlignHCenter

                Text {
                    Layout.alignment: Qt.AlignHCenter
                    font.pointSize: 22
                    topPadding: 4
                    text: player ? player.status.song.title : ""
                    font.bold: true
                    color: Material.color(Material.BlueGrey)
                }

                Text {
                    font.pointSize: 16
                    Layout.alignment: Qt.AlignHCenter
                    text: player ? player.status.song.artists_name : ""
                }

                Text {
                    font.pointSize: 16
                    Layout.alignment: Qt.AlignHCenter
                    topPadding: 6
                    text: player ? player.status.song.album_name : ""
                    color: Material.color(Material.Grey)
                }
            }

            RowLayout {
                Layout.fillWidth: true
                spacing: 3
                Layout.alignment: Qt.AlignHCenter | Qt.AlignBottom
                Layout.topMargin: 20

                RoundButton {
                    flat: true
                    icon.source: "../../../asset/icon/prev.svg"
                    icon.color: Material.color(Material.Grey)
                    icon.width: 40
                    icon.height: 40
                    onClicked: player.prev()
                }

                RoundButton {
                    flat: true
                    icon.source: "../../../asset/icon/" + (playState ? playerFull.playState : "stopped") + ".svg"
                    icon.color: Material.color(Material.Grey)
                    icon.width: 50
                    icon.height: 50
                    onClicked: {
                        if (playState == "playing") {
                            player.pause()
                        } else {
                            player.resume()
                        }
                    }
                }

                RoundButton {
                    flat: true
                    icon.source: "../../../asset/icon/next.svg"
                    icon.color: Material.color(Material.Grey)
                    icon.width: 40
                    icon.height: 40
                    onClicked: player.next()
                }
            }

            RowLayout {
                Layout.fillWidth: true
                spacing: 3
                Layout.alignment: Qt.AlignHCenter | Qt.AlignBottom
                Layout.bottomMargin: 30
                Layout.topMargin: 10

                RoundButton {
                    flat: true
                    checkable: true
                    checked: playerFull.shuffle
                    down: playerFull.shuffle
                    icon.source: "../../../asset/icon/shuffle.svg"
                    icon.color: Material.color(Material.Grey)
                    icon.width: 26
                    icon.height: 26
                    onClicked: player.shuffle()
                }

                RoundButton {
                    flat: true
                    checkable: true
                    checked: playerFull.repeat
                    down: playerFull.repeat
                    icon.source: "../../../asset/icon/repeat.svg"
                    icon.color: Material.color(Material.Grey)
                    icon.width: 26
                    icon.height: 26
                    onClicked: player.repeat()
                }

                RowLayout {
                    id: volumeSlider

                    RoundButton {
                        flat: true
                        icon.source: "../../../asset/icon/volume.svg"
                        icon.color: Material.color(Material.Grey)
                        icon.width: 30
                        icon.height: 30
                        onClicked: player.silent()
                    }

                    Slider {
                        Layout.preferredWidth: volumeHoverFull.hovered ? 160 : 0
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
                        id: volumeHoverFull
                        blocking: true
                    }
                }
            }

            Rectangle {
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
        }
    }

    ProgressBar {
        id: progressBar
        from: 0
        to: player ? player.status.duration : 1
        value: player ? player.status.position : 0
        Layout.fillWidth: true
        Layout.preferredHeight: 10;

        Timer {
            interval: 1000
            running: playerFull.playState == "playing"
            repeat: true
            onTriggered: progressBar.value += 1
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
                 color: playerFull.playState == "playing" ? Material.accent : Material.color(Material.Grey)
                gradient: Gradient {
                    orientation: Gradient.Horizontal
                    GradientStop { position: 0.0; color: progressRect.color }
                    GradientStop { position: 0.7; color: progressRect.color }
                    GradientStop { position: 1.0; color: playerFull.playState == "playing" ? Material.color(Material.DeepOrange) : progressRect.color }
                }

                Behavior on width {
                    NumberAnimation { duration: 400 }
                }
            }
        }

        HoverHandler {
            id: hoverHandlerFull
            blocking: true
        }
    }
}