[Mesh]
  type = GeneratedMesh
  dim = 2
  xmin = 0
  xmax = 1
  ymin = 0
  ymax = 1
  nx = 2
  ny = 2
[]

[Variables]
  [./u]
    order = FIRST
    family = LAGRANGE
  [../]
[]

[AuxVariables]
  [./tt]
    order = FIRST
    family = LAGRANGE
    initial_condition = 0
  [../]

  [./ten]
    order = FIRST
    family = LAGRANGE
    initial_condition = 1
  [../]

  [./2k]
    order = FIRST
    family = LAGRANGE
    initial_condition = 2
  [../]
[]

[Kernels]
  [./diff]
    type = Diffusion
    variable = u
  [../]
[]

[AuxKernels]
  [./do-no-1]
    variable = ten
    type = SelfAux
  [../]

  [./do-no-2]
    variable = 2k
    type = SelfAux
  [../]

  [./all]
    variable = tt
    type = MultipleUpdateAux
    u = u
    var1 = ten
    var2 = 2k
  [../]
[]

[BCs]
  active = 'left right'

  [./left]
    type = DirichletBC
    variable = u
    boundary = 1
    value = 0
  [../]

  [./right]
    type = DirichletBC
    variable = u
    boundary = 3
    value = 1
  [../]
[]

[Executioner]
  type = Steady

  # Preconditioned JFNK (default)
  solve_type = 'PJFNK'
[]

[Outputs]
  file_base = out_multi_var
  exodus = true
[]
