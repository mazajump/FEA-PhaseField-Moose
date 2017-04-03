[Mesh]
  file = circle-quads.e
[]

[Functions]
  [./all_bc_fn]
    type = ParsedFunction
    value = x*x+y*y
  [../]

  [./f_fn]
    type = ParsedFunction
    value = -4
  [../]

  [./analytical_normal_x]
    type = ParsedFunction
    value = x
  [../]
  [./analytical_normal_y]
    type = ParsedFunction
    value = y
  [../]
[]

[NodalNormals]
[]

[Variables]
  [./u]
  [../]
[]

[Kernels]
  [./diff]
    type = Diffusion
    variable = u
  [../]
  [./ffn]
    type = UserForcingFunction
    variable = u
    function = f_fn
  [../]
[]

[BCs]
  [./all]
    type = FunctionDirichletBC
    variable = u
    boundary = '1'
    function = 'all_bc_fn'
  [../]
[]

[Postprocessors]
  [./nx_pps]
    type = NodalL2Error
    variable = nodal_normal_x
    boundary = '1'
    function = analytical_normal_x
  [../]
  [./ny_pps]
    type = NodalL2Error
    variable = nodal_normal_y
    boundary = '1'
    function = analytical_normal_y
  [../]
[]

[Executioner]
  type = Steady

  # Preconditioned JFNK (default)
  solve_type = 'PJFNK'
  nl_rel_tol = 1e-13
[]

[Outputs]
  execute_on = 'timestep_end'
  exodus = true
[]
