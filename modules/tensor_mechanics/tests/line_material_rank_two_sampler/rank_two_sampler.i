[GlobalParams]
  displacements = 'x_disp y_disp z_disp'
[]

[Mesh]
  type = GeneratedMesh
  dim = 3
  nx = 3
  ny = 3
  nz = 3
  elem_type = HEX
[]

[Functions]
  [./rampConstant]
    type = PiecewiseLinear
    x = '0. 1.'
    y = '0. 1.'
    scale_factor = 1e-6
  [../]
[]

[Variables]
  [./x_disp]
    order = FIRST
    family = LAGRANGE
  [../]
  [./y_disp]
    order = FIRST
    family = LAGRANGE
  [../]
  [./z_disp]
    order = FIRST
    family = LAGRANGE
  [../]
[]

[AuxVariables]
 [./stress_xx]
    order = CONSTANT
    family = MONOMIAL
 [../]
[]

[AuxKernels]
  [./stress_xx]
    type = RankTwoAux
    rank_two_tensor = stress
    variable = stress_xx
    index_i = 0
    index_j = 0
  [../]
[]

[VectorPostprocessors]
  [./stress_xx]
    type = LineMaterialRankTwoSampler
    start = '0.1667 0.5 0.5'
    end   = '0.8333 0.5 0.5'
    property = stress
    index_i = 0
    index_j = 0
    sort_by = id
  [../]
[]

[Kernels]
  [./TensorMechanics]
    use_displaced_mesh = true
  [../]
[]

[BCs]
  [./front]
    type = FunctionDirichletBC
    variable = z_disp
    boundary = 5
    function = rampConstant
  [../]
  [./back_x]
    type = DirichletBC
    variable = x_disp
    boundary = 0
    value = 0.0
  [../]
  [./back_y]
    type = DirichletBC
    variable = y_disp
    boundary = 0
    value = 0.0
  [../]
  [./back_z]
    type = DirichletBC
    variable = z_disp
    boundary = 0
    value = 0.0
  [../]
[]

[Materials]
  [./elast_tensor]
    type = ComputeIsotropicElasticityTensor
    youngs_modulus = 1e6
    poissons_ratio = .3
  [../]
  [./strain]
    type = ComputeSmallStrain
  [../]
  [./stress]
    type = ComputeLinearElasticStress
  [../]
[]

[Executioner]
  type = Transient

  solve_type = PJFNK

  l_max_its = 100

  start_time = 0.0
  num_steps = 99999
  end_time = 1.0
  dt = 0.1
[]

[Outputs]
  file_base = rank_two_sampler_out
  exodus = true
  csv = true
[]
