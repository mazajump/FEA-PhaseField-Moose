[Mesh]
  type = GeneratedMesh
  dim = 2
  xmin = -1
  xmax =  1
  ymin = -1
  ymax =  1
  nx = 2
  ny = 2
  elem_type = QUAD9
[]

[Functions]
  [./exact_fn]
    type = ParsedFunction
    value = t*t*(x*x+y*y)
  [../]

  [./forcing_fn]
    type = ParsedFunction
    value = 2*t*(x*x+y*y)-4*t*t
  [../]
[]

[Variables]
  [./u]
    family = LAGRANGE
    order = SECOND
  [../]
[]

[ICs]
  [./u_var]
    type = FunctionIC
    variable = u
    function = exact_fn
  [../]
[]

[Kernels]
  [./td]
    type = TimeDerivative
    variable = u
  [../]

  [./diff]
    type = Diffusion
    variable = u
  [../]

  [./ffn]
    type = UserForcingFunction
    variable = u
    function = forcing_fn
  [../]
[]

[BCs]
  [./all]
    type = FunctionDirichletBC
    variable = u
    boundary = 'left right top bottom'
    function = exact_fn
  [../]
[]

[Executioner]
  type = Transient
  end_time = 4.0
  [./TimeStepper]
    type = TimeSequenceStepper
    time_sequence  = '0   0.85 1.3 2 4'
  [../]
[]

[Outputs]
  exodus = true
  [./checkpoint]
    type = Checkpoint
    num_files = 4
  [../]
[]
