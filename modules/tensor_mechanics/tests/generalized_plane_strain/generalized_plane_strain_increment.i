[GlobalParams]
  displacements = 'disp_x disp_y'
  scalar_out_of_plane_strain = scalar_strain_zz
  block = 1
[]

[Mesh]
  file = square.e
[]

[Variables]
  [./scalar_strain_zz]
    order = FIRST
    family = SCALAR
  [../]
[]

[AuxVariables]
  [./temp]
  [../]
  [./saved_x]
  [../]
  [./saved_y]
  [../]
[]

[Postprocessors]
  [./react_z]
    type = MaterialTensorIntegral
    rank_two_tensor = stress
    index_i = 2
    index_j = 2
  [../]
[]

[Modules/TensorMechanics/Master]
  [./all]
    strain = FINITE
    incremental = true
    add_variables = true
    generate_output = 'stress_xx stress_xy stress_yy stress_zz strain_xx strain_xy strain_yy strain_zz'
    planar_formulation = GENERALIZED_PLANE_STRAIN
    eigenstrain_names = eigenstrain
    temperature = temp
    save_in = 'saved_x saved_y'
  [../]
[]

[AuxKernels]
  [./tempfuncaux]
    type = FunctionAux
    variable = temp
    function = tempfunc
    use_displaced_mesh = false
  [../]
[]

[Functions]
  [./tempfunc]
    type = ParsedFunction
    value = '(1-x)*t'
  [../]
[]

[BCs]
  [./bottomx]
    type = PresetBC
    boundary = 1
    variable = disp_x
    value = 0.0
  [../]
  [./bottomy]
    type = PresetBC
    boundary = 1
    variable = disp_y
    value = 0.0
  [../]
[]

[Materials]
  [./elastic_tensor]
    type = ComputeIsotropicElasticityTensor
    poissons_ratio = 0.3
    youngs_modulus = 1e6
  [../]
  [./thermal_strain]
    type = ComputeThermalExpansionEigenstrain
    temperature = temp
    thermal_expansion_coeff = 0.02
    stress_free_temperature = 0.5
    eigenstrain_name = eigenstrain
    incremental_form = true
  [../]
  [./stress]
    type = ComputeStrainIncrementBasedStress
  [../]
[]

[Problem]
  kernel_coverage_check = false
[]

[Executioner]
  type = Transient

  solve_type = PJFNK
  line_search = none

  # controls for linear iterations
  l_max_its = 100
  l_tol = 1e-4

  # controls for nonlinear iterations
  nl_max_its = 15
  nl_rel_tol = 1e-10
  nl_abs_tol = 1e-5

  # time control
  start_time = 0.0
  dt = 1.0
  dtmin = 1.0
  end_time = 2.0
[]

[Outputs]
  exodus = true
[]
