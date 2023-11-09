import asyncio
import sys
from asyncio import Task
from typing import Optional

from feeluown.entry_points.run_app import before_start_app, start_app


class FuoDaemon:
    def __init__(self):
        self._task: Optional[Task] = None
        sys.argv.append('-nw')
        from feeluown.argparser import create_cli_parser
        args = create_cli_parser().parse_args()
        self._arg, self._config = before_start_app(args)

    async def run(self):
        await start_app(self._arg, self._config)
