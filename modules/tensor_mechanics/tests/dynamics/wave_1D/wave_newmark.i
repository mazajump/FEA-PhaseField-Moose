# Wave propogation in 1D using Newmark time integration
#
# The test is for an 1D bar element of length 4m  fixed on one end
# with a sinusoidal pulse dirichlet boundary condition applied to the other end.
# beta and gamma are Newmark time integration parameters
# The equation of motion in terms of matrices is:
#
# M*accel +  K*disp = 0
#
# Here M is the mass matrix, K is the stiffness matrix
#
# This equation is equivalent to:
#
# density*accel + Div Stress= 0
#
# The first term on the left is evaluated using the Inertial force kernel
# The last term on the left is evaluated using StressDivergenceTensors
#
# The displacement at the second, third and fourth node at t = 0.1 are
# -8.021501116638234119e-02, 2.073994362053969628e-02 and  -5.045094181261772920e-03, respectively

[Mesh]
  type = GeneratedMesh
  dim = 3
  nx = 1
  ny = 4
  nz = 1
  xmin = 0.0
  xmax = 0.1
  ymin = 0.0
  ymax = 4.0
  zmin = 0.0
  zmax = 0.1
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
  [./vel_x]
  [../]
  [./accel_x]
  [../]
  [./vel_y]
  [../]
  [./accel_y]
  [../]
  [./vel_z]
  [../]
  [./accel_z]
  [../]
  [./stress_yy]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./strain_yy]
    order = CONSTANT
    family = MONOMIAL
  [../]

[]

[Kernels]
  [./TensorMechanics]
    displacements = 'disp_x disp_y disp_z'
  [../]
  [./inertia_x]
    type = InertialForce
    variable = disp_x
    velocity = vel_x
    acceleration = accel_x
    beta = 0.3025
    gamma = 0.6
    eta=0.0
  [../]
  [./inertia_y]
    type = InertialForce
    variable = disp_y
    velocity = vel_y
    acceleration = accel_y
    beta = 0.3025
    gamma = 0.6
    eta=0.0
  [../]
  [./inertia_z]
    type = InertialForce
    variable = disp_z
    velocity = vel_z
    acceleration = accel_z
    beta = 0.3025
    gamma = 0.6
    eta = 0.0
  [../]

[]

[AuxKernels]
  [./accel_x]
    type = NewmarkAccelAux
    variable = accel_x
    displacement = disp_x
    velocity = vel_x
    beta = 0.3025
    execute_on = timestep_end
  [../]
  [./vel_x]
    type = NewmarkVelAux
    variable = vel_x
    acceleration = accel_x
    gamma = 0.6
    execute_on = timestep_end
  [../]
  [./accel_y]
    type = NewmarkAccelAux
    variable = accel_y
    displacement = disp_y
    velocity = vel_y
    beta = 0.3025
    execute_on = timestep_end
  [../]
  [./vel_y]
    type = NewmarkVelAux
    variable = vel_y
    acceleration = accel_y
    gamma = 0.6
    execute_on = timestep_end
  [../]
  [./accel_z]
    type = NewmarkAccelAux
    variable = accel_z
    displacement = disp_z
    velocity = vel_z
    beta = 0.3025
    execute_on = timestep_end
  [../]
  [./vel_z]
    type = NewmarkVelAux
    variable = vel_z
    acceleration = accel_z
    gamma = 0.6
    execute_on = timestep_end
  [../]
  [./stress_yy]
    type = RankTwoAux
    rank_two_tensor = stress
    variable = stress_yy
    index_i = 0
    index_j = 1
  [../]
  [./strain_yy]
    type = RankTwoAux
    rank_two_tensor = total_strain
    variable = strain_yy
    index_i = 0
    index_j = 1
  [../]

[]


[BCs]
  [./top_y]
    type = DirichletBC
    variable = disp_y
    boundary = top
    value=0.0
  [../]
  [./top_x]
    type = DirichletBC
    variable = disp_x
    boundary = top
    value=0.0
  [../]
  [./top_z]
    type = DirichletBC
    variable = disp_z
    boundary = top
    value=0.0
  [../]
  [./right_x]
    type = DirichletBC
    variable = disp_x
    boundary = right
    value=0.0
  [../]
  [./right_z]
    type = DirichletBC
    variable = disp_z
    boundary = right
    value=0.0
  [../]
  [./left_x]
    type = DirichletBC
    variable = disp_x
    boundary = left
    value=0.0
  [../]
  [./left_z]
    type = DirichletBC
    variable = disp_z
    boundary = left
    value=0.0
  [../]
  [./front_x]
    type = DirichletBC
    variable = disp_x
    boundary = front
    value=0.0
  [../]
  [./front_z]
    type = DirichletBC
    variable = disp_z
    boundary = front
    value=0.0
  [../]
  [./back_x]
    type = DirichletBC
    variable = disp_x
    boundary = back
    value=0.0
  [../]
  [./back_z]
    type = DirichletBC
    variable = disp_z
    boundary = back
    value=0.0
  [../]
  [./bottom_x]
    type = DirichletBC
    variable = disp_x
    boundary = bottom
    value=0.0
  [../]
  [./bottom_z]
    type = DirichletBC
    variable = disp_z
    boundary = bottom
    value=0.0
  [../]
  [./bottom_y]
    type = FunctionPresetBC
    variable = disp_y
    boundary = bottom
    function = displacement_bc
  [../]
[]

[Materials]
  [./Elasticity_tensor]
    type = ComputeElasticityTensor
    block = 0
    fill_method = symmetric_isotropic
    C_ijkl = '1 0'
  [../]

  [./strain]
    type = ComputeSmallStrain
    block = 0
    displacements = 'disp_x disp_y disp_z'
  [../]

  [./stress]
    type = ComputeLinearElasticStress
    block = 0
  [../]

  [./density]
    type = GenericConstantMaterial
    block = 0
    prop_names = 'density'
    prop_values = '1'
  [../]

[]

[Executioner]
  type = Transient
  start_time = 0
  end_time = 6.0
  l_tol = 1e-12
  nl_rel_tol = 1e-12
  dt = 0.1
[]


[Functions]
  [./displacement_bc]
    type = PiecewiseLinear
    data_file = 'sine_wave.csv'
    format = columns
  [../]

[]

[Postprocessors]
  [./_dt]
    type = TimestepSize
  [../]
  [./disp_1]
    type = NodalVariableValue
    nodeid = 1
    variable = disp_y
  [../]
  [./disp_2]
    type = NodalVariableValue
    nodeid = 3
    variable = disp_y
  [../]
  [./disp_3]
    type = NodalVariableValue
    nodeid = 10
    variable = disp_y
  [../]
  [./disp_4]
    type = NodalVariableValue
    nodeid = 14
    variable = disp_y
  [../]
[]

[Outputs]
  exodus = true
  print_perf_log = true
[]
