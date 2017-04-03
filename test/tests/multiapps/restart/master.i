[Mesh]
  type = GeneratedMesh
  dim = 2
  xmin = 0
  ymin = 0
  xmax = 1
  ymax = 1
  nx = 10
  ny = 10
[]

[Functions]
  [./v_fn]
    type = ParsedFunction
    value = t*x
  [../]
  [./ffn]
    type = ParsedFunction
    value = x
  [../]
[]

[AuxVariables]
  [./v]
  [../]
[]

[Variables]
  [./u]
  [../]
[]

[Kernels]
  [./diff]
    type = Diffusion
    variable = u
  [../]
  [./td]
    type = TimeDerivative
    variable = u
  [../]
  [./ufn]
    type = UserForcingFunction
    variable = u
    function = ffn
  [../]
[]

[BCs]
  [./all]
    type = FunctionDirichletBC
    variable = u
    boundary = 'left right top bottom'
    function = v_fn
  [../]
[]

[Executioner]
  type = Transient
  num_steps = 5
  dt = 0.1
  solve_type = 'PJFNK'
[]

[Outputs]
  exodus = true
  checkpoint = true
[]

[MultiApps]
  [./sub_app]
    app_type = MooseTestApp
    type = TransientMultiApp
    input_files = 'sub.i'
    execute_on = timestep_end
    positions = '0 -1 0'
  [../]
[]

[Transfers]
  [./from_sub]
    type = MultiAppNearestNodeTransfer
    direction = from_multiapp
    multi_app = sub_app
    source_variable = u
    variable = v
  [../]
[]
