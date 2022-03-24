#!/usr/bin/env python3
# -*- coding:utf-8 -*-
"""
    logcat.py

    Use to output specified adb logcat.
    :copyright: (c) 2018 by nk.wangshuangquan@gmail.com
    :license: BSD, see LICENSE for more details.
"""
import os
import re
import subprocess
import sys
from io import StringIO
from optparse import OptionParser

try:
    from py.tools.color import Color
except ModuleNotFoundError:
    # noinspection PyUnresolvedReferences
    from tools.color import Color

TAG_WIDTH = 8
PROCESS_WIDTH = 5

re_tag = re.compile(r"^\d\d-\d\d (\d\d:\d\d:\d\d\.\d\d\d) ([A-Z])/([^\(]+)\(([^\)]+)\): (.*)$")

LATEST_USED_TAG_COLOR = [
    Color.RED,
    Color.GREEN,
    Color.YELLOW,
    Color.BLUE,
    Color.MAGENTA,
    Color.CYAN,
    Color.WHITE,
]

LATEST_USED_PROCESS_COLOR = [
    Color.RED,
    Color.MAGENTA,
    Color.YELLOW,
    Color.GREEN,
    Color.BLUE,
]

CACHED_PROCESS = set()
CACHED_PROCESS_COLOR = dict()
INITIAL_PROCESS = set()
OLD_PROCESS = set()

MAX_PROCESS_ID = -1

KNOWN_TAGS = {
    "Process": Color.BLUE,
    "System.err": Color.GREEN,
    "AndroidRuntime": Color.RED,
}

LEVEL_COLOR = {
    "V": Color.BLACK,
    "D": Color.BLUE,
    "I": Color.GREEN,
    "W": Color.YELLOW,
    "E": Color.RED,
    "F": Color.WHITE,
}


def cache_color_for_tag(tag):
    # this will allocate a unique format for the given tag
    # since we don't have very many colors, we always keep track of the LRU
    if tag not in KNOWN_TAGS:
        KNOWN_TAGS[tag] = LATEST_USED_TAG_COLOR[0]
    color = KNOWN_TAGS[tag]
    LATEST_USED_TAG_COLOR.remove(color)
    LATEST_USED_TAG_COLOR.append(color)
    return color


def cache_color_for_process(pid):
    if pid not in CACHED_PROCESS_COLOR:
        color = LATEST_USED_PROCESS_COLOR[0]
        CACHED_PROCESS_COLOR[pid] = color
        LATEST_USED_PROCESS_COLOR.remove(color)
        LATEST_USED_PROCESS_COLOR.append(color)
    return CACHED_PROCESS_COLOR[pid]


