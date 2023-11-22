import QtQuick
import QtQuick.Window
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQml
import Qt5Compat.GraphicalEffects
import "."

ColumnLayout {
    id: playerFull
    visible: false
    anchors.fill: parent
    spacing: 0
    z: 100

    property var playState: player ? player.status.state : null
    property var shuffle: player ? player.status.random : false
    property var repeat: player ? player.status.repeat : false
    property var cover: player ? (player.current_song.artwork ? player.current_song.artwork : "../../../asset/image/cover.png") : "../../../asset/image/cover.png"
    property var songProvider: player ? player.status.song.provider : ""
    property var offsetY: height

    transform: Translate {
        id: playerFullTranslate
        y: offsetY

        Behavior on y {
            SmoothedAnimation {
                duration: 500
                onRunningChanged: {
                    if (!running && playerFullTranslate.y > 0) {
                        playerFull.visible = false
                    }
                }
            }
        }
    }

    function updateImageSize() {
        blurCoverFull.height = blurCoverFull.parent.height
        blurCoverFull.width = blurCoverFull.parent.width
    }

    Item {
        Layout.fillHeight: true
        Layout.fillWidth: true

        GaussianBlur {
            anchors.fill: blurCoverFull
            source: blurCoverFull
            radius: 200
            samples: 401
            z: -97
            cached: true
        }

        Image {
            id: blurCoverFull
            width: 0
            height: 0
            source: playerFull.cover
            fillMode: Image.PreserveAspectCrop
            smooth: true
            visible: false
            sourceSize.width: 100
            sourceSize.height: 100
            z: -99
        }

        ColumnLayout {
            anchors.fill: parent
            spacing: 10

            RowLayout {
                Layout.alignment: Qt.AlignRight
                spacing: 3

                RoundButton {
                    flat: true
                    icon.width: 20
                    icon.height: 20
                    icon.source: "../../../asset/icon/mv.svg"
                    icon.color: Material.color(Material.Grey)
                    AppToolTip { tipText: "MV"; visible: parent.hovered; }
                }

                RoundButton {
                    flat: true
                    icon.width: 20
                    icon.height: 20
                    icon.source: "../../../asset/icon/lrc.svg"
                    icon.color: Material.color(Material.Grey)
                    AppToolTip { tipText: "Lyrics"; visible: parent.hovered; }
                }

                RoundButton {
                    flat: true
                    onClicked: playerFull.offsetY = playerFull.height
                    icon.width: 20
                    icon.height: 20
                    icon.color: Material.color(Material.Grey)
                    icon.source: "../../../asset/icon/arrow-down.svg"
                }
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

                Label {
                    Layout.alignment: Qt.AlignHCenter
                    text: songProvider
                    font.pointSize: 9
                    color: "#f0f0f0"
                    leftPadding: 4
                    rightPadding: 4
                    verticalAlignment: Text.AlignBottom
                    bottomPadding: 2

                    background: Rectangle {
                        color: Material.color(Material.BlueGrey)
                        radius: 4
                    }
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
                    AppToolTip { tipText: "Prev"; visible: parent.hovered; }
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
                    AppToolTip {
                        id: playTip
                        tipText: playState == "playing" ? "Pause" : "Play"
                        visible: parent.hovered
                    }
                }

                RoundButton {
                    flat: true
                    icon.source: "../../../asset/icon/next.svg"
                    icon.color: Material.color(Material.Grey)
                    icon.width: 40
                    icon.height: 40
                    onClicked: player.next()
                    AppToolTip { tipText: "Next"; visible: parent.hovered; }
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
                    onClicked: player.shuffle(playerFull.shuffle ? "off" : "songs")
                    AppToolTip { tipText: "Shuffle"; visible: parent.hovered; }
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
                    AppToolTip { tipText: "Repeat"; visible: parent.hovered; }
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

                        AppToolTip {
                            tipText: "Volume"
                            visible: parent.hovered
                        }
                    }

                    Slider {
                        id: volumeSlideItem
                        Layout.preferredWidth: volumeHoverFull.hovered ? 160 : 0
                        Layout.alignment: Qt.AlignRight
                        from: 0
                        value: player ? player.status.volume : 0
                        to: 100
                        handle: null

                        Behavior on Layout.preferredWidth {
                            SmoothedAnimation { duration: 400 }
                        }

                        AppToolTip {
                            tipText: parseInt(parent.value)
                            timeout: 1800
                            visible: parent.pressed
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