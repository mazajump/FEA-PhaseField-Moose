[Mesh]
  file = cube-hole.e
[]

[Variables]
  [./convected]
    order = FIRST
    family = LAGRANGE
  [../]
  [./diffused]
    order = FIRST
    family = LAGRANGE
  [../]
[]

[Kernels]
  [./example_diff]
    type = ExampleCoefDiffusion
    variable = convected
    coef = 0.125
  [../]
  [./conv]
    type = ExampleConvection
    variable = convected
    some_variable = diffused
  [../]
  [./diff]
    type = Diffusion
    variable = diffused
  [../]
[]

[BCs]
  # convected=0 on all vertical sides except the right (x-max)
  [./cylinder_convected]
    type = DirichletBC
    variable = convected
    boundary = inside
    value = 1
  [../]
  [./exterior_convected]
    type = DirichletBC
    variable = convected
    boundary = 'left top bottom'
    value = 0
  [../]
  [./left_diffused]
    type = DirichletBC
    variable = diffused
    boundary = left
    value = 0
  [../]
  [./right_diffused]
    type = DirichletBC
    variable = diffused
    boundary = right
    value = 10
  [../]
[]

[Executioner]
  type = Steady
  solve_type = 'PJFNK'

  l_tol = 1e-3
  nl_rel_tol = 1e-6
  nl_abs_tol = 1e-9
[]

[Adaptivity]
  marker = errorfrac
  steps = 2
  [./Indicators]
    [./error]
      type = GradientJumpIndicator
      variable = convected
      outputs = none
    [../]
  [../]
  [./Markers]
    [./errorfrac]
      type = ErrorFractionMarker
      refine = 0.5
      coarsen = 0
      indicator = error
      outputs = none
    [../]
  [../]
[]

[Outputs]
  execute_on = 'timestep_end'
  exodus = true
[]
