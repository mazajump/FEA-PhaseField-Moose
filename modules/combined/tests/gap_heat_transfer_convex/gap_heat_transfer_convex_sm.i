[Mesh]
  file = gap_heat_transfer_convex.e
  displacements = 'disp_x disp_y disp_z'
[]

[Functions]
  [./disp]
    type = PiecewiseLinear
    x = '0 2.0'
    y = '0 1.0'
  [../]

  [./temp]
    type = PiecewiseLinear
    x = '0     1'
    y = '200 200'
  [../]
[]

[Variables]
  [./disp_x]
  [../]
  [./disp_y]
  [../]
  [./disp_z]
  [../]

  [./temp]
    initial_condition = 100
  [../]
[]

[ThermalContact]
  [./thermal_contact]
    type = GapHeatTransfer
    variable = temp
    master = 2
    slave = 3
  [../]
[]

[SolidMechanics]
  [./solid]
    disp_x = disp_x
    disp_y = disp_y
    disp_z = disp_z
  [../]
[]

[Kernels]
  [./heat]
    type = HeatConduction
    variable = temp
  [../]
[]

[BCs]
  [./move_right]
    type = FunctionDirichletBC
    boundary = '3'
    variable = disp_x
    function = disp
  [../]
  [./fixed_x]
    type = DirichletBC
    boundary = '1'
    variable = disp_x
    value = 0
  [../]
  [./fixed_y]
    type = DirichletBC
    boundary = '1 2 3 4'
    variable = disp_y
    value = 0
  [../]
  [./fixed_z]
    type = DirichletBC
    boundary = '1 2 3 4'
    variable = disp_z
    value = 0
  [../]

  [./temp_bottom]
    type = FunctionDirichletBC
    boundary = 1
    variable = temp
    function = temp
  [../]
  [./temp_top]
    type = DirichletBC
    boundary = 4
    variable = temp
    value = 100
  [../]
[]

[Materials]
  [./dummy]
    type = Elastic
    block = '1 2'

    disp_x = disp_x
    disp_y = disp_y
    disp_z = disp_z

    youngs_modulus = 1e6
    poissons_ratio = .3

    temp = temp
    thermal_expansion = 0
  [../]

  [./heat1]
    type = HeatConductionMaterial
    block = 1

    specific_heat = 1.0
    thermal_conductivity = 1.0
  [../]
  [./heat2]
    type = HeatConductionMaterial
    block = 2

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

[Executioner]
  type = Transient
  solve_type = 'PJFNK'

  start_time = 0.0
  dt = 0.1
  end_time = 2.0
[]

[Outputs]
  file_base = gap_heat_transfer_convex_out
  exodus = true
[]