class AdbLogger(object):
    """
    Colorful output for adb logcat.
    """

    @staticmethod
    def filter_log(option, owner, tag):
        if option.new_process:
            if owner in INITIAL_PROCESS:
                return False
        if option.package and owner not in CACHED_PROCESS:
            if owner in OLD_PROCESS:
                return False
            OLD_PROCESS.add(owner)
            package = os.popen('adb shell ps|awk "\$2=={} {{print \$9}}"'.format(owner)).readlines()
            if not package:
                return False
            package = package[0].strip()
            if option.all_process:
                if package in option.package:
                    CACHED_PROCESS.add(owner)
                else:
                    return False
            else:
                if package == option.package:
                    CACHED_PROCESS.add(owner)
                else:
                    return False

        if option.cared_tags:
            if tag in option.cared_tags:
                pass
            else:
                return False
        if tag in option.ignore_tags:
            return False
        if option.max_process > 0:
            return owner > MAX_PROCESS_ID
        return True

    @staticmethod
    def process_line(line_buffer, line, option):
        global TAG_WIDTH
        match = re_tag.match(line)
        if match is not None:
            time, level, tag, owner, message = match.groups()
            owner = int(owner.strip())
            tag = tag.strip()
            if not AdbLogger.filter_log(option, owner, tag):
                return
            TAG_WIDTH = min(max(len(tag), TAG_WIDTH), 25)
            line_buffer.truncate(0)
            # write time
            line_buffer.write(Color.format(time, fg=Color.YELLOW))
            # write owner
            process_color = cache_color_for_process(owner)
            line_buffer.write(" ")
            line_buffer.write(Color.format(str(owner).rjust(PROCESS_WIDTH), process_color))
            line_buffer.write(" ")
            # write tag
            tag_color = cache_color_for_tag(tag)
            tag = tag[-TAG_WIDTH:].rjust(TAG_WIDTH)
            line_buffer.write(Color.format(tag, tag_color))
            line_buffer.write(" ")
            # write log level
            line_buffer.write(Color.format(level, fg=LEVEL_COLOR[level], bold=True))
            line_buffer.write(" ")
            line_buffer.write(message)
            line = line_buffer.getvalue()
            print(line)

    # noinspection SpellCheckingInspection
    @staticmethod
    def open_input(option):
        global MAX_PROCESS_ID
        if option.new_process:
            pids = os.popen('adb shell ps|awk "{{print \$2}}"').readlines()
            for pid in pids:
                pid = pid.strip()
                try:
                    INITIAL_PROCESS.add(int(pid))
                except ValueError:
                    pass
        if options.max_process > 0:
            pids = os.popen('adb shell ps|awk "{{print \$2}}"').readlines()
            for pid in pids:
                pid = pid.strip()
                try:
                    MAX_PROCESS_ID = max(int(pid), MAX_PROCESS_ID)
                except ValueError:
                    pass
            print('MAX_PROCESS_ID is ' + str(MAX_PROCESS_ID))
        if os.isatty(sys.stdin.fileno()):
            f = os.popen("adb logcat -v time")
        else:
            # reopen fd to avoid stdin buffering.
            # see http://stackoverflow.com/questions/3670323/setting-smaller-buffer-size-for-sys-stdin
            f = os.fdopen(sys.stdin.fileno(), 'r', 1)
        return f


def array_argument_parser(option, opt, value, _parser):
    arr = getattr(_parser.values, option.dest, None)
    if not arr:
        arr = []
        setattr(_parser.values, option.dest, arr)
    arr.append(value)


parser = OptionParser()
parser.add_option("-p", "--package", dest="package", metavar="package", help="monitor specified package")
parser.add_option("-a", "--all", dest="all_process", action="store_true", default=False, metavar="package", help="monitor all process")
parser.add_option("-n", "--new_process", dest="new_process", action="store_true", default=False, metavar="package", help="see new process only.")
parser.add_option('-i', '--ignore', dest="ignore_tags", type="string", action='callback', default=[], callback=array_argument_parser, metavar="tag", help="ignore specified tag")
parser.add_option('-c', '--cared', dest="cared_tags", type="string", action='callback', default=[], callback=array_argument_parser, metavar="tag", help="care only specified tag")
parser.add_option('-m', '--max', dest="max_process", type="int", action='callback', default=0, callback=array_argument_parser, metavar="tag", help="1 to show log only got process id over with current max id")

(options, args) = parser.parse_args()


if __name__ == '__main__':
    print(options)
    line_buf = StringIO()
    '''
    while True:
        count = 0
        fd = AdbLogger.open_input(options)
        while True:
            one_line = fd.readline()
            if not one_line:
                continue
            AdbLogger.process_line(line_buf, one_line, options)
        time.sleep(10)
    '''
    if os.isatty(sys.stdin.fileno()):
        # 创建adb子进程
        with subprocess.Popen(['adb', 'logcat', '-v', 'time'], text=True, stdout=subprocess.PIPE) as p:
            while True:
                _line = p.stdout.readline()
                AdbLogger.process_line(line_buf, _line, options)
    else:
        """
        with fileinput.input(sys.stdin) as f_input:
            for _line in f_input:
                AdbLogger.process_line(line_buf, _line, options)
        """
        while True:
            try:
                _line = sys.stdin.readline()
                AdbLogger.process_line(line_buf, _line, options)
            except:
                pass

