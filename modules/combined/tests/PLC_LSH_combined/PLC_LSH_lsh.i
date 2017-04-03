#
# Test considers only linear strain hardening by setting the power-law
#   creep coefficient to zero.
##
# The mesh is a 1x1x1 cube pulled in the y direction.  Young's
#    modulus is 2.4e5, and the yield stress is 2.4e2.  This gives
#    a strain at yield of 0.001.  This strain is reached after 5
#    solves.  As the deformation continues, the stress follows the
#    hardening constant slope (1206).
#

[Mesh]
  file = PLC_LSH_lsh.e
  displacements = 'disp_x disp_y disp_z'
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
[]


[AuxVariables]
  [./stress_yy]
    order = CONSTANT
    family = MONOMIAL
  [../]

  [./plastic_strain_xx]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./plastic_strain_yy]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./plastic_strain_zz]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./elastic_strain_yy]
    order = CONSTANT
    family = MONOMIAL
  [../]
[]


[Functions]
  [./top_pull]
    type = ParsedFunction
    value = t/5.0
  [../]
[]

[SolidMechanics]
  [./solid]
    disp_x = disp_x
    disp_y = disp_y
    disp_z = disp_z
  [../]
[]


[AuxKernels]

  [./stress_yy]
    type = MaterialTensorAux
    tensor = stress
    variable = stress_yy
    index = 1
  [../]

  [./plastic_strain_xx]
    type = MaterialTensorAux
    tensor = plastic_strain
    variable = plastic_strain_xx
    index = 0
  [../]

  [./plastic_strain_yy]
    type = MaterialTensorAux
    tensor = plastic_strain
    variable = plastic_strain_yy
    index = 1
  [../]

  [./plastic_strain_zz]
    type = MaterialTensorAux
    tensor = plastic_strain
    variable = plastic_strain_zz
    index = 2
  [../]

  [./elastic_strain_yy]
    type = MaterialTensorAux
    tensor = elastic_strain
    variable = elastic_strain_yy
    index = 1
  [../]

 []


[BCs]
  [./y_pull_function]
    type = FunctionDirichletBC
    variable = disp_y
    boundary = 5
    function = top_pull
  [../]

  [./x_bot]
    type = DirichletBC
    variable = disp_x
    boundary = 4
    value = 0.0
  [../]
  [./y_bot]
    type = DirichletBC
    variable = disp_y
    boundary = 3
    value = 0.0
  [../]
  [./z_bot]
    type = DirichletBC
    variable = disp_z
    boundary = 2
    value = 0.0
  [../]
[]

[Materials]
  [./lsh]
    type = PLC_LSH
    block = 1
    youngs_modulus = 2.4e5
    poissons_ratio = .3
    yield_stress = 2.4e2
    hardening_constant = 1206.
    coefficient = 0.0
    n_exponent = 1.0
    activation_energy = 0.0
    relative_tolerance = 1.e-8
    disp_x = disp_x
    disp_y = disp_y
    disp_z = disp_z
  [../]
[]

[Executioner]
  type = Transient

  # Two sets of linesearch options are for petsc 3.1 and 3.3 respectively

  #Preconditioned JFNK (default)
  solve_type = 'PJFNK'


  petsc_options = '-snes_ksp_ew'
  petsc_options_iname = '-ksp_gmres_restart'
  petsc_options_value = '101'

  line_search = 'none'


  l_max_its = 100
  nl_max_its = 100
  nl_rel_tol = 1e-12
  nl_abs_tol = 1e-10
  l_tol = 1e-9
  start_time = 0.0
  end_time = 0.02
  dt = 1e-3
[]

[Outputs]
  exodus = true
[]
