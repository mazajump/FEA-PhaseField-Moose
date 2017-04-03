###########################################################
# This is a simple test demonstrating the use of the
# user-defined initial condition system.
#
# @Requirement F3.20
# @Requirement F5.20
###########################################################


[Mesh]
  file = square.e
[]

[Variables]
  active = 'u'

  [./u]
    order = FIRST
    family = LAGRANGE

    # Initial Condition on Nonlinear variable
    [./InitialCondition]
      type = ConstantIC
      value = 6.2
    [../]
  [../]
[]

[AuxVariables]
  active = 'u_aux'

  [./u_aux]
    order = FIRST
    family = LAGRANGE

    # Initial Condition on Auxiliary variable
    [./InitialCondition]
      type = ConstantIC
      value = 9.3
    [../]
  [../]
[]

[Kernels]
  active = 'diff'

  [./diff]
    type = Diffusion
    variable = u
  [../]
[]

[BCs]
  active = 'left right'

  [./left]
    type = DirichletBC
    variable = u
    boundary = 1
    value = 0
  [../]

  [./right]
    type = DirichletBC
    variable = u
    boundary = 2
    value = 1
  [../]
[]

[Executioner]
  type = Steady

  # Preconditioned JFNK (default)
  solve_type = 'PJFNK'
  nl_rel_tol = 1e-10
[]

[Outputs]
  file_base = out
  exodus = true
[]
