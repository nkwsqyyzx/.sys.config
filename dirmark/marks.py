#!/usr/bin/python

import sys
import os

db='.markdb'
class MarkHandler:
    def AddMark(self,tag,path):
        f = open(db,'a+')

        lines = f.readlines()
        print('lines',lines)

        # line-> :tag::path
        exist = 0
        for line in lines:
            parts = line.split(':',2)
            if parts[2] == path:
                exist = 1
                print(line)
            else:
                print(parts)

        entry = ':{0}:{1}:{2}\n'.format(tag,'',path)
        if not exist:
            f.write(entry)

        f.close()

    def ListMark(self):
        pass
    def Search(self,keyword):
        print(keyword)
        pass
    def DelMark(self,path):
        print(path)
        pass

if __name__=='__main__':
    a = MarkHandler()
    a.AddMark('tag','path')
