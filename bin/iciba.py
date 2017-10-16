#!/usr/bin/env python

import bs4
import urllib2
import sys

BASE_URL = 'http://open.iciba.com/huaci/dict.php?word='


def dig(word):
    quote = urllib2.quote(word)
    html = urllib2.urlopen(BASE_URL + quote).readlines()
    soup = bs4.BeautifulSoup(''.join(html), "html.parser")
    found = False
    for div in soup.findAll('div', {'class': '\\"icIBahyI-group_pos\\"'}):
        for p in div.findAll('p'):
            print(p.get_text().encode('utf8'))
            found = True

    if not found:
        print("I can't dig \033[31m{0}\033[0m in iciba.".format(word))


if __name__ == '__main__':
    dig(' '.join(sys.argv[1:]))
