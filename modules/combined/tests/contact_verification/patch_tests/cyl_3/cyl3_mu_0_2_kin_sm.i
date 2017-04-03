[Mesh]
  file = cyl3_mesh.e
[]

[GlobalParams]
  order = SECOND
  displacements = 'disp_x disp_y'
[]

[Problem]
  type = FrictionalContactProblem
  coord_type = RZ
  master = 4
  slave = 3
  friction_coefficient = 0.20
  slip_factor = 1.0
  slip_too_far_factor = 1.0
  disp_x = disp_x
  disp_y = disp_y
  residual_x = saved_x
  residual_y = saved_y
  diag_stiff_x = diag_saved_x
  diag_stiff_y = diag_saved_y
  inc_slip_x = inc_slip_x
  inc_slip_y = inc_slip_y
  target_contact_residual = 1.e-3
  maximum_slip_iterations = 50
  minimum_slip_iterations = 1
  slip_updates_per_iteration = 5
  solution_variables = 'disp_x disp_y'
  reference_residual_variables = 'saved_x saved_y'
  contact_reference_residual_variables = 'saved_x saved_y'
[]

[Variables]
  [./disp_x]
  [../]
  [./disp_y]
  [../]
[]

[AuxVariables]
  [./stress_xx]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./stress_yy]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./stress_xy]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./stress_zz]
    order = CONSTANT
    family = MONOMIAL
  [../]
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
  [./tang_force_x]
  [../]
  [./tang_force_y]
  [../]
[]

[SolidMechanics]
  [./solid]
    disp_r = disp_x
    disp_z = disp_y
    save_in_disp_r = saved_x
    save_in_disp_z = saved_y
  [../]
[]

[AuxKernels]
  [./stress_xx]
    type = MaterialTensorAux
    tensor = stress
    variable = stress_xx
    index = 0
  [../]
  [./stress_yy]
    type = MaterialTensorAux
    tensor = stress
    variable = stress_yy
    index = 1
  [../]
  [./stress_xy]
    type = MaterialTensorAux
    tensor = stress
    variable = stress_xy
    index = 3
  [../]
  [./inc_slip_x]
    type = PenetrationAux
    variable = inc_slip_x
    execute_on = timestep_end
    boundary = 3
    paired_boundary = 4
  [../]
  [./inc_slip_y]
    type = PenetrationAux
    variable = inc_slip_y
    execute_on = timestep_end
    boundary = 3
    paired_boundary = 4
  [../]
  [./accum_slip_x]
    type = PenetrationAux
    variable = accum_slip_x
    execute_on = timestep_end
    boundary = 3
    paired_boundary = 4
  [../]
  [./accum_slip_y]
    type = PenetrationAux
    variable = accum_slip_y
    execute_on = timestep_end
    boundary = 3
    paired_boundary = 4
  [../]
  [./penetration]
    type = PenetrationAux
    variable = penetration
    boundary = 3
    paired_boundary = 4
  [../]
  [./tang_force_x]
    type = PenetrationAux
    variable = tang_force_x
    quantity = tangential_force_x
    boundary = 3
    paired_boundary = 4
  [../]
  [./tang_force_y]
    type = PenetrationAux
    variable = tang_force_y
    quantity = tangential_force_y
    boundary = 3
    paired_boundary = 4
  [../]
[] # AuxKernels

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
    boundary = 5
  [../]
  [./top_react_y]
    type = NodalSum
    variable = saved_y
    boundary = 5
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
  [./sigma_yy]
    type = ElementAverageValue
    variable = stress_yy
  [../]
  [./sigma_zz]
    type = ElementAverageValue
    variable = stress_zz
  [../]
  [./disp_x2]
    type = NodalVariableValue
    nodeid = 1
    variable = disp_x
  [../]
  [./disp_x11]
    type = NodalVariableValue
    nodeid = 10
    variable = disp_x
  [../]
  [./disp_y2]
    type = NodalVariableValue
    nodeid = 1
    variable = disp_y
  [../]
  [./disp_y11]
    type = NodalVariableValue
    nodeid = 10
    variable = disp_y
  [../]
  [./_dt]
    type = TimestepSize
  [../]
  [./num_lin_it]
    type = NumLinearIterations
  [../]
  [./num_nonlin_it]
    type = NumNonlinearIterations
  [../]
[]

[BCs]
  [./bot_y]
    type = DirichletBC
    variable = disp_y
    boundary = 1
    value = 0.0
  [../]
  [./side_x]
    type = DirichletBC
    variable = disp_x
    boundary = 2
    value = 0.0
  [../]
  [./top_press]
    type = Pressure
    variable = disp_y
    boundary = 5
    component = 1
    factor = 109.89
  [../]
[]

[Materials]
  [./bot]
    type = Elastic
    block = 1
    disp_z = disp_y
    disp_r = disp_x
    poissons_ratio = 0.3
    youngs_modulus = 1e6
  [../]
  [./top]
    type = Elastic
    block = 2
    disp_z = disp_y
    disp_r = disp_x
    poissons_ratio = 0.3
    youngs_modulus = 1e6
  [../]
[]

[Executioner]
  type = Transient
  solve_type = 'PJFNK'

  petsc_options_iname = '-pc_type -pc_factor_mat_solver_package'
  petsc_options_value = 'lu     superlu_dist'

  line_search = 'none'

  nl_abs_tol = 1e-5
  nl_rel_tol = 1e-4
  l_max_its = 50
  nl_max_its = 100
  dt = 1.0
  end_time = 1.0
  num_steps = 10
  dtmin = 1.0
  l_tol = 1e-3
[]

[VectorPostprocessors]
  [./x_disp]
    type = NodalValueSampler
    variable = disp_x
    boundary = '1 3 4 5'
    sort_by = x
  [../]
  [./cont_press]
    type = NodalValueSampler
    variable = contact_pressure
    boundary = '3'
    sort_by = x
  [../]
[]

[Outputs]
  file_base = cyl3_mu_0_2_kin_out
  print_linear_residuals = true
  print_perf_log = true
  [./exodus]
    type = Exodus
    elemental_as_nodal = true
  [../]
  [./console]
    type = Console
    max_rows = 5
  [../]
  [./chkfile]
    type = CSV
    file_base = cyl3_mu_0_2_kin_check
    show = 'bot_react_x bot_react_y disp_x2 disp_y2 disp_x11 disp_y11 sigma_yy sigma_zz top_react_x top_react_y x_disp cont_press'
    execute_vector_postprocessors_on = timestep_end
  [../]
  [./outfile]
    type = CSV
    delimiter = ' '
    execute_vector_postprocessors_on = none
  [../]
[]

[Contact]
  [./leftright]
    slave = 3
    master = 4
    system = constraint
    model = coulomb
    normalize_penalty = true
    tangential_tolerance = 1e-3
    penalty = 1e9
  [../]
[]
