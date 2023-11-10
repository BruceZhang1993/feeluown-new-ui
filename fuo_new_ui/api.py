import requests


class FuoApi:
    BASE_URI = 'http://127.0.0.1:23332'

    def __init__(self, context):
        self._context = context
        self._session = requests.Session()

    def status(self):
        with self._session.get(self.BASE_URI + '/api/v1/status') as r:
            data = r.json()['data']
            print(data)
            self._context.status = data
        return

    def pause(self):
        with self._session.post(self.BASE_URI + '/api/v1/player/pause') as r:
            print(r.json())
            return

    def resume(self):
        with self._session.post(self.BASE_URI + '/api/v1/player/resume') as r:
            print(r.json())
            return
