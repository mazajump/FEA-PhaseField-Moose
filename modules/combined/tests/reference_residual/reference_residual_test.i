[Mesh]
  file = cube.e
[]

[Problem]
  type = ReferenceResidualProblem
  solution_variables = 'disp_x disp_y disp_z temp'
  reference_residual_variables = 'saved_x saved_y saved_z saved_t'
[]

[Variables]
  [./disp_x]
    order = FIRST
    family = LAGRANGE
  [../]

  [./disp_y]
    order = FIRST
    family = LAGRANGE
  [../]

  [./disp_z]
    order = FIRST
    family = LAGRANGE
  [../]

  [./temp]
    order = FIRST
    family = LAGRANGE
  [../]
[]

[AuxVariables]
  [./saved_x]
  [../]
  [./saved_y]
  [../]
  [./saved_z]
  [../]
  [./saved_t]
  [../]
[]

[SolidMechanics]
  [./solid]
    disp_x = disp_x
    disp_y = disp_y
    disp_z = disp_z
    save_in_disp_x = saved_x
    save_in_disp_y = saved_y
    save_in_disp_z = saved_z
  [../]
[]

[Kernels]
  [./heat]
    type = HeatConduction
    variable = temp
    save_in = saved_t
  [../]
[]

[Functions]
  [./pull]
    type = PiecewiseLinear
    x = '0 1 2'
    y = '0 1 1'
    scale_factor = 0.1
  [../]
[]

[BCs]
  [./bottom_x]
    type = DirichletBC
    variable = disp_x
    boundary = 1
    value = 0.0
  [../]

  [./bottom_y]
    type = DirichletBC
    variable = disp_y
    boundary = 1
    value = 0.0
  [../]

  [./bottom_z]
    type = DirichletBC
    variable = disp_z
    boundary = 1
    value = 0.0
  [../]

  [./top_x]
    type = DirichletBC
    variable = disp_x
    boundary = 2
    value = 0.0
  [../]

  [./top_y]
    type = FunctionDirichletBC
    variable = disp_y
    boundary = 2
    function = pull
  [../]

  [./top_z]
    type = DirichletBC
    variable = disp_z
    boundary = 2
    value = 0.0
  [../]

  [./bottom_temp]
    type = DirichletBC
    variable = temp
    boundary = 1
    value = 10.0
  [../]

  [./top_temp]
    type = DirichletBC
    variable = temp
    boundary = 2
    value = 20.0
  [../]
[]

[Materials]

  [./constant]
    type = LinearIsotropicMaterial
    block = 1

    disp_x = disp_x
    disp_y = disp_y
    disp_z = disp_z
    temp = temp

    youngs_modulus = 1.0
    poissons_ratio = .3
    thermal_expansion = 1e-5
  [../]

  [./heat1]
    type = HeatConductionMaterial
    block = 1

    specific_heat = 1.0
    thermal_conductivity = 1e-3 #Tuned to give temperature reference resid close to that of solidmech
  [../]

  [./density]
    type = Density
    block = 1
    density = 1.0
    disp_x = disp_x
    disp_y = disp_y
    disp_z = disp_z
  [../]

[]

[Executioner]
  type = Transient

  #Preconditioned JFNK (default)
  solve_type = 'PJFNK'



  nl_rel_tol = 1e-10

  l_tol = 1e-3
  l_max_its = 100

  dt = 1.0
  end_time = 2.0
[]

[Postprocessors]
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
  [./ref_resid_z]
    type = NodalL2Norm
    execute_on = timestep_end
    variable = saved_z
  [../]
  [./ref_resid_t]
    type = NodalL2Norm
    execute_on = timestep_end
    variable = saved_t
  [../]
  [./nonlinear_its]
    type = NumNonlinearIterations
  []
[]

[Outputs]
  file_base = out
  exodus = true
[]
