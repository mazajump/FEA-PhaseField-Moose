[GlobalParams]
  order = FIRST
  family = LAGRANGE
  disp_x = disp_x
  disp_y = disp_y
  disp_z = disp_z
[]

[Mesh]
  file = ellip_crack_4sym_norad_mm.e
  displacements = 'disp_x disp_y disp_z'
  partitioner = centroid
  centroid_partitioner_direction = z
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
  [./stress_xx]      # stress aux variables are defined for output; this is a way to get integration point variables to the output file
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./stress_yy]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./stress_zz]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./vonmises]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./SED]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./resid_z]
  [../]
[]


[Functions]
  [./rampConstantUp]
    type = PiecewiseLinear
    x = '0. 1.'
    y = '0. 1.'
    scale_factor = -689.5 #MPa
  [../]
[]

[DomainIntegral]
  integrals = JIntegral
  crack_direction_method = CurvedCrackFront
  crack_end_direction_method = CrackDirectionVector
  crack_direction_vector_end_1 = '0.0 1.0 0.0'
  crack_direction_vector_end_2 = '1.0 0.0 0.0'
  crack_front_points = '0             254           0
                        127.308       248.843       0
                        249.446       233.581       0
                        361.455       208.835       0
                        508.003       152.398       0
                        602.415       80.3208       0
                        635           0             0'
  radius_inner = '12.5 25.0 37.5'
  radius_outer = '25.0 37.5 50.0'
  intersecting_boundary = '1 2'
  symmetry_plane = 2
[]

[SolidMechanics]
  [./solid]
    save_in_disp_z = resid_z
  [../]
[]

[AuxKernels]
  [./stress_xx]               # computes stress components for output
    type = MaterialTensorAux
    tensor = stress
    variable = stress_xx
    index = 0
    execute_on = timestep_end     # for efficiency, only compute at the end of a timestep
  [../]
  [./stress_yy]
    type = MaterialTensorAux
    tensor = stress
    variable = stress_yy
    index = 1
    execute_on = timestep_end
  [../]
  [./stress_zz]
    type = MaterialTensorAux
    tensor = stress
    variable = stress_zz
    index = 2
    execute_on = timestep_end
  [../]
  [./vonmises]
    type = MaterialTensorAux
    tensor = stress
    variable = vonmises
    quantity = vonmises
    execute_on = timestep_end
  [../]
  [./SED]
    type = MaterialRealAux
    variable = SED
    property = strain_energy_density
    execute_on = timestep_end
  [../]
[]

[BCs]

  [./crack_y]
    type = DirichletBC
    variable = disp_z
    boundary = 6
    value = 0.0
  [../]

  [./no_y]
    type = DirichletBC
    variable = disp_y
    boundary = 12
    value = 0.0
  [../]

  [./no_x]
    type = DirichletBC
    variable = disp_x
    boundary = 1
    value = 0.0
  [../]

  [./Pressure]
    [./Side1]
      boundary = 5
      function = rampConstantUp
    [../]
  [../]
[] # BCs

[Materials]
  [./stiffStuff]
    type = Elastic
    block = 1

    disp_x = disp_x
    disp_y = disp_y
    disp_z = disp_z

    youngs_modulus = 206.8e+3 #MPa
    #youngs_modulus = 30e+6
    poissons_ratio = 0.3
    thermal_expansion = 1e-5
    compute_JIntegral = true
  [../]
[]


[Executioner]

   type = Transient
  # Two sets of linesearch options are for petsc 3.1 and 3.3 respectively

  #Preconditioned JFNK (default)
  solve_type = 'PJFNK'


#  petsc_options = '-snes_ksp_ew'
  petsc_options_iname = '-ksp_gmres_restart -pc_type -pc_hypre_type -pc_hypre_boomeramg_max_iter'
  petsc_options_value = '201                hypre    boomeramg      4'


  line_search = 'none'

   l_max_its = 50
   nl_max_its = 20
   nl_abs_tol = 1e-5
   nl_rel_tol = 1e-11
   l_tol = 1e-2

   start_time = 0.0
   dt = 1

   end_time = 1
   num_steps = 1

[]

[Postprocessors]
  [./_dt]
    type = TimestepSize
  [../]

  [./nl_its]
    type = NumNonlinearIterations
  [../]

  [./lin_its]
    type = NumLinearIterations
  [../]

  [./react_z]
    type = NodalSum
    variable = resid_z
    boundary = 5
  [../]

[]


[Outputs]
  execute_on = 'timestep_end'
  file_base = j_int_surfbreak_ellip_crack_sym_mm_cfp_out
  exodus = true
  csv = true
[]
