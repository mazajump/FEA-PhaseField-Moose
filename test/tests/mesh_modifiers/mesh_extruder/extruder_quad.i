[Mesh]
  type = FileMesh
  file = chimney_quad.e
[]

[MeshModifiers]
  [./extrude]
    type = MeshExtruder
    num_layers = 20
    extrusion_vector = '0 1e-2 0'
    bottom_sideset = 'new_bottom'
    top_sideset = 'new_top'
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
  file_base = out_quad
  exodus = true
[]
