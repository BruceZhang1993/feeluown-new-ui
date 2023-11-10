import asyncio
import sys

import qasync

from fuo_new_ui.app import FuoApp


def main():
    try:
        app = FuoApp()
        qasync.run(app.run())
    except asyncio.exceptions.CancelledError:
        sys.exit(0)


if __name__ == '__main__':
    main()
