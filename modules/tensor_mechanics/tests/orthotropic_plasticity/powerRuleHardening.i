# UserObject Orthotropic test, with power rule hardening with rate 1e1.
# Linear strain is applied in the x direction.

[Mesh]
  type = GeneratedMesh
  dim = 3
  nx = 1
  ny = 1
  nz = 1
  xmin =  -.5
  xmax = .5
  ymin = -.5
  ymax = .5
  zmin = -.5
  zmax = .5
[]

[GlobalParams]
  displacements = 'disp_x disp_y disp_z'
[]

[Modules/TensorMechanics/Master]
  [./all]
    strain = FINITE
    add_variables = true
    generate_output = 'stress_xx stress_yy stress_zz stress_xy stress_yz'
  [../]
[]

[BCs]
  [./xdisp]
    type = FunctionPresetBC
    variable = disp_x
    boundary = 'right'
    function = '0.005*t'
  [../]
  [./yfix]
    type = PresetBC
    variable = disp_y
    #boundary = 'bottom top'
    boundary = 'bottom'
    value = 0
  [../]
  [./xfix]
    type = PresetBC
    variable = disp_x
    boundary = 'left'
    value = 0
  [../]
  [./zfix]
    type = PresetBC
    variable = disp_z
    #boundary = 'front back'
    boundary = 'back'
    value = 0
  [../]
[]

[AuxVariables]
  [./stress_xz]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./plastic_xx]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./plastic_xy]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./plastic_xz]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./plastic_yy]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./plastic_yz]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./plastic_zz]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./f]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./iter]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./intnl]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./sdev]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./sdet]
    order = CONSTANT
    family = MONOMIAL
  [../]
[]

[AuxKernels]
  [./stress_xz]
    type = RankTwoAux
    rank_two_tensor = stress
    variable = stress_xz
    index_i = 0
    index_j = 2
  [../]
  [./plastic_xx]
    type = RankTwoAux
    rank_two_tensor = plastic_strain
    variable = plastic_xx
    index_i = 0
    index_j = 0
  [../]
  [./plastic_xy]
    type = RankTwoAux
    rank_two_tensor = plastic_strain
    variable = plastic_xy
    index_i = 0
    index_j = 1
  [../]
  [./plastic_xz]
    type = RankTwoAux
    rank_two_tensor = plastic_strain
    variable = plastic_xz
    index_i = 0
    index_j = 2
  [../]
  [./plastic_yy]
    type = RankTwoAux
    rank_two_tensor = plastic_strain
    variable = plastic_yy
    index_i = 1
    index_j = 1
  [../]
  [./plastic_yz]
    type = RankTwoAux
    rank_two_tensor = plastic_strain
    variable = plastic_yz
    index_i = 1
    index_j = 2
  [../]
  [./plastic_zz]
    type = RankTwoAux
    rank_two_tensor = plastic_strain
    variable = plastic_zz
    index_i = 2
    index_j = 2
  [../]
  [./f]
    type = MaterialStdVectorAux
    index = 0
    property = plastic_yield_function
    variable = f
  [../]
  [./iter]
    type = MaterialRealAux
    property = plastic_NR_iterations
    variable = iter
  [../]
  [./intnl]
    type = MaterialStdVectorAux
    index = 0
    property = plastic_internal_parameter
    variable = intnl
  [../]
  [./sdev]
    type = RankTwoScalarAux
    variable = sdev
    rank_two_tensor = stress
    scalar_type = VonMisesStress
  [../]
[]

[Postprocessors]
  [./sdev]
    type = PointValue
    point = '0 0 0'
    variable = sdev
  [../]
  [./s_xx]
    type = PointValue
    point = '0 0 0'
    variable = stress_xx
  [../]
  [./p_xx]
    type = PointValue
    point = '0 0 0'
    variable = plastic_xx
  [../]
  [./s_xy]
    type = PointValue
    point = '0 0 0'
    variable = stress_xy
  [../]
  [./p_xy]
    type = PointValue
    point = '0 0 0'
    variable = plastic_xy
  [../]
  [./p_xz]
    type = PointValue
    point = '0 0 0'
    variable = plastic_xz
  [../]
  [./p_yz]
    type = PointValue
    point = '0 0 0'
    variable = plastic_yz
  [../]
  [./s_xz]
    type = PointValue
    point = '0 0 0'
    variable = stress_xz
  [../]
  [./s_yy]
    type = PointValue
    point = '0 0 0'
    variable = stress_yy
  [../]
  [./p_yy]
    type = PointValue
    point = '0 0 0'
    variable = plastic_yy
  [../]
  [./s_yz]
    type = PointValue
    point = '0 0 0'
    variable = stress_yz
  [../]
  [./s_zz]
    type = PointValue
    point = '0 0 0'
    variable = stress_zz
  [../]
  [./p_zz]
    type = PointValue
    point = '0 0 0'
    variable = plastic_zz
  [../]
  [./intnl]
    type = PointValue
    point = '0 0 0'
    variable = intnl
  [../]
[]

[UserObjects]
  [./str]
    type = TensorMechanicsHardeningPowerRule
    value_0 = 300
    epsilon0 = 1
    exponent = 1e1

  [../]
  [./Orthotropic]
    type = TensorMechanicsPlasticOrthotropic
    b = -0.1
    c1 = '1 1 1 1 1 1'
    c2 = '1 1 1 1 1 1'
    associative = true
    yield_strength = str
    yield_function_tolerance = 1e-5
    internal_constraint_tolerance = 1e-9
    use_custom_returnMap = false
    use_custom_cto = false
  [../]
[]

[Materials]
  [./elasticity_tensor]
    type = ComputeElasticityTensor
    block = 0
    fill_method = symmetric_isotropic
    C_ijkl = '121e3 80e3'
  [../]
  [./mc]
    type = ComputeMultiPlasticityStress
    block = 0
    ep_plastic_tolerance = 1e-9
    plastic_models = Orthotropic
    debug_fspb = crash
    tangent_operator = elastic
  [../]
[]


[Executioner]
  type = Transient

  num_steps = 3
  dt = .25

  nl_rel_tol = 1e-6
  nl_max_its = 10
  l_tol = 1e-4
  l_max_its = 50

  solve_type = PJFNK
  petsc_options_iname = '-pc_type'
  petsc_options_value = 'lu'
[]

[Preconditioning]
  [./fdp]
    type = FDP
    full = true
  [../]
[]

[Outputs]
  print_perf_log = false
  csv = true
[]
