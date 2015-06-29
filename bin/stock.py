#!/usr/bin/python
# -*- coding: utf-8 -*-

import urllib2
import sys

import color

from tabulate import tabulate

BASE_URL='http://hq.sinajs.cn/list='

def color_text(text, cor):
    return "%s%s%s" % (color.format(fg=cor), text, color.format(reset=True))

def get(codes):
    js = urllib2.urlopen(BASE_URL + codes).readlines()
    table = []
    for c in js:
        c = c[len('var hq_str_'):]
        c = c.split('="')
        code = c[0]
        c = c[1].split(',')
        name = c[0].decode('chinese')[:2]
        yc = float(c[2])
        cc = float(c[3])
        rate = (cc - yc) * 100/yc
        if rate >= 0:
            rate = color_text('*', color.RED) + "%.2f" % rate
        else:
            rate = color_text('*', color.GREEN) + "%.2f" % abs(rate)
        row = [c[31], code, name, "%.2f" % cc, rate]
        table.append(row)
    print(tabulate(table, tablefmt='orgtbl'))

if __name__=='__main__':
    get(','.join(sys.argv[1:]))
