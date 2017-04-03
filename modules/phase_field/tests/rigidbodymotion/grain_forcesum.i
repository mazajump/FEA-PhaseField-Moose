# test file for showing summing forces and torques obtained from other userobjects
[GlobalParams]
  var_name_base = eta
  op_num = 2
[]

[Mesh]
  type = GeneratedMesh
  dim = 2
  nx = 5
  ny = 3
  nz = 0
  xmax = 50
  ymax = 25
  zmax = 0
  elem_type = QUAD4
[]

[Variables]
  [./c]
    order = FIRST
    family = LAGRANGE
    [./InitialCondition]
      type = SpecifiedSmoothCircleIC
      invalue = 1.0
      outvalue = 0.1
      int_width = 6.0
      x_positions = '20.0 30.0 '
      z_positions = '0.0 0.0 '
      y_positions = '0.0 25.0 '
      radii = '14.0 14.0'
      3D_spheres = false
      variable = c
    [../]
  [../]
  [./w]
    order = FIRST
    family = LAGRANGE
  [../]
[]

[Kernels]
  [./c_res]
    type = SplitCHParsed
    variable = c
    f_name = F
    kappa_name = kappa_c
    w = w
  [../]
  [./w_res]
    type = SplitCHWRes
    variable = w
    mob_name = M
  [../]
  [./time]
    type = CoupledTimeDerivative
    variable = w
    v = c
  [../]
[]

[Materials]
  [./pfmobility]
    type = GenericConstantMaterial
    prop_names = 'M    kappa_c  kappa_eta'
    prop_values = '5.0  2.0      0.1'
  [../]
  [./free_energy]
    type = DerivativeParsedMaterial
    f_name = F
    args = c
    constant_names = 'barr_height  cv_eq'
    constant_expressions = '0.1          1.0e-2'
    function = 16*barr_height*(c-cv_eq)^2*(1-cv_eq-c)^2
    derivative_order = 2
  [../]
  [./force_density]
    type = ForceDensityMaterial
    c = c
    etas ='eta0 eta1'
  [../]
[]

[AuxVariables]
  [./eta0]
  [../]
  [./eta1]
  [../]
  [./bnds]
  [../]
  [./df00]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./df01]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./df10]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./df11]
    order = CONSTANT
    family = MONOMIAL
  [../]
[]

[ICs]
  [./ic_eta0]
    int_width = 6.0
    x1 = 20.0
    y1 = 0.0
    radius = 14.0
    outvalue = 0.0
    variable = eta0
    invalue = 1.0
    type = SmoothCircleIC
  [../]
  [./IC_eta1]
    int_width = 6.0
    x1 = 30.0
    y1 = 25.0
    radius = 14.0
    outvalue = 0.0
    variable = eta1
    invalue = 1.0
    type = SmoothCircleIC
  [../]
[]

[VectorPostprocessors]
  [./forces_dns]
    type = GrainForcesPostprocessor
    grain_force = grain_force_dns
  [../]
  [./forces_cosnt]
    type = GrainForcesPostprocessor
    grain_force = grain_force_const
  [../]
  [./forces_total]
    type = GrainForcesPostprocessor
    grain_force = grain_force
  [../]
[]

[UserObjects]
  [./grain_center]
    type = GrainTracker
    outputs = none
    compute_var_to_feature_map = true
    execute_on = 'initial timestep_begin'
  [../]
  [./grain_force_dns]
    type = ComputeGrainForceAndTorque
    c = c
    etas = 'eta0 eta1'
    execute_on = 'linear nonlinear'
    grain_data = grain_center
    force_density = force_density
  [../]
  [./grain_force_const]
    type = ConstantGrainForceAndTorque
    execute_on = 'linear nonlinear'
    force =  '2.0 0.0 0.0 0.0 0.0 0.0'
    torque = '0.0 0.0 0.0 0.0 0.0 0.0'
  [../]
  [./grain_force]
    type = GrainForceAndTorqueSum
    execute_on = 'linear nonlinear'
    grain_forces = 'grain_force_dns grain_force_const'
    grain_num = 2
  [../]
[]

[Preconditioning]
  [./SMP]
    type = SMP
    full = true
  [../]
[]

[Executioner]
  type = Transient
  scheme = bdf2
  solve_type = NEWTON
  petsc_options_iname = '-pc_type -ksp_gmres_restart -sub_ksp_type -sub_pc_type -pc_asm_overlap'
  petsc_options_value = 'asm         31   preonly   lu      1'
  l_max_its = 20
  nl_max_its = 20
  l_tol = 1.0e-4
  nl_rel_tol = 1.0e-10
  start_time = 0.0
  num_steps = 2
  dt = 0.1
[]

[Outputs]
  exodus = true
  csv = true
[]
