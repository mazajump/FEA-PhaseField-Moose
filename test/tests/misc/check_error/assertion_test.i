[Mesh]
  file = square.e    # Read a Mesh

  [./Generation]    # AND create a Mesh...
    dim = 2
    nx = 2
    ny = 2
    nz = 0
    zmin = 0
    zmax = 0
    elem_type = QUAD4
  [../]
[]

[Variables]
  active = 'u'

  [./u]
    order = FIRST
    family = LAGRANGE
  [../]
[]

[Kernels]
  active = 'diff'

  [./diff]
    type = Diffusion
    variable = u
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
    boundary = 2
    value = 1
  [../]
[]

[Materials]
  active = empty

  [./empty]
    type = EmptyMaterial
    block = 1
  [../]
[]

[Executioner]
  type = Steady

  # Preconditioned JFNK (default)
  solve_type = 'PJFNK'
[]

[Outputs]
  file_base = out
  exodus = true
[]
