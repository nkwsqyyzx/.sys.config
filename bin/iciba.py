#!/usr/bin/env python3

import bs4
import requests
import sys
import urllib

BASE_URL = 'http://open.iciba.com/huaci/dict.php?word='


def dig(word):
    quote = urllib.parse.quote(word)
    html = requests.get(BASE_URL + quote).text
    soup = bs4.BeautifulSoup(html, "html.parser")
    found = False
    for div in soup.findAll('div', {'class': '\\"icIBahyI-group_pos\\"'}):
        for p in div.findAll('p'):
            print(p.get_text())
            found = True

    if not found:
        print("I can't dig \033[31m{0}\033[0m in iciba.".format(word))


if __name__ == '__main__':
    dig(' '.join(sys.argv[1:]))
