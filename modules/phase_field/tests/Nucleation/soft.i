[Mesh]
  type = GeneratedMesh
  dim = 2
  nx = 10
  ny = 10
  xmin = -3
  xmax = 10
  ymin = -3
  ymax = 10
[]

[Variables]
  [./c]
    order = FIRST
    family = LAGRANGE
    initial_condition = 0
  [../]
[]

[Kernels]
  [./c]
    type = Diffusion
    #D_name = F
    variable = c
  [../]
  [./dt]
    type = TimeDerivative
    variable = c
  [../]
[]

[Materials]
  [./nucleation]
    type = DiscreteNucleation
    op_names  = c
    op_values = 1
    penalty = 10
    map = map
    outputs = exodus
  [../]
[]

[UserObjects]
  [./inserter]
    type = DiscreteNucleationInserter
    hold_time = 1
    probability = 0
    test = '0 0 0'
    execute_on = 'TIMESTEP_END'
  [../]
  [./map]
    type = DiscreteNucleationMap
    radius = 7
    int_width = 6
    inserter = inserter
  [../]
[]

[Executioner]
  type = Transient
  solve_type = 'NEWTON'
  num_steps = 2
  dt = 0.1
[]

[Outputs]
  execute_on = 'timestep_end'
  interval = 2
  exodus = true
  hide = c
[]
