#!/usr/bin/python

import os
import re
import StringIO
import sys
import time

from optparse import OptionParser

import color

TAGTYPE_WIDTH = 1
TAG_WIDTH = 8
PROCESS_WDITH = 5

retag = re.compile("^\d\d-\d\d (\d\d:\d\d:\d\d\.\d\d\d) ([A-Z])/([^\(]+)\(([^\)]+)\): (.*)$")

LATEST_USED_TAG_COLOR = [
    color.RED,
    color.GREEN,
    color.YELLOW,
    color.BLUE,
    color.MAGENTA,
    color.CYAN,
    color.WHITE
]

LATEST_USED_PROCESS_COLOR = [
    color.RED,
    color.MAGENTA,
    color.YELLOW,
    color.GREEN,
    color.BLUE
]

CACHED_PROCESS_COLOR = dict()
CACHED_PROCESS = set()

KNOWN_TAGS = {
    "Process": color.BLUE,
    "System.err": color.GREEN,
    "AndroidRuntime": color.RED,
}

TAGTYPES = {
    "V": "%s%s%s " % (color.format(fg=color.BLACK, bg=color.WHITE), "V".center(TAGTYPE_WIDTH), color.format(reset=True)),
    "D": "%s%s%s " % (color.format(fg=color.BLUE, bg=color.WHITE), "D".center(TAGTYPE_WIDTH), color.format(reset=True)),
    "I": "%s%s%s " % (color.format(fg=color.GREEN, bg=color.WHITE), "I".center(TAGTYPE_WIDTH), color.format(reset=True)),
    "W": "%s%s%s " % (color.format(fg=color.YELLOW, bg=color.WHITE), "W".center(TAGTYPE_WIDTH), color.format(reset=True)),
    "E": "%s%s%s " % (color.format(fg=color.RED, bg=color.WHITE), "E".center(TAGTYPE_WIDTH), color.format(reset=True)),
    "F": "%s%s%s " % (color.format(fg=color.WHITE, bg=color.WHITE), "F".center(TAGTYPE_WIDTH), color.format(reset=True)),
}

MAX_PROCESS_ID = -1

def cache_color_for_process(pid):
    if not pid in CACHED_PROCESS_COLOR:
        color = LATEST_USED_PROCESS_COLOR[0]
        CACHED_PROCESS_COLOR[pid] = color
        LATEST_USED_PROCESS_COLOR.remove(color)
        LATEST_USED_PROCESS_COLOR.append(color)
    return CACHED_PROCESS_COLOR[pid]

def cache_color_for_tag(tag):
    # this will allocate a unique format for the given tag
    # since we dont have very many colors, we always keep track of the LRU
    if not tag in KNOWN_TAGS:
        KNOWN_TAGS[tag] = LATEST_USED_TAG_COLOR[0]
    cor = KNOWN_TAGS[tag]
    LATEST_USED_TAG_COLOR.remove(cor)
    LATEST_USED_TAG_COLOR.append(cor)
    return cor

def color_text(text, cor):
    return "%s%s%s" % (color.format(fg=cor), text, color.format(reset=True))

def checkLog(options, owner, tag, message):
    if options.new_process:
        if owner in INITIAL_PROCESS:
            return False
    if (options.package and owner not in CACHED_PROCESS):
        if owner in OLD_PROCESS:
            return False
        OLD_PROCESS.add(owner)
        package = os.popen('adb shell ps|awk "\$2=={} {{print \$9}}"'.format(owner)).readlines()
        if not package:
            return False
        package = package[0].strip()
        if options.all_process:
            if package in options.package:
                CACHED_PROCESS.add(owner)
            else:
                return False
        else:
            if package == options.package:
                CACHED_PROCESS.add(owner)
            else:
                return False

    if options.cared_tags:
        if tag in options.cared_tags:
            pass
        else:
            return False
    if tag in options.ignore_tags:
        return False
    if options.max_process > 0:
        return owner > MAX_PROCESS_ID
    return True

OLD_PROCESS = set()
INITIAL_PROCESS = set()
def process_line(linebuf, line, options):
    global TAG_WIDTH
    match = retag.match(line)
    if not match is None:
        time, tagtype, tag, owner, message = match.groups()
        owner = int(owner.strip())
        tag = tag.strip()
        if not checkLog(options, owner, tag, message):
            return
        TAG_WIDTH = min(max(len(tag), TAG_WIDTH), 25)
        linebuf.truncate(0)
        # write time
        linebuf.write(color_text(time, color.YELLOW))
        # write owner
        proccess_color = cache_color_for_process(owner)
        linebuf.write(" ")
        linebuf.write(color_text(str(owner).rjust(PROCESS_WDITH), proccess_color))
        linebuf.write(" ")
        tag_color = cache_color_for_tag(tag)
        tag = tag[-TAG_WIDTH:].rjust(TAG_WIDTH)
        linebuf.write(color_text(tag, tag_color))
        linebuf.write(" ")
        linebuf.write(TAGTYPES[tagtype])
        linebuf.write(message)
        line = linebuf.getvalue()
        print(line)

def array_argument_parser(option, opt, value, parser):
    arr = getattr(parser.values, option.dest, None)
    if not arr:
        arr = []
        setattr(parser.values, option.dest, arr)
    arr.append(value)

parser = OptionParser()
parser.add_option("-p", "--package", dest="package", metavar="package", help="monitor specified package")
parser.add_option("-a", "--all", dest="all_process", action="store_true", default=False, metavar="package", help="monitor all process")
parser.add_option("-n", "--new_process", dest="new_process", action="store_true", default=False, metavar="package", help="see new process only.")
parser.add_option('-i', '--ignore', dest="ignore_tags", type="string", action='callback', default=[], callback=array_argument_parser, metavar="tag", help="ignore specified tag")
parser.add_option('-c', '--cared', dest="cared_tags", type="string", action='callback', default=[], callback=array_argument_parser, metavar="tag", help="care only specified tag")
parser.add_option('-m', '--max', dest="max_process", type="int", action='callback', default=0, callback=array_argument_parser, metavar="tag", help="1 to show log only got process id over with current max id")

(options, args) = parser.parse_args()

input = None
def start_adb():
    global input
    global MAX_PROCESS_ID
    if options.new_process:
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
        print 'MAX_PROCESS_ID is ' + str(MAX_PROCESS_ID)

    if os.isatty(sys.stdin.fileno()):
        input = os.popen("adb logcat -v time")
    else:
        # reopen fd to avoid stdin bufferring.
        # see http://stackoverflow.com/questions/3670323/setting-smaller-buffer-size-for-sys-stdin
        input = os.fdopen(sys.stdin.fileno(), 'r', 1)

if __name__ == "__main__":
    linebuf = StringIO.StringIO()
    while True:
        start_adb()
        count = 0
        while True:
            line = input.readline()
            if not line or count >=5:
                count += 1
                print 'device unplugged.'
                break
            process_line(linebuf, line, options)
        time.sleep(10)
