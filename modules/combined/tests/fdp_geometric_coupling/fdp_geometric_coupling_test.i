[Mesh]
  file = twoBlocksContactDiceSlave2OffsetGap.e
[]

[GlobalParams]
  displacements = 'disp_x disp_y disp_z'
[]

[Variables]
  [./disp_x]
  [../]
  [./disp_y]
  [../]
  [./disp_z]
  [../]
  [./temp]
    initial_condition = 100.0
  [../]
[]

[Functions]
  [./pressure]
    type = PiecewiseLinear
    x = '0 1 2'
    y = '0 1 1'
    scale_factor = 10.0
  [../]

  [./tempFunc]
    type = PiecewiseLinear
    x = '0. 3.'
    y = '100.0 440.0'
  [../]
[]

[SolidMechanics]
  [./solid]
    disp_x = disp_x
    disp_y = disp_y
    disp_z = disp_z
    temp = temp
  [../]
[]

[Kernels]
  [./heat]
    type = HeatConduction
    variable = temp
  [../]
[]

[BCs]
  [./left_x]
    type = PresetBC
    variable = disp_x
    boundary = 1
    value = 0.0
  [../]

  [./left_y]
    type = PresetBC
    variable = disp_y
    boundary = 1
    value = 0.0
  [../]

  [./left_z]
    type = PresetBC
    variable = disp_z
    boundary = 1
    value = 0.0
  [../]

  [./right_y]
    type = PresetBC
    variable = disp_y
    boundary = 4
    value = 0.0
  [../]

  [./right_z]
    type = PresetBC
    variable = disp_z
    boundary = 4
    value = 0.0
  [../]

  [./right_x]
    type = PresetBC
    variable = disp_x
    boundary = 4
    value = 0.0
  [../]

  [./temp]
    type = FunctionDirichletBC
    variable = temp
    boundary = '2 3'
    function = tempFunc
  [../]
[]

[Contact]
  [./dummy_name]
    master = 2
    slave = 3
    penalty = 1e6
  [../]
[]

[Materials]
  [./stiffStuff1]
    type = Elastic
    block = 1

    disp_x = disp_x
    disp_y = disp_y
    disp_z = disp_z

    youngs_modulus = 1e6
    poissons_ratio = 0.0

    temp = temp
    thermal_expansion = 1e-4
  [../]
  [./stiffStuff2]
    type = Elastic
    block = 2

    disp_x = disp_x
    disp_y = disp_y
    disp_z = disp_z

    youngs_modulus = 1e6
    poissons_ratio = 0.0

    temp = temp
    thermal_expansion = 1e-5
  [../]

  [./heat]
    type = HeatConductionMaterial
    block = '1 2'

    specific_heat = 1.0
    thermal_conductivity = 1.0
  [../]

  [./density]
    type = Density
    block = '1 2'
    density = 1.0
    disp_x = disp_x
    disp_y = disp_y
    disp_z = disp_z
  [../]
[]

[Preconditioning]
  [./FDP]
    type = FDP
    full = true
    implicit_geometric_coupling = true
  [../]
[]

[Executioner]
  type = Transient
  solve_type = 'PJFNK'

  petsc_options_iname = '-pc_type -mat_fd_coloring_err -mat_fd_type'
  petsc_options_value = 'lu       1e-8                 ds'

  nl_rel_tol = 1e-10

  l_max_its = 5
  nl_max_its = 3
  dt = 1.0e-1
  num_steps = 10
[]

[Outputs]
  file_base = out
  exodus = true
[]
