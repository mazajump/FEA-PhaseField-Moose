[Mesh]
  type = FileMesh
  file = split_blocks.e
[]

[Variables]
  [./u]
    block = left
  [../]
  [./v]
    block = right
  [../]
[]

[Kernels]
  [./diff_u]
    type = Diffusion
    variable = u
    block = left
  [../]
  [./diff_v]
    type = Diffusion
    variable = v
    block = right
  [../]
[]

[BCs]
  active = 'right left'
  [./left]
    type = DirichletBC
    variable = u
    boundary = 1
    value = 0
  [../]
  [./right]
    type = DirichletBC
    variable = v
    boundary = 4
    value = 1
  [../]
[]

[Constraints]
  [./value]
    type = CoupledTiedValueConstraint
    variable = u
    slave = 2
    master = 3
    master_variable = v
  [../]
[]

[Preconditioning]
  active = 'SMP'
  [./SMP]
    type = SMP
    full = true
  [../]
[]

[Executioner]
  type = Steady
  solve_type = NEWTON
  l_max_its = 100
  nl_max_its = 2
[]

[Outputs]
  file_base = out
  exodus = true
[]
