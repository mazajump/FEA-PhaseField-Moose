[Mesh]
  type = GeneratedMesh
  dim = 2
  nx = 10
  ny = 1
[]

[MeshModifiers]
  [./left_domain]
    type = SubdomainBoundingBox
    bottom_left = '0 0 0'
    top_right = '0.5 1 0'
    block_id = 10
  [../]
[]


[Variables]
  [./u]
    initial_condition = 2
  [../]
[]

[Kernels]
  [./diff]
    type = MatDiffusion
    variable = u
    prop_name = 'p'
  [../]
[]

[BCs]
  [./left]
    type = DirichletBC
    variable = u
    boundary = left
    value = 2
  [../]
  [./right]
    type = DirichletBC
    variable = u
    boundary = right
    value = 3
  [../]
[]

[Materials]

  [./recompute_props]
    type = RecomputeMaterial
    boundary = 'left'
    f_name = 'f'
    f_prime_name = 'f_prime'
    p_name = 'p'
    outputs = all
    output_properties = 'f f_prime p'
  [../]

  [./newton]
    type = NewtonMaterial
    boundary = 'left right'
    outputs = all
    f_name = 'f'
    f_prime_name = 'f_prime'
    p_name = 'p'
    material = 'recompute_props'
  [../]

  [./left]
    type = GenericConstantMaterial
    prop_names =  'f f_prime'
    prop_values = '1 0.5    '
    block = '10 0'
    outputs = all
  [../]
[]

[Executioner]
  type = Steady
  solve_type = PJFNK
  petsc_options_iname = '-pc_type -pc_hypre_type'
  petsc_options_value = 'hypre boomeramg'
[]

[Outputs]
  exodus = true
  print_linear_residuals = true
  print_perf_log = true
[]
