[Mesh]
  file = square-2x2-nodeids.e
[]

[Variables]
  active = 'u v'

  [./u]
    order = SECOND
    family = LAGRANGE
  [../]

  [./v]
    order = SECOND
    family = LAGRANGE
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
    boundary = '1'
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
    boundary = '2'
    value = 0
  [../]
[]

[Postprocessors]
  [./l2]
    type = ElementL2Error
    variable = u
    function = exact_fn
  [../]

  [./node1]
    type = AverageNodalVariableValue
    variable = u
    boundary = 10
    execute_on = TIMESTEP_BEGIN
  [../]

  [./node4]
    type = AverageNodalVariableValue
    variable = v
    boundary = 13
  [../]
[]

[Executioner]
  type = Transient

  # Preconditioned JFNK (default)
  solve_type = 'PJFNK'

  dt = 0.1
  start_time = 0
  end_time = 1
[]

[Outputs]
  execute_on = 'timestep_end'
  file_base = out_avg_nodal_var_value_ts_begin
  exodus = true
[]
