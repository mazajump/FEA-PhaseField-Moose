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
  active = 'x_disp y_disp z_disp'

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
  [./vonmises]
    order = CONSTANT
    family = MONOMIAL
 [../]
 [./stress_xx]
    order = CONSTANT
    family = MONOMIAL
 [../]
[]

[AuxKernels]
  [./vonmises]
    type = MaterialTensorAux
    tensor = stress
    variable = vonmises
    quantity = vonmises
  [../]
[]

[VectorPostprocessors]
  [./vonmises]
    type = LineMaterialSymmTensorSampler
    start = '0.1667 0.5 0.5'
    end   = '0.8333 0.5 0.5'
    property = stress
    quantity = vonmises
    sort_by = id
  [../]
[]

[SolidMechanics]
  [./solid]
    disp_x = x_disp
    disp_y = y_disp
    disp_z = z_disp
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
  [./constant]
    type = LinearIsotropicMaterial
    block = 0
    youngs_modulus = 1e6
    poissons_ratio = .3
    disp_x = x_disp
    disp_y = y_disp
    disp_z = z_disp
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
  file_base = out
  exodus = true
  csv = true
[]


