###########################################################
# This is a test of Boundary Condition System. The
# FunctionDirichletBC is used to contribute the residuals
# to the boundary term operators in the weak form.
#
# @Requirement F3.40
###########################################################


[Mesh]
  file = square.e
  uniform_refine = 4
[]

[Variables]
  active = 'u'

  [./u]
    order = FIRST
    family = LAGRANGE
  [../]
[]

[Functions]
  active = 'ff_1 ff_2 forcing_func bc_func'

  [./ff_1]
    type = ParsedFunction
    value = alpha*alpha*pi
    vars = 'alpha'
    vals = '16'
  [../]

  [./ff_2]
    type = ParsedFunction
    value = pi*sin(alpha*pi*x)
    vars = 'alpha'
    vals = '16'
  [../]

  [./forcing_func]
    type = CompositeFunction
    functions = 'ff_1 ff_2'
  [../]

  [./bc_func]
    type = ParsedFunction
    value = sin(alpha*pi*x)
    vars = 'alpha'
    vals = '16'
  [../]
[]

[Kernels]
  active = 'diff forcing'

  [./diff]
    type = Diffusion
    variable = u
  [../]

  [./forcing]
    type = UserForcingFunction
    variable = u
    function = forcing_func
  [../]
[]

[BCs]
  active = 'all'

  # Boundary Condition System
  [./all]
    type = FunctionDirichletBC
    variable = u
    boundary = '1 2'
    function = bc_func
  [../]
[]

[Executioner]
  type = Steady
  nl_rel_tol = 1e-12
[]

[Outputs]
  execute_on = 'timestep_end'
  file_base = out
  exodus = true
[]
