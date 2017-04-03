[Mesh]
  type = GeneratedMesh
  dim = 3
  nx = 22
  ny = 22
  nz = 22
  xmin = 0
  xmax = 100
  ymin = 0
  ymax = 100
  zmin = 0
  zmax = 100
  elem_type = HEX8
[]

[Variables]
  [./c]
    order = FIRST
    family = LAGRANGE
  [../]
[]

[Kernels]
  [./ie_c]
    type = TimeDerivative
    variable = c
  [../]
  [./diff]
    type = MatDiffusion
    variable = c
    D_name = D_v
  [../]
[]

[ICs]
  [./c]
    type = SpecifiedSmoothCircleIC
    variable = c
    x_positions = '10 50 90'
    y_positions = '30 20 80'
    z_positions = '25 45 75'
    radii = '14 25 16'
    invalue = 1.0
    outvalue = 0.0001
    int_width = 4
  [../]
[]

[BCs]
  [./Periodic]
    [./all]
      auto_direction = 'x y'
    [../]
  [../]
[]

[Materials]
  [./Dv]
    type = GenericConstantMaterial
    prop_names = D_v
    prop_values = 0.074802
  [../]
[]

[Postprocessors]
  [./bubbles]
    type = FeatureFloodCount
    variable = c
    execute_on = 'initial timestep_end'
  [../]
[]

[Executioner]
  # Preconditioned JFNK (default)
  type = Transient
  scheme = bdf2
  solve_type = PJFNK
  petsc_options_iname = '-pc_type -pc_hypre_type -ksp_gmres_restart -mat_mffd_type'
  petsc_options_value = 'hypre boomeramg 101 ds'
  l_max_its = 20
  l_tol = 1e-4
  nl_max_its = 20
  nl_rel_tol = 1e-9
  nl_abs_tol = 1e-11
  start_time = 0.0
  num_steps = 1
  dt = 100.0
  [./Adaptivity]
    refine_fraction = .5
  [../]
[]

[Outputs]
  exodus = true
[]
