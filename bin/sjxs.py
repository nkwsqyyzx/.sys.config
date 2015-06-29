#!/usr/bin/python
# -*- coding: utf-8 -*-

import urllib2
from bs4 import BeautifulSoup
import sys

def get(code):
    url = 'http://f10.eastmoney.com/f10_v2/ShareholderResearch.aspx?code=sh' + code
    content = ''.join(urllib2.urlopen(url).readlines())
    soup = BeautifulSoup(content)
    rate = soup.find('div', attrs={'id':'TTCS_Table_Div', 'class':'content first'}).find('table').findAll('tr')[-1].findAll('td')[-3].getText()
    rate = float(rate.split('%')[0]) / 100.0
    return 1.0/(1.0 - rate)

if __name__=='__main__':
    print(get(','.join(sys.argv[1:])))

