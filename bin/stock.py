#!env python3
# -*- coding: utf-8 -*-

import json
import pandas as pd
import sys
import time
import requests

from tabulate import tabulate

class Color(object):
    """
    Colorful output for terminal text.
    """

    (
        BLACK,
        RED,
        GREEN,
        YELLOW,
        BLUE,
        MAGENTA,
        CYAN,
        WHITE,
    ) = range(8)

    @staticmethod
    def raw_format(fg=None, bg=None, bright=False, bold=False, dim=False, reset=False):
        """
        Format color tag
        :param fg:
        :param bg:
        :param bright:
        :param bold:
        :param dim:
        :param reset:
        :return:
        """
        # manually derived from http://en.wikipedia.org/wiki/ANSI_escape_code#Codes
        codes = []
        if reset:
            codes.append("0")
        else:
            if fg is not None:
                codes.append("3%d" % fg)
            if bg is not None:
                if not bright:
                    codes.append("4%d" % bg)
                else:
                    codes.append("10%d" % bg)
            if bold:
                codes.append("1")
            elif dim:
                codes.append("2")
            else:
                codes.append("22")
        return "\033[%sm" % (";".join(codes))

    @staticmethod
    def format(text, fg=None, bg=None, bright=False, bold=False, dim=False):
        """
        Format text with color
        :param text: the text to format
        :param fg:
        :param bg:
        :param bright:
        :param bold:
        :param dim:
        :return: colorful text
        """
        color = Color.raw_format(fg=fg, bg=bg, bright=bright, bold=bold, dim=dim)
        return "%s%s%s" % (color, text, Color.raw_format(reset=True))


def get(codes):
    url = 'https://xueqiu.com/service/v5/stock/batch/quote'
    params = {
        'symbol': ','.join(codes),
    }
    headers = {
      'authority':'stock.xueqiu.com',
      'pragma':'no-cache',
      'cache-control':'no-cache',
      'accept':'*/*',
      'user-agent':'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/88.0.4324.96 Mobile Safari/537.36',
      'origin':'https://xueqiu.com',
      'sec-fetch-site':'same-site',
      'sec-fetch-mode':'cors',
      'sec-fetch-dest':'empty',
      'referer':'https://xueqiu.com',
      'accept-language':'zh-CN,zh;q=0.9,en;q=0.8,zh-TW;q=0.7,ja;q=0.6,vi;q=0.5,hmn;q=0.4,und;q=0.3,mt;q=0.2',
    }
    r = requests.get(url, params, headers=headers)
    text_data = r.text

    items = json.loads(text_data)['data']['items']

    x = []
    for item in items:
        x.append(item['quote'])

    df = pd.DataFrame(x)

    def _color(x):
        percent = x['percent']
        if percent > 0:
            return Color.format('%.2f' % percent, fg=Color.RED) + '%'
        else:
            return Color.format('-%.2f' % abs(percent), fg=Color.GREEN) + '%'

    df['info'] = df.apply(_color, axis=1)
    df['symbol'] = df['exchange'] + df['code']
    df = df[['symbol', 'name', 'current', 'info']]

    return df


if __name__=='__main__':
    df = get(sys.argv[1:])

    table = []
    for [symbol, name, current, info] in df.values:
        table.append([symbol, name, current, info, 'https://xueqiu.com/S/' + symbol])

    print(tabulate(table, tablefmt='orgtbl'))
