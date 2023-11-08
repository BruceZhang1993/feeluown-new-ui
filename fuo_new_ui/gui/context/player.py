from PyQt5.QtCore import QObject, pyqtProperty, pyqtSignal, pyqtSlot, QVariant
from feeluown.app import App


class PlayerContext(QObject):
    state_changed = pyqtSignal()
    duration_changed = pyqtSignal()
    position_changed = pyqtSignal()
    metadata_changed = pyqtSignal()

    def __init__(self, app):
        super().__init__()
        self._app: App = app
        self._app.player.state_changed.connect(self.on_state_change)
        self._app.player.duration_changed.connect(self.on_duration_change)
        self._app.player.position_changed.connect(self.on_position_change)
        self._app.player.metadata_changed.connect(lambda _: self.metadata_changed.emit())
        self._app.player.media_changed.connect(lambda: self.metadata_changed.emit())

    @pyqtProperty(int, notify=position_changed)
    def position(self) -> int:
        return int(self._app.player.position)

    @pyqtProperty(int, notify=duration_changed)
    def duration(self) -> int:
        return int(self._app.player.duration)

    @pyqtProperty(int, notify=state_changed)
    def state(self):
        return self._app.player.state

    @pyqtProperty(str, notify=metadata_changed)
    def title(self) -> str:
        return self._app.player.current_metadata.get('title', '')

    @pyqtSlot()
    def toggle(self):
        self._app.player.toggle()

    def on_state_change(self, _):
        self.state_changed.emit()

    def on_duration_change(self, _):
        self.metadata_changed.emit()
        self.duration_changed.emit()

    def on_position_change(self, _):
        self.position_changed.emit()
