# Use the exodus file for restarting the problem:
# - restart elemental aux variable

[Mesh]
  file = elem_part1_out.e
  # This problem uses ExodusII_IO::copy_elemental_solution(), which only
  # works with ReplicatedMesh
  parallel_type = replicated
[]

[Functions]
  [./exact_fn]
    type = ParsedFunction
    value = ((x*x)+(y*y))
  [../]

  [./forcing_fn]
    type = ParsedFunction
    value = -4
  [../]
[]

[AuxVariables]
  [./e]
    order = CONSTANT
    family = MONOMIAL
    initial_from_file_var = e
    initial_from_file_timestep = 6
  [../]
[]

[AuxKernels]
  [./ak]
    type = SelfAux
    variable = e
  [../]
[]

[Variables]
  [./u]
    order = FIRST
    family = LAGRANGE
  [../]
[]

[Kernels]
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
    boundary = '0 1 2 3'
    function = exact_fn
  [../]
[]

[Executioner]
  type = Steady

  # Preconditioned JFNK (default)
  solve_type = 'PJFNK'
[]

[Outputs]
  exodus = true
[]
