[Mesh]
  type = GeneratedMesh
  dim = 2
  nx = 10
  ny = 10
[]

[Variables]
  [./u]
    initial_condition = 2
  [../]
[]

[Functions]
  [./right_bc]
    type = ParsedFunction
    value = a+1
    vals = left_avg
    vars = a
  [../]
  [./left_bc]
    type = ParsedFunction
    value = a
    vals = left_avg
    vars = a
  [../]
[]

[Kernels]
  [./diff]
    type = Diffusion
    variable = u
  [../]
[]

[BCs]
  [./left]
    type = FunctionDirichletBC
    variable = u
    boundary = left
    function = left_bc
  [../]
  [./right]
    type = FunctionDirichletBC
    variable = u
    boundary = 'right right'
    function = right_bc
  [../]
[]

[Postprocessors]
  [./left_avg]
    type = SideAverageValue
    variable = u
    execute_on = initial
    boundary = left
  [../]
[]

[Executioner]
  type = Steady

  # Preconditioned JFNK (default)
  solve_type = 'PJFNK'

  petsc_options_iname = '-pc_type -pc_hypre_type'
  petsc_options_value = 'hypre boomeramg'
[]

[Outputs]
  exodus = true
[]
