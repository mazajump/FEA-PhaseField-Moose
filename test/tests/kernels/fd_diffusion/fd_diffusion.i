[Mesh]
  type = GeneratedMesh
  dim = 3
  nx = 10
  ny = 10
  uniform_refine = 1
[]

[Variables]
  [./u]
  [../]
[]

[Kernels]
  [./fddiff]
    type = FDDiffusion
    variable = u
  [../]
[]

[BCs]
  [./left]
    type = DirichletBC
    variable = u
    boundary = left
    value = 0
  [../]
  [./right]
    type = DirichletBC
    variable = u
    boundary = right
    value = 1
  [../]
[]

[Executioner]
  type = Steady

  # Preconditioned JFNK (default)
  solve_type = 'PJFNK'

  petsc_options       = 'snes_view'
  petsc_options_iname = '-pc_type'
  petsc_options_value = '      lu'
[]

[Outputs]
  exodus = true
[]

[Debug]
  show_var_residual_norms = true
[]
