#
# 3D Cylindrical Gap Heat Transfer Test.
#
# This test exercises 3D gap heat transfer for a constant conductivity gap.
#
# The mesh consists of an inner solid cylinder of radius = 1 unit, and outer
# hollow cylinder with an inner radius of 2. In other words, the gap between
# them is 1 radial unit in length.
#
# The conductivity of both cylinders is set very large to achieve a uniform
# temperature in each cylinder. The temperature of the center node of the
# inner cylinder is ramped from 100 to 200 over one time unit. The temperature
# of the outside of the outer, hollow cylinder is held fixed at 100.
#
# A simple analytical solution is possible for the integrated heat flux
# between the inner and outer cylinders:
#
#  Integrated Flux = (T_left - T_right) * (gapK/(r*ln(r2/r1))) * Area
#
# For gapK = 1 (default value)
#
# The area is taken as the area of the slave (inner) surface:
#
# Area = 2 * pi * h * r, where h is the height of the cylinder.
#
# The integrated heat flux across the gap at time 1 is then:
#
# 2*pi*h*k*delta_T/(ln(r2/r1))
# 2*pi*1*1*100/(ln(2/1)) = 906.5 watts
#
# For comparison, see results from the integrated flux post processors.
# This simulation makes use of symmetry, so only 1/4 of the cylinders is meshed
# As such, the integrated flux from the post processors is 1/4 of the total,
# or 226.6 watts.
# The value coming from the post processor is slightly less than this
# but converges as mesh refinement increases.
#
# Simulating contact is challenging. Regression tests that exercise
# contact features can be difficult to solve consistently across multiple
# platforms. While designing these tests, we felt it worth while to note
# some aspects of these tests. The following applies to:
# sphere3D.i, sphere2DRZ.i, cyl2D.i, and cyl3D.i.
# 1. We decided that to perform consistently across multiple platforms we
# would use very small convergence tolerance. In this test we chose an
# nl_rel_tol of 1e-12.
# 2. Due to such a high value for thermal conductivity (used here so that the
# domains come to a uniform temperature) the integrated flux at time = 0
# was relatively large (the value coming from SideIntegralFlux =
#  -_diffusion_coef[_qp]*_grad_u[_qp]*_normals[_qp] where the diffusion coefficient
# here is thermal conductivity).
# Even though _grad_u[_qp] is small, in this case the diffusion coefficient
# is large. The result is a number that isn't exactly zero and tends to
# fail exodiff. For this reason the parameter execute_on = initial should not
# be used. That parameter is left to default settings in these regression tests.
#
 [GlobalParams]
  order = SECOND
  family = LAGRANGE
  []


[Mesh]
  file = cyl3D.e
[]

[Functions]

  [./temp]
    type = PiecewiseLinear
    x = '0   1'
    y = '100 200'
  [../]
[]

[Variables]
  [./temp]
   initial_condition = 100
  [../]
[]

[AuxVariables]
  [./gap_conductance]
    order = CONSTANT
    family = MONOMIAL
  [../]
[]


[Kernels]
  [./heat_conduction]
    type = HeatConduction
    variable = temp
  [../]
[]

[AuxKernels]
  [./gap_cond]
    type = MaterialRealAux
    property = gap_conductance
    variable = gap_conductance
    boundary = 2
  [../]
[]

[Materials]
  [./heat1]
    type = HeatConductionMaterial
    block = '1 2'
    specific_heat = 1.0
    thermal_conductivity = 1000000.0
  [../]
[]

[ThermalContact]
  [./thermal_contact]
    type = GapHeatTransfer
    variable = temp
    master = 3
    slave = 2
    gap_conductivity = 1
    quadrature = true
    gap_geometry_type = CYLINDER
    cylinder_axis_point_1 = '0 0 0'
    cylinder_axis_point_2 = '0 1 0'
  [../]
[]

[BCs]
  [./mid]
    type = FunctionPresetBC
    boundary = 5
    variable = temp
    function = temp
  [../]
  [./temp_far_right]
    type = PresetBC
    boundary = 4
    variable = temp
    value = 100
  [../]
[]

[Executioner]
  type = Transient

  #Preconditioned JFNK (default)
  solve_type = 'PJFNK'

  petsc_options_iname = '-pc_type -pc_factor_mat_solver_package'
  petsc_options_value = 'lu       superlu_dist'

  dt = 1
  dtmin = 0.01
  end_time = 1

  nl_rel_tol = 1e-12
  nl_abs_tol = 1e-7

  [./Quadrature]
     order = fifth
     side_order = seventh
  [../]

[]

[Outputs]
  exodus = true
   [./Console]
    type = Console
    perf_log = true
   [../]
[]

[Postprocessors]
  [./temp_left]
    type = SideAverageValue
    boundary = 2
    variable = temp
  [../]

  [./temp_right]
    type = SideAverageValue
    boundary = 3
    variable = temp
  [../]

  [./flux_left]
    type = SideFluxIntegral
    variable = temp
    boundary = 2
    diffusivity = thermal_conductivity
  [../]

  [./flux_right]
    type = SideFluxIntegral
    variable = temp
    boundary = 3
    diffusivity = thermal_conductivity
  [../]
[]
