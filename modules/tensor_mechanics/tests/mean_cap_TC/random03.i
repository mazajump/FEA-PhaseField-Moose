# apply many random large deformations, checking that the algorithm returns correctly to
# the yield surface each time.
[Mesh]
  type = GeneratedMesh
  dim = 3
  nx = 1000
  ny = 125
  nz = 1
  xmin = 0
  xmax = 1000
  ymin = 0
  ymax = 125
  zmin = 0
  zmax = 1
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


[ICs]
  [./x]
    type = RandomIC
    min = -0.1
    max = 0.1
    variable = disp_x
  [../]
  [./y]
    type = RandomIC
    min = -0.1
    max = 0.1
    variable = disp_y
  [../]
  [./z]
    type = RandomIC
    min = -0.1
    max = 0.1
    variable = disp_z
  [../]
[]

[BCs]
  [./x]
    type = FunctionPresetBC
    variable = disp_x
    boundary = 'front back'
    function = '0'
  [../]
  [./y]
    type = FunctionPresetBC
    variable = disp_y
    boundary = 'front back'
    function = '0'
  [../]
  [./z]
    type = FunctionPresetBC
    variable = disp_z
    boundary = 'front back'
    function = '0'
  [../]
[]

[AuxVariables]
  [./yield_fcn]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./iter]
    order = CONSTANT
    family = MONOMIAL
  [../]
[]

[AuxKernels]
  [./yield_fcn_auxk]
    type = MaterialStdVectorAux
    index = 0
    property = plastic_yield_function
    variable = yield_fcn
  [../]
  [./iter]
    type = MaterialRealAux
    property = plastic_NR_iterations
    variable = iter
  [../]
[]

[Postprocessors]
  [./max_yield_fcn]
    type = ElementExtremeValue
    variable = yield_fcn
    outputs = 'console'
  [../]
  [./should_be_zero]
    type = FunctionValuePostprocessor
    function = should_be_zero_fcn
  [../]
  [./av_iter]
    type = ElementAverageValue
    variable = iter
    outputs = 'console'
  [../]
[]

[Functions]
  [./should_be_zero_fcn]
    type = ParsedFunction
    value = 'if(a<1E-3,0,a)'
    vars = 'a'
    vals = 'max_yield_fcn'
  [../]
[]

[UserObjects]
  [./tensile_strength]
    type = TensorMechanicsHardeningCubic
    value_0 = 1
    value_residual = 0.1
    internal_limit = 0.1
  [../]
  [./compressive_strength]
    type = TensorMechanicsHardeningCubic
    value_0 = -1.5
    value_residual = 0
    internal_limit = 0.1
  [../]
  [./cap]
    type = TensorMechanicsPlasticMeanCapTC
    tensile_strength = tensile_strength
    compressive_strength = compressive_strength
    yield_function_tolerance = 1E-5
    internal_constraint_tolerance = 1E-11
    use_custom_returnMap = false
    use_custom_cto = false
  [../]
[]

[Materials]
  [./elasticity_tensor]
    type = ComputeElasticityTensor
    block = 0
    fill_method = symmetric_isotropic
    C_ijkl = '0.7E7 1E7'
  [../]
  [./strain]
    type = ComputeIncrementalSmallStrain
    block = 0
    displacements = 'disp_x disp_y disp_z'
  [../]
  [./mc]
    type = ComputeMultiPlasticityStress
    block = 0
    max_NR_iterations = 2
    ep_plastic_tolerance = 1E-8
    plastic_models = cap
  [../]
[]


[Executioner]
  end_time = 1
  dt = 1
  type = Transient
[]


[Outputs]
  file_base = random03
  exodus = false
  [./csv]
    type = CSV
  [../]
[]
