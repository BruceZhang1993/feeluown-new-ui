import asyncio
import sys

import qasync

from fuo_new_ui.app import FuoApp

if __name__ == '__main__':
    try:
        qasync.run(FuoApp().run())
    except asyncio.exceptions.CancelledError:
        sys.exit(0)
