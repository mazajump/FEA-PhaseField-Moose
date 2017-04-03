[Mesh]
  file = single_point_2d.e
[]

[GlobalParams]
  displacements = 'disp_x disp_y'
[]

[Variables]
  [./disp_x]
  [../]
  [./disp_y]
  [../]
[]

[AuxVariables]
  [./penetration]
  [../]
  [./saved_x]
  [../]
  [./saved_y]
  [../]
  [./diag_saved_x]
  [../]
  [./diag_saved_y]
  [../]
  [./inc_slip_x]
  [../]
  [./inc_slip_y]
  [../]
  [./accum_slip_x]
  [../]
  [./accum_slip_y]
  [../]
[]

[Functions]
  [./horizontal_movement]
    type = ParsedFunction
    value = t
  [../]
[]

[SolidMechanics]
  [./solid]
    disp_x = disp_x
    disp_y = disp_y
    save_in_disp_x = saved_x
    save_in_disp_y = saved_y
    diag_save_in_disp_x = diag_saved_x
    diag_save_in_disp_y = diag_saved_y
  [../]
[]

[AuxKernels]
  [./zeroslip_x]
    type = ConstantAux
    variable = inc_slip_x
    boundary = 3
    execute_on = timestep_begin
    value = 0.0
  [../]
  [./zeroslip_y]
    type = ConstantAux
    variable = inc_slip_y
    boundary = 3
    execute_on = timestep_begin
    value = 0.0
  [../]
  [./accum_slip_x]
    type = AccumulateAux
    variable = accum_slip_x
    accumulate_from_variable = inc_slip_x
    execute_on = timestep_end
  [../]
  [./accum_slip_y]
    type = AccumulateAux
    variable = accum_slip_y
    accumulate_from_variable = inc_slip_y
    execute_on = timestep_end
  [../]
  [./penetration]
    type = PenetrationAux
    variable = penetration
    boundary = 3
    paired_boundary = 2
  [../]
[]

[BCs]
  [./botx]
    type = DirichletBC
    variable = disp_x
    boundary = 1
    value = 0.0
  [../]
  [./boty]
    type = DirichletBC
    variable = disp_y
    boundary = 1
    value = 0.0
  [../]
  [./botx2]
    type = DirichletBC
    variable = disp_x
    boundary = 2
    value = 0.0
  [../]
  [./boty2]
    type = DirichletBC
    variable = disp_y
    boundary = 2
    value = 0.0
  [../]
  [./topx]
    type = FunctionPresetBC
    variable = disp_x
    boundary = 4
    function = horizontal_movement
  [../]
  [./topy]
    type = PresetBC
    variable = disp_y
    boundary = 4
    value = -0.005
  [../]
[]

[Materials]
  [./bottom]
    type = LinearIsotropicMaterial
    block = 1
    disp_y = disp_y
    disp_x = disp_x
    poissons_ratio = 0.3
    youngs_modulus = 1e9
  [../]
  [./top]
    type = LinearIsotropicMaterial
    block = 2
    disp_y = disp_y
    disp_x = disp_x
    poissons_ratio = 0.3
    youngs_modulus = 1e6
  [../]
[]

[Postprocessors]
  [./bot_react_x]
    type = NodalSum
    variable = saved_x
    boundary = 1
  [../]
  [./bot_react_y]
    type = NodalSum
    variable = saved_y
    boundary = 1
  [../]
  [./top_react_x]
    type = NodalSum
    variable = saved_x
    boundary = 4
  [../]
  [./top_react_y]
    type = NodalSum
    variable = saved_y
    boundary = 4
  [../]
  [./ref_resid_x]
    type = NodalL2Norm
    execute_on = timestep_end
    variable = saved_x
  [../]
  [./ref_resid_y]
    type = NodalL2Norm
    execute_on = timestep_end
    variable = saved_y
  [../]
[]

[Executioner]
  type = Transient
  solve_type = 'PJFNK'

  petsc_options_iname = '-pc_type -pc_factor_mat_solver_package'
  petsc_options_value = 'lu    superlu_dist'

  line_search = 'none'

  l_max_its = 100
  nl_max_its = 200
  dt = 0.001
  end_time = 0.01
  num_steps = 1000
  nl_rel_tol = 1e-8
  nl_abs_tol = 1e-8
  dtmin = 0.001
  l_tol = 1e-3
[]

[Outputs]
  file_base = single_point_2d_fcp_out
  exodus = true
  print_linear_residuals = true
  print_perf_log = true
  [./console]
    type = Console
    max_rows = 5
  [../]
[]

[Contact]
  [./leftright]
    master = 2
    slave = 3
    model = coulomb
    system = constraint
  [../]
[]

[Problem]
  type = FrictionalContactProblem
  master = '2'
  slave = '3'
  friction_coefficient = '0.25'
  slip_factor = '1.0'
  slip_too_far_factor = '1.0'
  disp_x = disp_x
  disp_y = disp_y
  residual_x = saved_x
  residual_y = saved_y
  diag_stiff_x = diag_saved_x
  diag_stiff_y = diag_saved_y
  inc_slip_x = inc_slip_x
  inc_slip_y = inc_slip_y
  contact_slip_tolerance_factor = 100.
  target_relative_contact_residual = 1.e-8
  maximum_slip_iterations = 50
  minimum_slip_iterations = 1
  slip_updates_per_iteration = 5
  solution_variables = 'disp_x disp_y'
  reference_residual_variables = 'saved_x saved_y'
[]
