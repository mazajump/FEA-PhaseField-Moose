[Mesh]
  type = FileMesh
  file = multiblock.e
[]

[MeshModifiers]
  [./extrude]
    type = MeshExtruder
    num_layers = 6
    extrusion_vector = '0 0 2'
    bottom_sideset = 'new_bottom'
    top_sideset = 'new_top'

    # Remap layers
    existing_subdomains = '1 2 5'
    layers = '1 3 5'
    new_ids = '10 12 15
               30 32 35
               50 52 55'
  [../]
[]

[Variables]
  [./u]
    order = FIRST
    family = LAGRANGE
  [../]
[]

[Kernels]
  [./diff]
    type = Diffusion
    variable = u
  [../]
[]

[BCs]
  [./bottom]
    type = DirichletBC
    variable = u
    boundary = 'new_bottom'
    value = 0
  [../]

  [./top]
    type = DirichletBC
    variable = u
    boundary = 'new_top'
    value = 1
  [../]
[]

[Executioner]
  type = Steady

  # Preconditioned JFNK (default)
  solve_type = 'PJFNK'
[]

[Outputs]
  exodus = true
[]
