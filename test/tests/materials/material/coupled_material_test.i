[Mesh]
  type = GeneratedMesh
  dim = 2
  xmin = 0
  xmax = 1
  ymin = 0
  ymax = 1
  nx = 10
  ny = 10
[]

[Variables]
  [./u]
    order = FIRST
    family = LAGRANGE
  [../]
[]

[Kernels]
  [./diff]
    type = MatDiffusion
    variable = u
    prop_name = mp1
  [../]

  [./conv]
    type = MatConvection
    variable = u
    x = 1
    y = 0
    mat_prop = some_prop
  [../]
[]

[BCs]
  [./right]
    type = NeumannBC
    variable = u
    boundary = 1
    value = 1
  [../]

  [./left]
    type = DirichletBC
    variable = u
    boundary = 3
    value = 0
  [../]
[]

[Materials]
  # order is switched intentionally, so we won't get luck and dep-resolver has to do its job
  [./mat2]
    type = CoupledMaterial
    block = 0
    mat_prop = 'some_prop'
    coupled_mat_prop = 'mp1'
  [../]

  [./mat1]
    type = GenericConstantMaterial
    block = 0
    prop_names = 'mp1'
    prop_values = '2'
  [../]
[]

[Executioner]
  type = Steady

  # Preconditioned JFNK (default)
  solve_type = 'PJFNK'
[]

[Outputs]
  file_base = out_coupled
  exodus = true
[]
