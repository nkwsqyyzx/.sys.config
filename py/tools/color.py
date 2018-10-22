#!/usr/bin/env python
# -*- coding:utf-8 -*-
"""
    color.py

    Use to make colorful output for terminal text.
    :copyright: (c) 2018 by nk.wangshuangquan@gmail.com
    :license: BSD, see LICENSE for more details.
"""


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


if __name__ == '__main__':
    print(Color.format('hello, world', Color.YELLOW))
