from typing import Mapping, Optional

from fuo_new_ui import const
from fuo_new_ui.model.config import BaseConfig, CONFIG_TYPE_MAP


class ConfigManager:
    def __init__(self):
        const.APP_CONFIG_DIR.mkdir(parents=True, exist_ok=True)
        self._config_cache: Mapping[str, BaseConfig] = {}

    @staticmethod
    def _save_config(path, config):
        with path.open('w') as f:
            f.write(config.model_dump_json(indent=2))
            f.flush()

    def _init_config(self, path, cls):
        config = cls()
        self._save_config(path, config)
        return config

    def _load_config(self, type_: str) -> Optional[BaseConfig]:
        path = const.APP_CONFIG_DIR / (type_ + '.json')
        cls = CONFIG_TYPE_MAP.get(type_)
        if cls is None:
            return None
        if not path.exists():
            self._init_config(path, cls)
        return cls.parse_file(path)

    def get(self, type_: str) -> Optional[BaseConfig]:
        config = self._config_cache.get(type_)
        if config is None:
            config = self._load_config(type_)
            self._config_cache[type_] = config
        return config
