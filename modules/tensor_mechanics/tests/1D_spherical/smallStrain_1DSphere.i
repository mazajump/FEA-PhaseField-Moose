# This simulation models the mechanics solution for a solid sphere under
# pressure, applied on the outer surfaces, using 1D spherical symmetry
# assumpitions.  The inner center of the sphere, r = 0, is pinned to prevent
# movement of the sphere.
#
# From Bower (Applied Mechanics of Solids, 2008, available online at
# solidmechanics.org/text/Chapter4_1/Chapter4_1.htm), and applying the outer
# pressure and pinned displacement boundary conditions set in this simulation,
# the radial displacement is given by:
#
# u(r) = \frac{- P * (1 - 2 * v) * r}{E}
#
# where P is the applied pressure, v is Poisson's ration, E is Young's Modulus,
# and r is the radial position.
#
# The test assumes a radius of 4, zero displacement at r = 0mm, and an applied
# outer pressure of 1MPa.  Under these conditions in a solid sphere, the radial
# stress is constant and has a value of -1 MPa.
[Mesh]
  type = GeneratedMesh
  dim = 1
  xmin = 0
  xmax = 4
  nx = 4
[]

[GlobalParams]
  displacements = 'disp_r'
[]

[Problem]
  coord_type = RSPHERICAL
[]

[Modules/TensorMechanics/Master]
  [./all]
    strain = SMALL
    add_variables = true
    save_in = residual_r
  [../]
[]

[AuxVariables]
  [./stress_rr]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./residual_r]
  [../]
[]

[Postprocessors]
  [./stress_rr]
    type = ElementAverageValue
    variable = stress_rr
  [../]
  [./residual_r]
    type = NodalSum
    variable = residual_r
    boundary = right
  [../]
[]

[AuxKernels]
  [./stress_rr]
    type = RankTwoAux
    rank_two_tensor = stress
    index_i = 0
    index_j = 0
    variable = stress_rr
    execute_on = timestep_end
  [../]
[]

[BCs]
  [./innerDisp]
    type = PresetBC
    boundary = left
    variable = disp_r
    value = 0.0
  [../]
  [./outerPressure]
    type = Pressure
    boundary = right
    variable = disp_r
    component = 0
    factor = 1
  [../]
[]

[Materials]
  [./Elasticity_tensor]
    type = ComputeIsotropicElasticityTensor
    poissons_ratio = 0.345
    youngs_modulus = 1e4
  [../]
  [./stress]
  [../]
[]

[Executioner]
  type = Transient
  solve_type = PJFNK
  line_search = none

# controls for linear iterations
  l_max_its = 100
  l_tol = 1e-8

# controls for nonlinear iterations
  nl_max_its = 15
  nl_rel_tol = 1e-10
  nl_abs_tol = 1e-5

# time control
  start_time = 0.0
  dt = 0.25
  dtmin = 0.0001
  end_time = 1.0
[]

[Outputs]
  exodus = true
[]
