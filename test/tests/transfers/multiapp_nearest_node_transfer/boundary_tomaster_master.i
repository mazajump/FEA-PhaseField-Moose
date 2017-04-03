# Master mesh and sub mesh are same with 4x4 quad8 elements.
# master mesh has top boundary fixed at u=2 and bottom fixed at u=0
# sub mesh has top boundary fixed at u = 0 and bottom firxed at u=1
# The u variable at right boundary of sub mesh is transferred to
# from_sub variable of master mesh at left boundary

# Result is from_sub at left boundary has linearly increasing value starting
# with 0 at top and ending with 1 at bottom. from_sub is zero everywhere else
# in the master mesh.

[Mesh]
  type = GeneratedMesh
  dim = 2
  nx = 4
  ny = 4
  elem_type = QUAD8
[]

[Variables]
  [./u]
    family = LAGRANGE
    order = FIRST
  [../]
[]

[AuxVariables]
  [./from_sub]
    family = LAGRANGE
    order = SECOND
  [../]
[]

[Kernels]
  [./diff]
    type = Diffusion
    variable = u
  [../]
[]

[BCs]
  [./top]
    type = DirichletBC
    variable = u
    boundary = top
    value = 2.0
  [../]
  [./bottom]
    type = DirichletBC
    variable = u
    boundary = bottom
    value = 0.0
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
    positions = '0 0 0'
    input_files = boundary_tomaster_sub.i
  [../]
[]

[Transfers]
  [./from_sub]
    type = MultiAppNearestNodeTransfer
    direction = from_multiapp
    multi_app = sub
    source_variable = u
    source_boundary = right
    target_boundary = left
    variable = from_sub
  [../]
[]
