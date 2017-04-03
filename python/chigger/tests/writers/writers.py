#!/usr/bin/env python
#pylint: disable=missing-docstring
#################################################################
#                   DO NOT MODIFY THIS HEADER                   #
#  MOOSE - Multiphysics Object Oriented Simulation Environment  #
#                                                               #
#            (c) 2010 Battelle Energy Alliance, LLC             #
#                      ALL RIGHTS RESERVED                      #
#                                                               #
#           Prepared by Battelle Energy Alliance, LLC           #
#             Under Contract No. DE-AC07-05ID14517              #
#              With the U. S. Department of Energy              #
#                                                               #
#              See COPYRIGHT for full restrictions              #
#################################################################
import os
import sys
import unittest
import chigger

class TestVTKWriters(unittest.TestCase):
    """
    A unittest for the supported output types.
    """
    extensions = ['.png', '.ps', '.tiff', '.bmp', '.jpg']
    basename = 'writers'

    @classmethod
    def setUpClass(cls):
        """
        Clean up old files.
        """
        for ext in cls.extensions:
            filename = cls.basename + ext
            if os.path.exists(filename):
                os.remove(filename)


    def setUp(self):
        """
        Create a window to export.
        """
        file_name = '../input/mug_blocks_out.e'
        self._reader = chigger.exodus.ExodusReader(file_name, adaptive=False)
        self._result = chigger.exodus.ExodusResult(self._reader, cmap='viridis')
        self._window = chigger.RenderWindow(self._result, size=[300,300], style='test')

    def testFormats(self):
        """
        Test that the images are created.
        """
        for ext in self.extensions:
            filename = self.basename + ext
            self._window.write(filename)
            self.assertTrue(os.path.exists(filename))

    def testError(self):
        """
        Test that error message is given with an unknown extension.
        """
        self._window.write('writers.nope')
        output = sys.stdout.getvalue()
        self.assertIn("The filename must end with one of the following", output)

if __name__ == '__main__':
    unittest.main(module=__name__, verbosity=2, buffer=True, exit=False)
