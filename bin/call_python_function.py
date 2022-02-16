#!/usr/bin/env python3
# thanks to https://stackoverflow.com/questions/3987041/run-function-from-the-command-line

import importlib
import inspect
import os
import sys

if __name__ == "__main__":
    cmd_folder = os.path.realpath(os.path.abspath(os.path.split(inspect.getfile(inspect.currentframe()))[0]))
    if cmd_folder not in sys.path:
        sys.path.insert(0, cmd_folder)

    # get the second argument from the command line
    dir_name = sys.argv[1]

    if os.path.isdir(dir_name):
        sys.path.insert(0, dir_name)
    else:
        exit(1)

    method_name = sys.argv[2]

    # split this into module, class and function name
    module_name, class_name, func_name = method_name.split(".")

    # get pointers to the objects based on the string names
    the_module = importlib.import_module(module_name)
    the_class = getattr(the_module, class_name)
    the_func = getattr(the_class, func_name)

    # pass all the parameters from the third until the end of
    # what the function needs & ignore the rest
    args = inspect.getfullargspec(the_func)
    z = len(args.args) + 3
    if not args.varargs:
        params = sys.argv[3:z]
    else:
        params = sys.argv[3:]
    result = the_func(*params)
    if result is not None:
        print(result)
