from http.cookiejar import CookieJar
from typing import Optional

import browser_cookie3


class CookieAuth:
    @staticmethod
    def load(domain: str) -> Optional[CookieJar]:
        return browser_cookie3.load(domain_name=domain)


if __name__ == '__main__':
    print(CookieAuth.load("bilibili.com"))
