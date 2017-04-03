###########################################################
# This is a simple test with a time-dependent problem
# demonstrating the use of the TimeIntegrator system.
#
# Testing a solution that is second order in space
# and first order in time
#
# @Requirement F1.30
###########################################################

[Mesh]
  type = GeneratedMesh
  dim = 2
  xmin = -1
  xmax = 1
  ymin = -1
  ymax = 1
  nx = 10
  ny = 10
  elem_type = QUAD9
[]

[Variables]
  [./u]
    order = SECOND
    family = LAGRANGE

    [./InitialCondition]
      type = ConstantIC
      value = 0
    [../]
  [../]
[]

[Functions]
  [./forcing_fn]
    type = ParsedFunction
    value = ((x*x)+(y*y))-(4*t)
  [../]

  [./exact_fn]
    type = ParsedFunction
    value = t*((x*x)+(y*y))
  [../]
[]

[Kernels]
  [./ie]
    type = TimeDerivative
    variable = u
  [../]

  [./diff]
    type = Diffusion
    variable = u
  [../]

  [./ffn]
    type = UserForcingFunction
    variable = u
    function = forcing_fn
  [../]
[]

[BCs]
  [./all]
    type = FunctionDirichletBC
    variable = u
    boundary = '0 1 2 3'
    function = exact_fn
  [../]
[]

[Postprocessors]
  [./l2_err]
    type = ElementL2Error
    variable = u
    function = exact_fn
  [../]
[]

[Executioner]
  type = Transient

  # Test of the TimeIntegrator System
  scheme = 'implicit-euler'

  start_time = 0.0
  num_steps = 5
  dt = 0.25
[]

[Outputs]
  exodus = true
[]
