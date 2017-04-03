import os
import unittest
from MooseDocs.testing import MarkdownTestCase

class TestMooseFigure(MarkdownTestCase):
    """
    Test commands in MooseFigure extension.
    """

    def testFigure(self):
        md = '!figure docs/media/github-logo.png id=figure\n\n\\ref{figure}'
        self.assertConvert('test_Figure.html', md)
