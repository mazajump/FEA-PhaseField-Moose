[Mesh]
  file = cylinder-hexes.e
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
[]

[NodalNormals]
  boundary = '1'
  corner_boundary = 100
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
