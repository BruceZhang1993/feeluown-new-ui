import Qt.labs.platform

SystemTrayIcon {
    visible: config ? config.trayEnable : false
    icon.name: "feeluown"
    tooltip: "FeelUOwn"

    menu: Menu {
        MenuItem {
            text: qsTr("Quit")
            onTriggered: Qt.quit()
        }
    }

    onActivated: {
        window.show()
        window.raise()
        window.requestActivate()
    }
}