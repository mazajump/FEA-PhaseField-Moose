# apply a number of "random" configurations and
# check that the algorithm returns to the yield surface
#
# must be careful here - we cannot put in arbitrary values of C_ijkl, otherwise the condition
# df/dsigma * C * flow_dirn < 0 for some stresses
# The important features that must be obeyed are:
# 0 = C_0222 = C_1222  (holds for transversely isotropic, for instance)
# C_0212 < C_0202 = C_1212 (holds for transversely isotropic)

[Mesh]
  type = GeneratedMesh
  dim = 3
  nx = 1
  ny = 1
  nz = 1
  xmin = -0.5
  xmax = 0.5
  ymin = -0.5
  ymax = 0.5
  zmin = -0.5
  zmax = 0.5
[]


[Variables]
  [./disp_x]
  [../]
  [./disp_y]
  [../]
  [./disp_z]
  [../]
[]

[Kernels]
  [./TensorMechanics]
    displacements = 'disp_x disp_y disp_z'
  [../]
[]


[BCs]
  [./bottomx]
    type = PresetBC
    variable = disp_x
    boundary = back
    value = 0.0
  [../]
  [./bottomy]
    type = PresetBC
    variable = disp_y
    boundary = back
    value = 0.0
  [../]
  [./bottomz]
    type = PresetBC
    variable = disp_z
    boundary = back
    value = 0.0
  [../]

  # the following are "random" deformations
  # each is O(1E-5) to keep deformations small
  [./topx]
    type = FunctionPresetBC
    variable = disp_x
    boundary = front
    function = '(sin(0.1*t)+x)/1E1'
  [../]
  [./topy]
    type = FunctionPresetBC
    variable = disp_y
    boundary = front
    function = '(cos(t)+x*y)/1E1'
  [../]
  [./topz]
    type = FunctionPresetBC
    variable = disp_z
    boundary = front
    function = 'sin(0.4321*t)*x*y*z/1E1'
  [../]
[]

[AuxVariables]
  [./wps_internal]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./yield_fcn]
    order = CONSTANT
    family = MONOMIAL
  [../]
[]

[AuxKernels]
  [./wps_internal_auxk]
    type = MaterialStdVectorAux
    property = plastic_internal_parameter
    index = 0
    variable = wps_internal
  [../]
  [./yield_fcn_auxk]
    type = MaterialStdVectorAux
    property = plastic_yield_function
    index = 0
    variable = yield_fcn
  [../]
[]

[Postprocessors]
  [./int]
    type = PointValue
    point = '0 0 0'
    variable = wps_internal
    outputs = 'console'
  [../]
  [./yield_fcn_at_zero]
    type = PointValue
    point = '0 0 0'
    variable = yield_fcn
    outputs = 'console'
  [../]
  [./should_be_zero]
    type = FunctionValuePostprocessor
    function = should_be_zero_fcn
  [../]
[]

[Functions]
  [./should_be_zero_fcn]
    type = ParsedFunction
    value = 'if(a<1E-3,0,a)'
    vars = 'a'
    vals = 'yield_fcn_at_zero'
  [../]
[]

[UserObjects]
  [./coh]
    type = TensorMechanicsHardeningExponential
    value_0 = 1E3
    value_residual = 0
    rate = 0.01
  [../]
  [./tanphi]
    type = TensorMechanicsHardeningExponential
    value_0 = 1
    value_residual = 0.577350269
    rate = 0.01
  [../]
  [./tanpsi]
    type = TensorMechanicsHardeningExponential
    value_0 = 0.08748866
    value_residual = 0.03492077
    rate = 0.01
  [../]
  [./wps]
    type = TensorMechanicsPlasticWeakPlaneShear
    cohesion = coh
    tan_friction_angle = tanphi
    tan_dilation_angle = tanpsi
    smoother = 100
    yield_function_tolerance = 1E-3
    internal_constraint_tolerance = 1E-3
  [../]
[]

[Materials]
  [./elasticity_tensor]
    type = ComputeElasticityTensor
    block = 0
    # the following is transversely isotropic, i think.
    fill_method = symmetric9
    C_ijkl = '3E9 1E9 3E9 3E9 3E9 6E9 1E9 1E9 9E9'
  [../]
  [./strain]
    type = ComputeFiniteStrain
    block = 0
    displacements = 'disp_x disp_y disp_z'
  [../]
  [./mc]
    type = ComputeMultiPlasticityStress
    block = 0
    plastic_models = wps
    transverse_direction = '0 0 1'
    max_NR_iterations = 1000
    ep_plastic_tolerance = 1E-3
    debug_fspb = crash
  [../]
[]


[Executioner]
  end_time = 1E4
  dt = 1
  type = Transient
[]


[Outputs]
  file_base = large_deform_harden3
  exodus = false
  [./csv]
    type = CSV
    [../]
[]
