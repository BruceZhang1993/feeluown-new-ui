from pydantic import BaseModel


class BaseConfig(BaseModel):
    pass


class GuiConfig(BaseConfig):
    # 是否启用系统托盘 默认启用
    tray_enable: bool = True


CONFIG_TYPE_MAP = {
    'gui': GuiConfig
}