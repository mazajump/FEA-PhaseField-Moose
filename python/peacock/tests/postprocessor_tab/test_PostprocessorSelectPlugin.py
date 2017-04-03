#!/usr/bin/env python
import sys
import os
import unittest
import shutil
import time
from PyQt5 import QtCore, QtWidgets

from peacock.PostprocessorViewer.plugins.PostprocessorSelectPlugin import main
from peacock.utils import Testing
import mooseutils


class TestPostprocessorSelectPlugin(Testing.PeacockImageTestCase):
    """
    Test class for the ArtistToggleWidget which toggles postprocessor lines.
    """

    #: QApplication: The main App for QT, this must be static to work correctly.
    qapp = QtWidgets.QApplication(sys.argv)

    def setUp(self):
        """
        Creates the GUI containing the ArtistGroupWidget and the matplotlib figure axes.
        """

        # Filenames to load
        self._filename = '{}_test.csv'.format(self.__class__.__name__)
        self._filename2 = '{}_test2.csv'.format(self.__class__.__name__)

        # Read the data
        filenames = [self._filename, self._filename2]
        self._control, self._widget, self._window = main(filenames, mooseutils.PostprocessorReader)

    def copyfiles(self, partial=False):
        """
        Move files into the temporary location.
        """

        if partial:
            shutil.copyfile('../input/white_elephant_jan_2016_partial.csv', self._filename)
        else:
            shutil.copyfile('../input/white_elephant_jan_2016.csv', self._filename)
        shutil.copyfile('../input/postprocessor.csv', self._filename2)

        for data in self._widget._data[0]:
            data.load()

    def tearDown(self):
        """
        Remove temporary files.
        """

        if os.path.exists(self._filename):
            os.remove(self._filename)

        if os.path.exists(self._filename2):
            os.remove(self._filename2)

    def testEmpty(self):
        """
        Test that an empty plot is possible.
        """
        self.assertImage('testEmpty.png')

    def testSelect(self):
        """
        Test that plotting from multiple files works.
        """
        self.copyfiles()
        vars = ['air_temp_set_1', 'sincos']
        for i in range(len(vars)):
            self._control._groups[i]._toggles[vars[i]].CheckBox.setCheckState(QtCore.Qt.Checked)
            self._control._groups[i]._toggles[vars[i]].CheckBox.clicked.emit(True)

        self.assertImage('testSelect.png')

    def testUpdateData(self):
        """
        Test that a postprocessor data updates when file is changed.
        """

        self.copyfiles(partial=True)
        var = 'air_temp_set_1'
        self._control._groups[0]._toggles[var].CheckBox.setCheckState(QtCore.Qt.Checked)
        self._control._groups[0]._toggles[var].CheckBox.clicked.emit(True)
        self.assertImage('testUpdateData0.png')

        # Reload the data (this would be done via a Timer)
        time.sleep(1) # need to wait a bit for the modified time to change
        self.copyfiles()
        self.assertImage('testUpdateData1.png')

    def testRepr(self):
        """
        Test python scripting.
        """
        self.copyfiles()
        vars = ['air_temp_set_1', 'sincos']
        for i in range(len(vars)):
            self._control._groups[i]._toggles[vars[i]].CheckBox.setCheckState(QtCore.Qt.Checked)
            self._control._groups[i]._toggles[vars[i]].CheckBox.clicked.emit(True)

        output, imports = self._control.repr()
        self.assertIn("data = mooseutils.PostprocessorReader('TestPostprocessorSelectPlugin_test.csv')", output)
        self.assertIn("x = data('time')", output)
        self.assertIn("y = data('air_temp_set_1')", output)
        self.assertIn("axes0.plot(x, y, marker='', linewidth=1, color=[0.2, 0.627, 0.173, 1.0], markersize=1, linestyle='-', label='air_temp_set_1')", output)
        self.assertIn("data = mooseutils.PostprocessorReader('TestPostprocessorSelectPlugin_test2.csv')", output)

if __name__ == '__main__':
    unittest.main(module=__name__, verbosity=2)
