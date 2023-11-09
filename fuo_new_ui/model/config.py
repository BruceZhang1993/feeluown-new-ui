from PySide6.QtCore import QObject, Property
from pydantic import BaseModel


class BaseConfig(BaseModel):
    pass


class GuiConfig(BaseConfig):
    # 是否启用系统托盘 默认启用
    tray_enable: bool = True

    class QProxy(QObject):
        def __init__(self, obj):
            super().__init__()
            self._obj = obj

        @Property(bool)
        def trayEnable(self) -> bool:
            return self._obj.tray_enable


CONFIG_TYPE_MAP = {
    'gui': GuiConfig
}
