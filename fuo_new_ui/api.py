from typing import Optional

import requests


class FuoApi:
    BASE_URI = 'http://127.0.0.1:23332'
    id = 0

    def __init__(self, context):
        self._context = context
        self._session = requests.Session()

    @staticmethod
    def _build_payload(method: str, params: Optional[list]):
        FuoApi.id += 1
        return {
            "method": method,
            "params": params,
            "jsonrpc": "2.0",
            "id": FuoApi.id,
        }

    def status(self):
        with self._session.get(self.BASE_URI + '/api/v1/status') as r:
            data = r.json()['data']
            print(data)
            self._context.status = data
        return

    def next(self):
        with self._session.post(self.BASE_URI + '/rpc/v1', json=self._build_payload('app.playlist.next', None)) as r:
            print(r.json())
            return

    def previous(self):
        with self._session.post(self.BASE_URI + '/rpc/v1',
                                json=self._build_payload('app.playlist.previous', None)) as r:
            print(r.json())
            return

    def pause(self):
        with self._session.post(self.BASE_URI + '/rpc/v1', json=self._build_payload('app.player.pause', None)) as r:
            print(r.json())
            return

    def resume(self):
        with self._session.post(self.BASE_URI + '/rpc/v1', json=self._build_payload('app.player.resume', None)) as r:
            print(r.json())
            return

    def shuffle_mode(self, mode: str):
        """ mode: off/songs """
        print(mode)
        with self._session.post(self.BASE_URI + '/rpc/v1',
                                json=self._build_payload('lambda mode: setattr(app.playlist, "shuffle_mode", mode)', [mode])) as r:
            print(r.json())
            return


if __name__ == '__main__':
    FuoApi(None).next()
