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
import glob
import xml.etree.ElementTree as xml

# Import matplotlib, if it exists
try:
    from matplotlib import cm
    import numpy as np
    USE_MATPLOTLIB = True
except ImportError:
    USE_MATPLOTLIB = False

import vtk
import mooseutils
from ChiggerObject import ChiggerObject

def get_xml_table_values():
    """
    Load Paraview XML files (http://www.paraview.org/Wiki/Colormaps).
    """

    # Locate the XML files storing the colormap data
    contrib = os.path.abspath(os.path.join(os.path.dirname(__file__)))
    filenames = glob.glob(os.path.join(contrib, '*.xml'))

    # If a name is provided, locate the actual table values
    data = dict()
    for fname in filenames:
        for child in xml.parse(fname).getroot():
            data[child.attrib['name']] = child
    return data

class ColorMap(ChiggerObject):
    """
    Class for defining colormaps for use with ExodusResult objects.

    If matplotlib is available this class first checks for the name in there. If it is not found
    there or matplotlib is not available it loads the XML files from this repository, which are the
    XML files used by Paraview for building colormaps.
    """

    @staticmethod
    def getOptions():
        opt = ChiggerObject.getOptions()
        opt.add('cmap', 'default', "The colormap name.")
        opt.add('cmap_reverse', False, "Reverse the order of colormap.")
        opt.add('cmap_num_colors', 256, "Number of colors to use (matplotlib only).")
        opt.add('cmap_range', [0, 1], "Set the data range for the color map to display.")
        return opt

    # The table is only needed once
    _data = get_xml_table_values()

    def __init__(self, **kwargs):
        """
        Constructor, which does nothing except update options passed in.
        """
        super(ColorMap, self).__init__(**kwargs)

    def names(self):
        """
        Return all the possible colormap names.
        """
        names = ['default']
        if USE_MATPLOTLIB:
            names += dir(cm)
        names += self._data.keys()
        return names

    def __call__(self):
        """
        Operator() returns the vtkLookupTable for use as a colormap.
        """
        # Use peacock style
        name = self.getOption('cmap')
        if name == 'default':
            vtktable = self.__default()

        # Matplotlib
        elif USE_MATPLOTLIB and (name in dir(cm)):
            vtktable = self.__matplotlib()

        # Read from Paraview XML files
        elif name in self._data:
            vtktable = self.__xml()

        else:
            raise mooseutils.MooseException("Unknown colormap:", name)

        if self.isOptionValid('cmap_range'):
            vtktable.SetRange(*self.getOption('cmap_range'))
        vtktable.Build()
        return vtktable

    def __default(self):
        """
        Build Peacock style colormap.
        """
        n = self.getOption('cmap_num_colors')
        lut = vtk.vtkLookupTable()
        if self.getOption('cmap_reverse'):
            lut.SetHueRange(0.0, 0.667)
        else:
            lut.SetHueRange(0.667, 0.0)
        lut.SetNumberOfColors(n)
        return lut

    def __matplotlib(self):
        """
        Builds VTK table using matplotlib cololmap.
        """

        # Extract matplotlib colormap
        name = self.getOption('cmap')
        n = self.getOption('cmap_num_colors')
        points = np.linspace(0, 1, n)

        cmap = getattr(cm, name)(points)

        # Create VTK table
        table = vtk.vtkLookupTable()
        table.SetNumberOfTableValues(n)

        if self.getOption('cmap_reverse'):
            rng = list(reversed(range(n)))
        else:
            rng = list(range(n))

        for i, r in enumerate(rng):
            table.SetTableValue(i, *cmap[r])
        return table

    def __xml(self):
        """
        Builds VTK table using Paraview XML colormap files.
        """
        # Extract data
        name = self.getOption('cmap')
        data = self._data[name]

        # Extract the table data
        xmin = float('inf')
        xmax = float('-inf')
        values = []
        points = []
        for child in data:
            a = child.attrib
            if child.tag == 'Point':
                x = float(a['x'])
                r = float(a['r'])
                g = float(a['g'])
                b = float(a['b'])
                xmin = min(xmin, x)
                xmax = max(xmax, x)
                values.append(x)
                points.append([r, g, b])

        # Flip the data if desired
        if self.getOption('cmap_reverse'):
            points = list(reversed(points))

        # Build function
        function = vtk.vtkColorTransferFunction()
        function.SetRange(xmin, xmax)
        for i, v in enumerate(values):
            function.AddRGBPoint(v, *points[i])
        function.Build()

        # The number of points
        n = self.getOption('cmap_num_colors')
        cm_points = np.linspace(xmin, xmax, n)

        # Build the lookup table
        table = vtk.vtkLookupTable()
        table.SetNumberOfTableValues(n)
        for i in range(n):
            table.SetTableValue(i, *function.GetColor(cm_points[i]))
        return table
