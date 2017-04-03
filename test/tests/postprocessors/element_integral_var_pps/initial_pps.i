[Mesh]
  type = GeneratedMesh
  dim = 2
  xmin = 0
  xmax = 1
  ymin = 0
  ymax = 1
  nx = 3
  ny = 3
  elem_type = QUAD9
[]

[Variables]
  active = 'u v'

  [./u]
    order = SECOND
    family = LAGRANGE
    [./InitialCondition]
      type = ConstantIC
      value = 2.8
    [../]
  [../]

  [./v]
    order = SECOND
    family = LAGRANGE
    [./InitialCondition]
      type = ConstantIC
      value = 5.4
    [../]
  [../]
[]

[Functions]
  active = 'force_fn exact_fn left_bc'

  [./force_fn]
    type = ParsedFunction
    value = '1-x*x+2*t'
  [../]

  [./exact_fn]
    type = ParsedFunction
    value = '(1-x*x)*t'
  [../]

  [./left_bc]
    type = ParsedFunction
    value = t
  [../]
[]

[Kernels]
  active = '
    time_u diff_u ffn_u
    time_v diff_v'

  [./time_u]
    type = TimeDerivative
    variable = u
  [../]

  [./diff_u]
    type = Diffusion
    variable = u
  [../]

  [./ffn_u]
    type = UserForcingFunction
    variable = u
    function = force_fn
  [../]

  [./time_v]
    type = TimeDerivative
    variable = v
  [../]

  [./diff_v]
    type = Diffusion
    variable = v
  [../]
[]

[BCs]
  active = 'all_u left_v right_v'

  [./all_u]
    type = FunctionDirichletBC
    variable = u
    boundary = '0 1 2 3'
    function = exact_fn
  [../]

  [./left_v]
    type = FunctionDirichletBC
    variable = v
    boundary = '3'
    function = left_bc
  [../]

  [./right_v]
    type = DirichletBC
    variable = v
    boundary = '1'
    value = 0
  [../]
[]

[Postprocessors]
  [./initial_u]
    type = ElementIntegralVariablePostprocessor
    variable = u
    execute_on = initial
  [../]

  [./initial_v]
    type = ElementIntegralVariablePostprocessor
    variable = v
    execute_on = initial
  [../]
[]

[Executioner]
  type = Transient

  # Preconditioned JFNK (default)
  solve_type = 'PJFNK'

  dt = 0.1
  start_time = 0
  end_time = 0.3
[]

[Outputs]
  file_base = out_initial_pps
  exodus = true
[]
