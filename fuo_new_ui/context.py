import asyncio
import datetime

from PySide6.QtCore import QObject, Property, Signal, Slot

from fuo_new_ui import const
from fuo_new_ui.api import FuoApi


class PlayerContext(QObject):
    status_change = Signal()

    def __init__(self):
        super().__init__()
        self._api = FuoApi(self)
        self._status = None

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

    @Slot()
    def updateState(self):
        self._api.status()
