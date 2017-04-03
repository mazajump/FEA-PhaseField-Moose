# Steady-state test for the ThermoDiffusion kernel.
#
# This test applies a constant temperature gradient to drive thermo-diffusion
# in the variable u. At steady state, the thermo-diffusion is balanced by
# diffusion due to Fick's Law, so the total flux is
#
#   J = -D ( grad(u) - ( Qstar u / R ) grad(1/T) )
#
# If there are no fluxes at the boundaries, then there is no background flux and
# these two terms must balance each other everywhere:
#
#   grad(u) = ( Qstar u / R ) grad(1/T)
#
# The dx can be eliminated to give
#
#   d(ln u) / d(1/T) = Qstar / R
#
# This can be solved to give the profile for u as a function of temperature:
#
#   u = A exp( Qstar / R T )
#
# Here, we are using simple heat conduction with Dirichlet boundaries on 0 <= x <= 1
# to give a linear profile for temperature: T = x + 1. We also need to apply one
# boundary condition on u, which is u(x=0) = 1. These conditions give:
#
#   u = exp( -(Qstar/R) (x/(x+1)) )
#
# This analytical result is tracked by the aux variable "correct_u".

[Mesh]
  type = GeneratedMesh
  dim = 2
  xmin = 0
  xmax = 1
  ymin = 0
  ymax = 1
  nx = 10
  ny = 1
[]

[Variables]
  [./u]
    initial_condition = 1
  [../]
  [./temp]
    initial_condition = 1
  [../]
[]

[Kernels]
  [./soret]
    type = ThermoDiffusion
    variable = u
    temp = temp
    gas_constant = 1
  [../]
  [./diffC]
    type = CoefDiffusion
    variable = u
    coef = 1
  [../]

  # Heat diffusion gives a linear temperature profile to drive the Soret diffusion.
  [./diffT]
    type = CoefDiffusion
    variable = temp
    coef = 1
  [../]
[]

[BCs]
  [./left]
    type = DirichletBC
    variable = u
    boundary = left
    value = 1
  [../]

  [./leftt]
    type = DirichletBC
    variable = temp
    boundary = left
    value = 1
  [../]
  [./rightt]
    type = DirichletBC
    variable = temp
    boundary = right
    value = 2
  [../]
[]

[Materials]
  [./fake_material]
     type = GenericConstantMaterial
     block = 0
     prop_names = 'mass_diffusivity heat_of_transport'
     prop_values = '1 1'
  [../]
[]

[Functions]
  # The correct (analytical) result for the solution of u.
  [./concentration_profile]
    type = ParsedFunction
    value = 'exp(-x/(x+1))'
  [../]
[]

[AuxVariables]
  [./correct_u]
  [../]
[]

[AuxKernels]
  # This kernel is just being used to plot the correct result for u.
  [./copy_from_function]
    type = FunctionAux
    variable = correct_u
    function = concentration_profile
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
