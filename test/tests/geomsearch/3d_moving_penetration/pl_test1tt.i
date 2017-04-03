[GlobalParams]
  order = FIRST
  family = LAGRANGE
[]

[Mesh]
  file = pl_test1tt.e
  displacements = 'disp_x disp_y disp_z'
[]

[Variables]
  [./disp_x]
  [../]
  [./disp_y]
  [../]
  [./disp_z]
  [../]
[]

[AuxVariables]
  [./distance]
  [../]
  [./tangential_distance]
  [../]
  [./normal_x]
  [../]
  [./normal_y]
  [../]
  [./normal_z]
  [../]
  [./closest_point_x]
  [../]
  [./closest_point_y]
  [../]
  [./closest_point_z]
  [../]
  [./element_id]
  [../]
  [./side]
  [../]
[]

[Kernels]
  [./diff_x]
    type = Diffusion
    variable = disp_x
  [../]
  [./diff_y]
    type = Diffusion
    variable = disp_y
  [../]
  [./diff_z]
    type = Diffusion
    variable = disp_z
  [../]
[]

[AuxKernels]
  [./penetrate]
    type = PenetrationAux
    variable = distance
    boundary = 11            #slave
    paired_boundary = 12     #master
    tangential_tolerance = 0.1
  [../]

  [./penetrate2]
    type = PenetrationAux
    variable = distance
    boundary = 12            #slave
    paired_boundary = 11     #master
    tangential_tolerance = 0.1
  [../]

  [./penetrate3]
    type = PenetrationAux
    variable = tangential_distance
    boundary = 11
    paired_boundary = 12
    quantity = tangential_distance
  [../]

  [./penetrate4]
    type = PenetrationAux
    variable = tangential_distance
    boundary = 12
    paired_boundary = 11
    quantity = tangential_distance
  [../]

  [./penetrate5]
    type = PenetrationAux
    variable = normal_x
    boundary = 11
    paired_boundary = 12
    quantity = normal_x
  [../]

  [./penetrate6]
    type = PenetrationAux
    variable = normal_x
    boundary = 12
    paired_boundary = 11
    quantity = normal_x
  [../]

  [./penetrate7]
    type = PenetrationAux
    variable = normal_y
    boundary = 11
    paired_boundary = 12
    quantity = normal_y
  [../]

  [./penetrate8]
    type = PenetrationAux
    variable = normal_y
    boundary = 12
    paired_boundary = 11
    quantity = normal_y
  [../]

  [./penetrate9]
    type = PenetrationAux
    variable = normal_z
    boundary = 11
    paired_boundary = 12
    quantity = normal_z
  [../]

  [./penetrate10]
    type = PenetrationAux
    variable = normal_z
    boundary = 12
    paired_boundary = 11
    quantity = normal_z
  [../]

  [./penetrate11]
    type = PenetrationAux
    variable = closest_point_x
    boundary = 11
    paired_boundary = 12
    quantity = closest_point_x
  [../]

  [./penetrate12]
    type = PenetrationAux
    variable = closest_point_x
    boundary = 12
    paired_boundary = 11
    quantity = closest_point_x
  [../]

  [./penetrate13]
    type = PenetrationAux
    variable = closest_point_y
    boundary = 11
    paired_boundary = 12
    quantity = closest_point_y
  [../]

  [./penetrate14]
    type = PenetrationAux
    variable = closest_point_y
    boundary = 12
    paired_boundary = 11
    quantity = closest_point_y
  [../]

  [./penetrate15]
    type = PenetrationAux
    variable = closest_point_z
    boundary = 11
    paired_boundary = 12
    quantity = closest_point_z
  [../]

  [./penetrate16]
    type = PenetrationAux
    variable = closest_point_z
    boundary = 12
    paired_boundary = 11
    quantity = closest_point_z
  [../]

  [./penetrate17]
    type = PenetrationAux
    variable = element_id
    boundary = 11
    paired_boundary = 12
    quantity = element_id
  [../]

  [./penetrate18]
    type = PenetrationAux
    variable = element_id
    boundary = 12
    paired_boundary = 11
    quantity = element_id
  [../]

  [./penetrate19]
    type = PenetrationAux
    variable = side
    boundary = 11
    paired_boundary = 12
    quantity = side
  [../]

  [./penetrate20]
    type = PenetrationAux
    variable = side
    boundary = 12
    paired_boundary = 11
    quantity = side
  [../]
[]

[BCs]
  [./b1x]
    type = DirichletBC
    variable = disp_x
    boundary = 1
    value = 0
  [../]

  [./b1y]
    type = DirichletBC
    variable = disp_y
    boundary = 1
    value = 0
  [../]

  [./b1z]
    type = DirichletBC
    variable = disp_z
    boundary = 1
    value = 0
  [../]

  [./b2x]
    type = DirichletBC
    variable = disp_x
    boundary = 2
    value = 0
  [../]

  [./b2y]
    type = FunctionDirichletBC
    variable = disp_y
    boundary = 2
    function = disp_y
  [../]

  [./b2z]
    type = DirichletBC
    variable = disp_z
    boundary = 2
    value = 0
  [../]
[]

[Functions]
  [./disp_y]
    type = PiecewiseLinear
    x = '0.0 0.25 0.75 1.0'
    y = '0.0 0.7 -0.7  0.0'
  [../]
[]

[Executioner]
  type = Transient

  # Preconditioned JFNK (default)
  solve_type = 'PJFNK'
  petsc_options = '-snes_ksp_ew'

  nl_rel_tol = 1e-9
  l_max_its = 10

  start_time = 0.0
  dt = 0.05
  end_time = 1.0
[]

[Outputs]
  file_base = pl_test1tt_out
  exodus = true
[]
