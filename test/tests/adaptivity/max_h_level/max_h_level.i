[Mesh]
  type = GeneratedMesh
  dim = 2
  nx = 10
  ny = 10
  nz = 0
  zmax = 0
  elem_type = QUAD4
[]

[Variables]
  [./u]
    order = FIRST
    family = LAGRANGE
  [../]
[]

[Functions]
  [./force]
    type = ParsedFunction
    value = t
  [../]
[]

[Kernels]
  [./diff]
    type = Diffusion
    variable = u
  [../]
  [./force]
    type = UserForcingFunction
    variable = u
    function = force
  [../]
[]

[BCs]
  [./right]
    type = DirichletBC
    variable = u
    boundary = right
    value = 1
  [../]
  [./left]
    type = DirichletBC
    variable = u
    boundary = left
    value = 0
  [../]
[]

[Executioner]
  # Preconditioned JFNK (default)
  type = Transient
  num_steps = 4
  dt = 1
  solve_type = PJFNK
[]

[Adaptivity]
  steps = 1
  marker = box
  max_h_level = 2
  [./Markers]
    [./box]
      bottom_left = '0.3 0.3 0'
      inside = refine
      top_right = '0.6 0.6 0'
      outside = do_nothing
      type = BoxMarker
    [../]
  [../]
[]

[Outputs]
  execute_on = 'timestep_end'
  [./out]
    type = Exodus
    execute_scalars_on = none
  [../]
[]
