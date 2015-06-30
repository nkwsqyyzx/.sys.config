#!/usr/bin/python
# -*- coding: utf-8 -*-

import urllib2
from bs4 import BeautifulSoup
import sys
from cache import HtmlCache

cache = HtmlCache('/tmp/')

def get(code):
    url = 'http://f10.eastmoney.com/f10_v2/ShareholderResearch.aspx?code=sh' + code
    content = cache.getContent(url, timeout = 60*60*24*12)[0]
    soup = BeautifulSoup(content)
    rate = soup.find('div', attrs={'id':'TTCS_Table_Div', 'class':'content first'}).find('table').findAll('tr')[-1].findAll('td')[-3].getText()
    rate = float(rate.split('%')[0]) / 100.0
    return 1.0/(1.0 - rate)

if __name__=='__main__':
    print(get(','.join(sys.argv[1:])))

