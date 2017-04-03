###########################################################
# This is a simple test of the Kernel System.
# It solves the Laplacian equation on a small 2x2 grid.
# The "Diffusion" kernel is used to calculate the
# residuals of the weak form of this operator.
#
# @Requirement F3.30
###########################################################

[Mesh]
  file = square.e
[]

[Variables]
  active = 'u'

  [./u]
    order = FIRST
    family = LAGRANGE
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

  solve_type = 'NEWTON'
[]

[Outputs]
  file_base = out
  exodus = true
[]
