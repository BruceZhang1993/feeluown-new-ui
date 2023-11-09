import asyncio
import functools
import signal
import sys
from pathlib import Path
from typing import Optional

from PySide6.QtCore import QDir
from PySide6.QtGui import QPixmap, QIcon
from PySide6.QtQml import QQmlApplicationEngine
from PySide6.QtWidgets import QApplication

from fuo_new_ui import const
from fuo_new_ui.config import ConfigManager
from fuo_new_ui.model.config import GuiConfig


class FuoApp(QApplication):
    def __init__(self):
        super().__init__(sys.argv)
        self._config_manager = None
        self._gui_config: Optional[GuiConfig] = None
        self._engine: Optional[QQmlApplicationEngine] = None
        self.set_search_paths()
        self.set_up_config()
        self.set_up_application()
        self.set_up_engine()

    def set_up_engine(self):
        self._engine = QQmlApplicationEngine()
        self._proxy_config = GuiConfig.QProxy(self._gui_config)
        self._engine.rootContext().setContextProperty('config', self._proxy_config)
        self._engine.quit.connect(self.quit)

    def set_up_config(self):
        self._config_manager = ConfigManager()
        self._gui_config = self._config_manager.get('gui')

    def set_up_application(self):
        self.setWindowIcon(QIcon(QPixmap('icons:feeluown.png')))
        self.setDesktopFileName(const.APP_NAME)
        self.setQuitOnLastWindowClosed(not self._gui_config.tray_enable)
        if const.IS_WINDOWS:
            font = self.font()
            font.setFamilies(['Segoe UI Symbol', 'Microsoft YaHei', 'sans-serif'])
            font.setPixelSize(13)
            self.setFont(font)

    @staticmethod
    def set_search_paths():
        pkg_root_dir = Path(__file__).parent
        icons_dir = pkg_root_dir / 'asset' / 'icon'
        QDir.addSearchPath('icons', icons_dir)

    async def run(self):
        def close_future(future):
            future.cancel()

        future = asyncio.Future()
        self.aboutToQuit.connect(functools.partial(close_future, future))

        pkg_root_dir = Path(__file__).parent
        main_qml = pkg_root_dir / 'gui' / 'qml' / 'main.qml'
        self._engine.load(main_qml)
        return_code = self.exec_()
        await future
        return return_code
