import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15
import QtQuick.Controls.Material 2.15

ApplicationWindow {
    visible: true
    width: Screen.width / 1.8
    height: Screen.height / 1.5
    title: "FeelUOwn"

    property bool darkMode: systemPalette.windowText.hsvValue > systemPalette.window.hsvValue
    Material.theme: darkMode ? Material.Dark : Material.Light

    SystemPalette {
        id: systemPalette
    }

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

        ColumnLayout {
            Layout.fillWidth: true
            Layout.preferredHeight: 80
            Layout.maximumHeight: 80
            spacing: 0

            Text {
                text: player ? player.title : ""
            }

            Button {
                text: "Toggle"
                onClicked: player.toggle()
            }

            ProgressBar {
                id: progressBar
                from: 0
                to: player ? player.duration : 0
                value: player ? player.position : 0
                Layout.fillWidth: true
                Layout.preferredHeight: 4;

                transitions: Transition {
                    NumberAnimation {
                        properties: "Layout.preferredHeight"
                        easing.type: Easing.InOutQuad
                    }
                }

                states: State {
                    name: "hovered"; when: hoverHandler.hovered
                    PropertyChanges { target: progressBar; Layout.preferredHeight: 15; }
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
                        color: "orange"

                        Behavior on width {
                            NumberAnimation { duration: 400 }
                        }
                    }
                }

                HoverHandler {
                    id: hoverHandler
                    acceptedDevices: PointerDevice.Mouse
                }
            }
        }
    }
}
