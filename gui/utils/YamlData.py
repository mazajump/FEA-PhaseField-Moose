#!/usr/bin/python
import sys, os, commands, time, re, copy

try:
    from PyQt4 import QtCore, QtGui
    QtCore.Signal = QtCore.pyqtSignal
    QtCore.Slot = QtCore.pyqtSlot
except ImportError:
    try:
        from PySide import QtCore, QtGui
        QtCore.QString = str
    except ImportError:
        raise ImportError("Cannot load either PyQt or PySide")

from GenSyntax import *

try:
    _fromUtf8 = QtCore.QString.fromUtf8
except AttributeError:
    _fromUtf8 = lambda s: s

class YamlData():
    def __init__(self, qt_app, app_path, recache, use_cached_syntax):
        self.qt_app = qt_app
        self.app_path = app_path
        self.use_cached_syntax = use_cached_syntax
        self.gen_syntax = GenSyntax(qt_app, app_path, use_cached_syntax)
        self.yaml_data = self.gen_syntax.GetSyntax(recache)

    def recache(self, recache):
        self.yaml_data = self.gen_syntax.GetSyntax(recache)

    def recursiveYamlDataSearch(self, path, current_yaml):
        if current_yaml['name'] == path:
            return current_yaml
        else:
            if current_yaml['subblocks']:
                for child in current_yaml['subblocks']:
                    yaml_data = self.recursiveYamlDataSearch(path, child)

                    if yaml_data:  # Found it in a child!
                        return yaml_data
            else: # No children.. stop recursion
                return None

    def findYamlEntry(self, path):
        for yaml_it in self.yaml_data:
            yaml_data = self.recursiveYamlDataSearch(path, yaml_it)

            if yaml_data:
                return yaml_data

        # This means it wasn't found
        return None
