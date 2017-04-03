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
from Options import Options

def get_options():
    """
    Returns options for vtk fonts.
    """
    opt = Options()
    opt.add('text_color', [1, 1, 1], "The text color.")
    opt.add('text_shadow', False, "Toggle text shadow.")
    opt.add('justification', 'left', "Set the font justification.",
            allow=['left', 'center', 'right'])
    opt.add('vertical_justification', 'bottom', "The vertical text justification.",
            allow=['bottom', 'middle', 'top'])
    opt.add('text_opacity', 1, "The text opacity.", vtype=float)
    opt.add('text', None, "The text to display.", vtype=str)
    opt.add('font_size', 24, "The text font size.", vtype=int)
    return opt


def set_options(tprop, options):
    """
    Applies font options to vtkTextProperty object.

    Inputs:
        tprop: A vtk.vtkTextProperty object for applying options.
        options: The Options object containing the settings to apply.
    """

    if options.isOptionValid('text_color'):
        tprop.SetColor(options['text_color'])

    if options.isOptionValid('text_shadow'):
        tprop.SetShadow(options['text_shadow'])

    if options.isOptionValid('justification'):
        idx = options.raw('justification').allow.index(options['justification'])
        tprop.SetJustification(idx)

    if options.isOptionValid('vertical_justification'):
        idx = options.raw('vertical_justification').allow.index(options['vertical_justification'])
        tprop.SetVerticalJustification(idx)

    if options.isOptionValid('text_opacity'):
        tprop.SetOpacity(options['text_opacity'])

    if options.isOptionValid('font_size'):
        tprop.SetFontSize(options['font_size'])
