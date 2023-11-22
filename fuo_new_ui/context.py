import asyncio
import datetime

from PySide6.QtCore import QObject, Property, Signal, Slot

from fuo_new_ui import const
from fuo_new_ui.api import FuoApi


class PlayerContext(QObject):
    status_change = Signal()
    song_change = Signal()

    def __init__(self):
        super().__init__()
        self._api = FuoApi(self)
        self._status = None
        self._current_song = None

    @Property(dict, constant=True)
    def const(self):
        consts = {}
        for attr in [item for item in dir(const) if not item.startswith("__")]:
            consts[attr] = getattr(const, attr)
        return consts

    @Property(dict, notify=status_change)
    def status(self):
        if self._status is None:
            self._api.status()
        return self._status

    @status.setter
    def status(self, value):
        self._status = value
        self.status_change.emit()

    @Property(dict, notify=song_change)
    def current_song(self):
        if self._current_song is None:
            self._api.current_song_info()
        return self._current_song

    @current_song.setter
    def current_song(self, value):
        self._current_song = value
        self.song_change.emit()

    @Slot()
    def updateState(self):
        self._api.status()

    @Slot()
    def updateSongInfo(self):
        self._api.current_song_info()

    @Slot()
    def pause(self):
        self._api.pause()

    @Slot()
    def resume(self):
        self._api.resume()

    @Slot()
    def next(self):
        self._api.next()

    @Slot()
    def prev(self):
        self._api.previous()

    @Slot(str)
    def shuffle(self, mode):
        self._api.shuffle_mode(mode)
        self.updateState()
