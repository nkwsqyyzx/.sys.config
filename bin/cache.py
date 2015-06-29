# -*- coding: UTF8 -*-
import codecs
import hashlib
import os.path
import time
import urllib

class HtmlCache:
    def __init__(self, basepath):
        self.basepath = basepath

    def getCachedHtml(self, url, timeout):
        m = hashlib.md5()
        m.update(url.encode())
        md5value = m.hexdigest()
        html = None
        fpath = '{0}{1}.html'.format(self.basepath, md5value)
        if os.path.exists(fpath):
            outofdate = time.time() - os.path.getmtime(fpath) > timeout
            if outofdate:
                return html, fpath
            with open(fpath, 'r') as f:
                try:
                    html = f.read()
                except UnicodeDecodeError:
                    pass
        return html, fpath

    def getContent(self, url, cache=1, timeout=30 * 60):
        if cache:
            html, fpath = self.getCachedHtml(url, timeout)
            if html:
                return html, True
            else:
                html = ''.join(urllib.urlopen(url).readlines())
                if not os.path.exists(self.basepath):
                    os.makedirs(self.basepath)
                with open(fpath, 'w') as outfile:
                    outfile.write(html)
                return html, False
        else:
            html = ''.join(urllib.urlopen(url).readlines())
            return html, False
