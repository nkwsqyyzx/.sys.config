#!/usr/bin/python

'''
    Copyright 2009, The Android Open Source Project

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
'''

# script to highlight adb logcat output for console
# written by jeff sharkey, http://jsharkey.org/
# piping detection and popen() added by other android team members

# modified by nkwsqyyzx, fell free to contact nk.wangshuanquan@gmail.com

import os, sys, re, StringIO
import fcntl, termios, struct

# unpack the current terminal width/height
data = fcntl.ioctl(sys.stdout.fileno(), termios.TIOCGWINSZ, '1234')
HEIGHT, WIDTH = struct.unpack('hh',data)

BLACK, RED, GREEN, YELLOW, BLUE, MAGENTA, CYAN, WHITE = range(8)

def format(fg=None, bg=None, bright=False, bold=False, dim=False, reset=False):
    # manually derived from http://en.wikipedia.org/wiki/ANSI_escape_code#Codes
    codes = []
    if reset: codes.append("0")
    else:
        if not fg is None: codes.append("3%d" % (fg))
        if not bg is None:
            if not bright: codes.append("4%d" % (bg))
            else: codes.append("10%d" % (bg))
        if bold: codes.append("1")
        elif dim: codes.append("2")
        else: codes.append("22")
    return "\033[%sm" % (";".join(codes))

LATEST_USED_TAG_COLOR = [RED,GREEN,YELLOW,BLUE,MAGENTA,CYAN,WHITE]
LATEST_USED_PROCESS_COLOR = [RED,MAGENTA,YELLOW,GREEN,BLUE]
CACHED_PROCESS_COLOR = {}
CACHED_PROCESS = []
KNOWN_TAGS = {
    "Process": BLUE,
    "System.err": GREEN,
    "AndroidRuntime": RED,
}
CARED_TAGS = ['AndroidRuntime', 'System.error']
CARED_TAG_PREFIX = ""
CARED_OTHER_MESSAGE = ""

def cache_color_for_tag(tag):
    # this will allocate a unique format for the given tag
    # since we dont have very many colors, we always keep track of the LRU
    if not tag in KNOWN_TAGS:
        KNOWN_TAGS[tag] = LATEST_USED_TAG_COLOR[0]
    color = KNOWN_TAGS[tag]
    LATEST_USED_TAG_COLOR.remove(color)
    LATEST_USED_TAG_COLOR.append(color)
    return color

def cache_color_for_process(pid):
    if not pid in CACHED_PROCESS_COLOR:
        color = LATEST_USED_PROCESS_COLOR[0]
        CACHED_PROCESS_COLOR[pid] = color
        LATEST_USED_PROCESS_COLOR.remove(color)
        LATEST_USED_PROCESS_COLOR.append(color)
    return CACHED_PROCESS_COLOR[pid]

TAGTYPE_WIDTH = 1
TAG_WIDTH = 25
PROCESS_WDITH = 5

TAGTYPES = {
    "V": "%s%s%s " % (format(fg=BLACK, bg=WHITE), "V".center(TAGTYPE_WIDTH), format(reset=True)),
    "D": "%s%s%s " % (format(fg=BLUE, bg=WHITE), "D".center(TAGTYPE_WIDTH), format(reset=True)),
    "I": "%s%s%s " % (format(fg=GREEN, bg=WHITE), "I".center(TAGTYPE_WIDTH), format(reset=True)),
    "W": "%s%s%s " % (format(fg=YELLOW, bg=WHITE), "W".center(TAGTYPE_WIDTH), format(reset=True)),
    "E": "%s%s%s " % (format(fg=RED, bg=WHITE), "E".center(TAGTYPE_WIDTH), format(reset=True)),
}

retag = re.compile("^\d\d-\d\d (\d\d:\d\d:\d\d\.\d\d\d) ([A-Z])/([^\(]+)\(([^\)]+)\): (.*)$")

# if someone is piping in to us, use stdin as input.  if not, invoke adb logcat
# really care about time.
if os.isatty(sys.stdin.fileno()):
    input = os.popen("adb logcat -v time")
else:
    # reopen fd to avoid stdin bufferring.
    # see http://stackoverflow.com/questions/3670323/setting-smaller-buffer-size-for-sys-stdin
    input = os.fdopen(sys.stdin.fileno(), 'r', 1)

def main():
    linebuf = StringIO.StringIO()
    count = 0
    while True:
        try:
            line = input.readline()
        except KeyboardInterrupt:
            break

        match = retag.match(line)
        if not match is None:
            time, tagtype, tag, owner, message = match.groups()

            owner = owner.strip()
            if owner in CACHED_PROCESS:
                pass
            elif CARED_TAG_PREFIX in tag:
                CACHED_PROCESS.append(owner)
            elif CARED_OTHER_MESSAGE in message:
                pass
            elif tag in KNOWN_TAGS:
                pass
            else:
                continue

            if CARED_TAG_PREFIX in tag:
                pass
            elif owner in CACHED_PROCESS and tag in CARED_TAGS:
                pass
            else:
                continue

            linebuf.write("%s%s%s" % (format(fg=YELLOW), time, format(reset=True)))

            owner = owner.rjust(PROCESS_WDITH)
            color = cache_color_for_process(owner)
            linebuf.write(" %s%s%s " % (format(fg=color, bright=True), owner, format(reset=True)))

            # right-align tag title and allocate color if needed
            tag = tag.strip()
            color = cache_color_for_tag(tag)
            tag = tag[-TAG_WIDTH:].rjust(TAG_WIDTH)
            linebuf.write("%s%s %s" % (format(fg=color, dim=False), tag, format(reset=True)))

            # write out tagtype colored edge
            if not tagtype in TAGTYPES: break
            linebuf.write(TAGTYPES[tagtype])

            linebuf.write(message)
            line = linebuf.getvalue()
            linebuf.truncate(0)

        print line
        if len(line) == 0:
            count = count + 1
        if count > 3:
            print('connection failed.')
            break

if __name__ == "__main__":
    main()
