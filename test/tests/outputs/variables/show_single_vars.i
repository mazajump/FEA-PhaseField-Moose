[Mesh]
  type = GeneratedMesh
  dim = 2
  xmin = 0
  xmax = 1
  ymin = 0
  ymax = 1
  nx = 10
  ny = 10
  elem_type = QUAD4
  # This test uses ElementalVariableValue postprocessors on specific
  # elements, if you use DistributedMesh the elements get renumbered.
  parallel_type = replicated
[]

[Functions]
  [./ffn]
    type = ParsedFunction
    value = -4
  [../]

  [./exactfn]
    type = ParsedFunction
    value = x*x+y*y
  [../]

  [./aux_exact_fn]
    type = ParsedFunction
    value = t*(x*x+y*y)
  [../]
[]

[Variables]
  [./u]
    order = FIRST
    family = LAGRANGE
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

  [./force]
    type = UserForcingFunction
    variable = u
    function = ffn
  [../]
[]

[AuxVariables]
  [./aux_u]
    order = CONSTANT
    family = MONOMIAL
  [../]
[]

[AuxKernels]
  [./a]
    type = FunctionAux
    variable = aux_u
    function = aux_exact_fn
  [../]
[]

[BCs]
  [./left]
    type = FunctionDirichletBC
    variable = u
    boundary = '0 1 2 3'
    function = exactfn
  [../]
[]

[Postprocessors]
  [./elem_56]
    type = ElementalVariableValue
    variable = u
    elementid = 56
  [../]

  [./aux_elem_99]
    type = ElementalVariableValue
    variable = aux_u
    elementid = 99
  [../]
[]

[Executioner]
  type = Transient
  solve_type = 'PJFNK'
  dt = 0.01
  start_time = 0
  num_steps = 1
[]

[Outputs]
  exodus = true
  show = 'aux_u'
[]
