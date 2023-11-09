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
