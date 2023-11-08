from feeluown.app import App


__alias__ = 'New UI'
__version__ = '0.1.dev0'
__desc__ = ''

from fuo_new_ui.qml_app import QmlApp


def enable(app: App):
    if app.config.mode & App.GuiMode:
        app = QmlApp()


def disable(app: App):
    pass
