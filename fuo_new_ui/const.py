import sys
from pathlib import Path

APP_NAME = 'FeelUOwn'
APP_CONFIG_DIR = APP_CONFIG_FILE = Path.home() / '.config' / 'FeelUOwn'
IS_WINDOWS = sys.platform in ('win32', 'cgywin')
