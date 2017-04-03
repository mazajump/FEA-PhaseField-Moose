###########################################################
# This is a test of the Transfer System. This test
# uses the Multiapp System to solve independent problems
# related geometrically. Solutions are then interpolated
# and transferred to a non-aligned domain.
#
# @Requirement F7.20
###########################################################


[Mesh]
  type = GeneratedMesh
  dim = 2
  nx = 10
  ny = 10
  xmin = .21
  xmax = .79
  displacements = 'disp_x disp_y'
  # The MultiAppInterpolationTransfer object only works with ReplicatedMesh
  parallel_type = replicated
[]

[Variables]
  [./u]
  [../]
[]

[AuxVariables]
  [./disp_x]
    initial_condition = 0.4
  [../]
  [./disp_y]
  [../]
  [./elemental]
    order = CONSTANT
    family = MONOMIAL
  [../]
[]

[Functions]
  [./x_func]
    type = ParsedFunction
    value = x
  [../]
[]

[Kernels]
  [./diff]
    type = Diffusion
    variable = u
  [../]
[]

[AuxKernels]
  [./x_func_aux]
    type = FunctionAux
    variable = elemental
    function = x_func
    execute_on = initial
  [../]
[]

[BCs]
  [./left]
    type = DirichletBC
    variable = u
    boundary = left
    value = 0
  [../]
  [./right]
    type = DirichletBC
    variable = u
    boundary = right
    value = 1
  [../]
[]

[Executioner]
  type = Transient
  num_steps = 1
  dt = 1

  # Preconditioned JFNK (default)
  solve_type = 'PJFNK'

  petsc_options_iname = '-pc_type -pc_hypre_type'
  petsc_options_value = 'hypre boomeramg'
[]

[Outputs]
  exodus = true
[]

[MultiApps]
  [./sub]
    type = TransientMultiApp
    app_type = MooseTestApp
    execute_on = timestep_end
    positions = '0.2 0 0'
    input_files = tosub_sub.i
  [../]
[]

[Transfers]
  [./tosub]
    type = MultiAppInterpolationTransfer
    direction = to_multiapp
    multi_app = sub
    source_variable = u
    variable = from_master
  [../]
  [./elemental_tosub]
    type = MultiAppInterpolationTransfer
    direction = to_multiapp
    multi_app = sub
    source_variable = u
    variable = elemental_from_master
  [../]
  [./radial_tosub]
    type = MultiAppInterpolationTransfer
    direction = to_multiapp
    multi_app = sub
    source_variable = u
    variable = radial_from_master
    interp_type = radial_basis
  [../]
  [./radial_elemental_tosub]
    type = MultiAppInterpolationTransfer
    direction = to_multiapp
    multi_app = sub
    source_variable = u
    variable = radial_elemental_from_master
    interp_type = radial_basis
  [../]
  [./displaced_target_tosub]
    type = MultiAppInterpolationTransfer
    direction = to_multiapp
    multi_app = sub
    source_variable = u
    variable = displaced_target_from_master
    displaced_target_mesh = true
  [../]
  [./displaced_source_tosub]
    type = MultiAppInterpolationTransfer
    direction = to_multiapp
    multi_app = sub
    source_variable = u
    variable = displaced_source_from_master
    displaced_source_mesh = true
  [../]
  [./elemental_to_sub_elemental]
    type = MultiAppInterpolationTransfer
    direction = to_multiapp
    multi_app = sub
    source_variable = elemental
    variable = elemental_from_master_elemental
  [../]
  [./elemental_to_sub_nodal]
    type = MultiAppInterpolationTransfer
    direction = to_multiapp
    multi_app = sub
    source_variable = elemental
    variable = nodal_from_master_elemental
  [../]
[]
