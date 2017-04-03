[Mesh]
  type = GeneratedMesh
  dim = 2
  nx = 10
  ny = 10
[]

[Variables]
  [./v]
  [../]
[]

[AuxVariables]
  [./v2]
  [../]
[]

[Kernels]
  [./diff_v]
    type = Diffusion
    variable = v
  [../]
  [./coupled_force]
    type = CoupledForce
    variable = v
    v = v2
  [../]
  [./td_v]
    type = TimeDerivative
    variable = v
  [../]
[]

[BCs]
  [./left_v]
    type = DirichletBC
    variable = v
    boundary = left
    value = 1
  [../]
  [./right_v]
    type = DirichletBC
    variable = v
    boundary = right
    value = 0
  [../]
[]

[Executioner]
  # Preconditioned JFNK (default)
  type = Transient
  num_steps = 5
  dt = 1
  solve_type = PJFNK
  petsc_options_iname = '-pc_type -pc_hypre_type'
  petsc_options_value = 'hypre boomeramg'
  picard_max_its = 30
  nl_rel_tol = 1e-8
  nl_abs_tol = 1e-9
  picard_rel_tol = 1e-8
  picard_abs_tol = 1e-9
[]

[Outputs]
  exodus = true
[]

[MultiApps]
  [./sub2]
    type = TransientMultiApp
    app_type = MooseTestApp
    positions = '0 0 0'
    input_files = picard_sub2.i
    sub_cycling = true
    execute_on = timestep_end
  [../]
[]

[Transfers]
  [./v2]
    type = MultiAppNearestNodeTransfer
    direction = from_multiapp
    multi_app = sub2
    source_variable = v
    variable = v2
  [../]
[]
