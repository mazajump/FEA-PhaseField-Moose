###########################################################
# This is a simple test of the restart/recover capability.
# The test object "RestartableTypesChecker" is used
# to reload data from a previous simulation written out
# with the object "RestartableTypes".
#
# See "restartable_types.i"
#
# @Requirement F1.60
###########################################################


[Mesh]
  type = GeneratedMesh
  dim = 2
  nx = 10
  ny = 10
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

[UserObjects]
  [./restartable_types]
    type = RestartableTypesChecker
  [../]
[]

[Problem]
  type = FEProblem
  solve = false
[]

[Executioner]
  # Preconditioned JFNK (default)
  type = Steady
  solve_type = PJFNK
  petsc_options_iname = '-pc_type -pc_hypre_type'
  petsc_options_value = 'hypre boomeramg'
[]

[Outputs]
  exodus = true
[]

[Problem]
  restart_file_base = restartable_types_out_cp/LATEST
[]
