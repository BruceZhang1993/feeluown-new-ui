import Qt.labs.platform

SystemTrayIcon {
    id: appTray
    visible: config ? config.trayEnable : false
    icon.name: "feeluown"
    tooltip: "FeelUOwn"

    menu: Menu {
        MenuItem {
            text: qsTr("Settings")
            onTriggered: settingDialog.show()
        }
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
