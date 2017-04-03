[Mesh]
  # This test uses SolutionUserObject which doesn't work with DistributedMesh.
  type = FileMesh
  file = cubesource.e
  parallel_type = replicated
[]

[Variables]
  [./u]
    order = FIRST
    family = LAGRANGE
    initial_condition = 0.0
  [../]
[]

[AuxVariables]
  [./nn]
    order = FIRST
    family = LAGRANGE
  [../]
[]

[Kernels]
  [./diff]
    type = Diffusion
    variable = u
  [../]
[]

[AuxKernels]
  [./nn]
    type = SolutionAux
    variable = nn
    solution = soln
  [../]
[]

[UserObjects]
  [./soln]
    type = SolutionUserObject
    mesh = cubesource.e
    system_variables = source_nodal
  [../]
[]

[BCs]
  [./stuff]
    type = DirichletBC
    variable = u
    boundary = '1 2'
    value = 0.0
  [../]
[]

[Executioner]
  type = Transient
  solve_type = NEWTON
  l_max_its = 800
  nl_rel_tol = 1e-10
  num_steps = 5
  start_time = 2.5
  end_time = 5
  dt = 0.5
[]

[Outputs]
  execute_on = 'timestep_end'
  exodus = true
[]

[Problem]
  restart_file_base = solution_aux_exodus_interp_restart1_out_cp/0005
[]
