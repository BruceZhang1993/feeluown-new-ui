import asyncio
import signal
import sys

import qasync

from fuo_new_ui.app import FuoApp

if __name__ == '__main__':
    try:
        app = FuoApp()
        qasync.run(app.run())
    except asyncio.exceptions.CancelledError:
        sys.exit(0)
