###########################################################
# This is a simple test demonstrating the use of the
# Hermite variable type.
#
# @Requirement F3.10
###########################################################


[Mesh]
  type = GeneratedMesh
  dim = 1
  xmin = -1
  xmax = 1
  nx = 5
  elem_type = EDGE3
[]

[Functions]
  [./bc_fnl]
    type = ParsedFunction
    value = -3*x*x
  [../]
  [./bc_fnr]
    type = ParsedFunction
    value = 3*x*x
  [../]

  [./forcing_fn]
    type = ParsedFunction
    value = -6*x+(x*x*x)
  [../]

  [./solution]
    type = ParsedGradFunction
    value = x*x*x
    grad_x = 3*x*x
[]

# Hermite Variable type
[Variables]
  [./u]
    order = THIRD
    family = HERMITE
  [../]
[]

[Kernels]
  active = 'diff forcing reaction'
  [./diff]
    type = Diffusion
    variable = u
  [../]

  [./reaction]
    type = Reaction
    variable = u
  [../]

  [./forcing]
    type = UserForcingFunction
    variable = u
    function = forcing_fn
  [../]
[]

[BCs]
  [./bc_left]
    type = FunctionNeumannBC
    variable = u
    boundary = 'left'
    function = bc_fnl
  [../]
  [./bc_right]
    type = FunctionNeumannBC
    variable = u
    boundary = 'right'
    function = bc_fnr
  [../]
[]

[Postprocessors]
  [./dofs]
    type = NumDOFs
  [../]

  [./h]
    type = AverageElementSize
    variable = u
  [../]

  [./L2error]
    type = ElementL2Error
    variable = u
    function = solution
  [../]
  [./H1error]
    type = ElementH1Error
    variable = u
    function = solution
  [../]
  [./H1Semierror]
    type = ElementH1SemiError
    variable = u
    function = solution
  [../]
[]

[Executioner]
  type = Steady

  solve_type = 'NEWTON'
[]

[Outputs]
  execute_on = 'timestep_end'
  exodus = true
  csv = true
[]
