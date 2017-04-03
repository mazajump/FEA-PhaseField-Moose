#
# Homogenization of thermal conductivity according to
#   Homogenization of Temperature-Dependent Thermal Conductivity in Composite
#   Materials, Journal of Thermophysics and Heat Transfer, Vol. 15, No. 1,
#   January-March 2001.
#
# The problem solved here is a simple square with two blocks.  The square is
#   divided vertically between the blocks.  One block has a thermal conductivity
#   of 10.  The other block's thermal conductivity is 100.
#
# The analytic solution for the homogenized thermal conductivity in the
#   horizontal direction is found by summing the thermal resistance, recognizing
#   that the blocks are in series:
#
#   R = L/A/k = R1 + R2 = L1/A1/k1 + L2/A2/k2 = .5/1/10 + .5/1/100
#   Since L = A = 1, k_xx = 18.1818.
#
# The analytic solution for the homogenized thermal conductivity in the vertical
#   direction is found by summing reciprocals of resistance, recognizing that
#   the blocks are in parallel:
#
#   1/R = k*A/L = 1/R1 + 1/R2 = 10*.5/1 + 100*.5/1
#   Since L = A = 1, k_yy = 55.0.
#

[Mesh]
  file = heatConduction2D.e
[] # Mesh

[Variables]

  [./temp_x]
    order = FIRST
    family = LAGRANGE
    initial_condition = 100
  [../]
  [./temp_y]
    order = FIRST
    family = LAGRANGE
    initial_condition = 100
  [../]

[] # Variables

[Kernels]

  [./heat_x]
    type = HeatConduction
    variable = temp_x
  [../]

  [./heat_y]
    type = HeatConduction
    variable = temp_y
  [../]

  [./heat_rhs_x]
    type = HomogenizedHeatConduction
    variable = temp_x
    component = 0
  [../]

  [./heat_rhs_y]
    type = HomogenizedHeatConduction
    variable = temp_y
    component = 1
  [../]

[] # Kernels

[BCs]

 [./Periodic]
   [./left_right]
     primary = 10
     secondary = 20
     translation = '1 0 0'
   [../]
   [./bottom_top]
     primary = 30
     secondary = 40
     translation = '0 1 0'
   [../]
 [../]

 [./fix_center_x]
   type = DirichletBC
   variable = temp_x
   value = 100
   boundary = 1
 [../]

 [./fix_center_y]
   type = DirichletBC
   variable = temp_y
   value = 100
   boundary = 1
 [../]

[] # BCs

[Materials]

  [./heat1]
    type = HeatConductionMaterial
    block = 1

    specific_heat = 0.116
    thermal_conductivity = 10
  [../]

  [./heat2]
    type = HeatConductionMaterial
    block = 2

    specific_heat = 0.116
    thermal_conductivity = 100
  [../]

  [./density]
    type = Density
    block = '1 2'
    density = 0.283
  [../]

[] # Materials

[Executioner]

  type = Steady

  #Preconditioned JFNK (default)
  solve_type = 'PJFNK'



  petsc_options_iname = '-pc_type -ksp_gmres_restart'
  petsc_options_value = 'lu       101'


  line_search = 'none'


  nl_abs_tol = 1e-11
  nl_rel_tol = 1e-10


  l_max_its = 20

[] # Executioner

[Outputs]
  exodus = true
[] # Outputs

[Postprocessors]
  [./k_xx]
    type = HomogenizedThermalConductivity
    variable = temp_x
    temp_x = temp_x
    temp_y = temp_y
    component = 0
    execute_on = 'initial timestep_end'
  [../]
  [./k_yy]
    type = HomogenizedThermalConductivity
    variable = temp_y
    temp_x = temp_x
    temp_y = temp_y
    component = 1
    execute_on = 'initial timestep_end'
  [../]
[]
