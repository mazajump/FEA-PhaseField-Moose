[Mesh]
  type = GeneratedMesh
  dim = 1
  xmin = -1
  xmax = 1
  nx = 20
  elem_type = EDGE3
[]

[Functions]
  [./ic]
    type = ParsedFunction
    value = 0
  [../]

  [./forcing_fn]
    type = ParsedFunction
    value = x*x-2*t
  [../]

  [./exact_fn]
    type = ParsedFunction
    value = t*x*x
  [../]
[]

[Variables]
  [./u]
    order = SECOND
    family = LAGRANGE

    [./InitialCondition]
      type = FunctionIC
      function = ic
    [../]
  [../]
[]

[Kernels]
  [./ie]
    type = TimeDerivative
    variable = u
#    lumping = true
    implicit = true
  [../]

  [./diff]
    type = Diffusion
    variable = u
    implicit = false
  [../]

  [./ffn]
    type = UserForcingFunction
    variable = u
    function = forcing_fn
    implicit = false
  [../]
[]

[BCs]
  active = 'all'

  [./all]
    type = FunctionDirichletBC
    variable = u
    boundary = '0 1'
    function = exact_fn
    implicit = true
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
  scheme = 'explicit-euler'
  solve_type = 'LINEAR'

  l_tol = 1e-12
  start_time = 0.0
  num_steps = 20
  dt = 0.00005
[]

[Outputs]
  exodus = true
  [./console]
    type = Console
    max_rows = 10
  [../]
[]
