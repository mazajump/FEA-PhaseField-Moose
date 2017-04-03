#
# 2-D RZ Gap Heat Transfer Test without mechanics
#
# This test exercises 1-D gap heat transfer for a constant conductivity gap.
#
# The mesh consists of two element blocks containing one element each.  Each
#   element is a unit cube.  They sit next to one another with a unit between them.
#
# The conductivity of both blocks is set very large to achieve a uniform temperature
#  across each block. The temperature of the far left boundary
#  is ramped from 100 to 200 over one time unit, and then held fixed for an additional
#  time unit.  The temperature of the far right boundary is held fixed at 100.
#
# A simple analytical solution is possible for the heat flux between the blocks, or cylinders in the case of RZ.:
#
#  Flux = (T_left - T_right) * (gapK/(r*ln(r2/r1)))
#
# For gapK = 1 (default value)
#
# The integrated heat flux across the gap at time 2 is then:
#
# 2*pi*h*k*delta_T/(ln(r2/r1))
# 2*pi*1*1*100/(ln(2/1)) = 906.5 watts
#
# For comparison, see results from the flux post processors.
#
# As a second test, use the rectilinear (parallel plate) form of the gap heat transfer.
#
#  Flux = (T_left - T_right) * (gapK/gapL)
#
# For gapK = 1 (default value)
#
# The integrated heat flux across the gap at time 2 is then:
#
# 2*pi*h*k*delta_T/(1)
# 2*pi*1*1*100/(1) = 628.3 watts
#
# For comparison, see results from the flux post processors.
#

[Problem]
  coord_type = RZ
[]

[Mesh]
  file = gap_heat_transfer_htonly_rz_test.e
[]

[Functions]

  [./ramp]
    type = PiecewiseLinear
    x = '0   1   2'
    y = '100 200 200'
  [../]
[]

[ThermalContact]
  [./thermal_contact]
    type = GapHeatTransfer
    variable = temp
    master = 3
    slave = 2
  [../]
  [./thermal_contact2]
    type = GapHeatTransfer
    variable = temp2
    master = 3
    slave = 2
    gap_geometry_type = PLATE
    appended_property_name = 2
  [../]
[]

[Variables]
  [./temp]
    order = FIRST
    family = LAGRANGE
    initial_condition = 100
  [../]
  [./temp2]
    order = FIRST
    family = LAGRANGE
    initial_condition = 100
  [../]
[]

[AuxVariables]
  [./gap_cond]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./gap_cond2]
    order = CONSTANT
    family = MONOMIAL
  [../]
[]

[Kernels]
  [./heat]
    type = HeatConduction
    variable = temp
  [../]
  [./heat2]
    type = HeatConduction
    variable = temp2
  [../]
[]


[BCs]
  [./temp_far_left]
    type = FunctionPresetBC
    boundary = 1
    variable = temp
    function = ramp
  [../]

  [./temp_far_right]
    type = PresetBC
    boundary = 4
    variable = temp
    value = 100
  [../]

  [./temp_far_left2]
    type = FunctionPresetBC
    boundary = 1
    variable = temp2
    function = ramp
  [../]

  [./temp_far_right2]
    type = PresetBC
    boundary = 4
    variable = temp2
    value = 100
  [../]
[]

[AuxKernels]
  [./conductance]
    type = MaterialRealAux
    property = gap_conductance
    variable = gap_cond
    boundary = 2
  [../]
  [./conductance2]
    type = MaterialRealAux
    property = gap_conductance
    variable = gap_cond2
    boundary = 2
  [../]
[]

[Materials]

  [./heat1]
    type = HeatConductionMaterial
    block = '1 2'
    specific_heat = 1.0
    thermal_conductivity = 100000000.0
  [../]
  [./density]
    type = Density
    block = '1 2'
    density = 1.0
  [../]
[]

[Executioner]
  type = Transient
#  petsc_options = '-snes_mf_operator -ksp_monitor -snes_ksp_ew'

  #Preconditioned JFNK (default)
  solve_type = 'PJFNK'




#  petsc_options_iname = '-snes_type -snes_ls -snes_linesearch_type -ksp_gmres_restart -pc_type -pc_hypre_type -pc_hypre_boomeramg_max_iter'
#  petsc_options_value = 'ls         basic    basic                    201                hypre    boomeramg      4'
#  petsc_options_iname = '-ksp_gmres_restart -pc_type -pc_hypre_type -pc_hypre_boomeramg_max_iter'
#  petsc_options_value = '201                hypre    boomeramg      4'

  nl_abs_tol = 5e-2
  nl_rel_tol = 1e-8

  l_tol = 1e-6
  l_max_its = 100

  start_time = 0.0
  dt = 1e-1
  end_time = 2.0
[]

[Postprocessors]

  [./temp_left]
    type = SideAverageValue
    boundary = 2
    variable = temp
    execute_on = 'initial timestep_end'
  [../]

  [./temp_right]
    type = SideAverageValue
    boundary = 3
    variable = temp
    execute_on = 'initial timestep_end'
  [../]

  [./flux_left]
    type = SideFluxIntegral
    variable = temp
    boundary = 2
    diffusivity = thermal_conductivity
    execute_on = 'initial timestep_end'
  [../]

  [./flux_right]
    type = SideFluxIntegral
    variable = temp
    boundary = 3
    diffusivity = thermal_conductivity
    execute_on = 'initial timestep_end'
  [../]

  [./temp_left2]
    type = SideAverageValue
    boundary = 2
    variable = temp2
    execute_on = 'initial timestep_end'
  [../]

  [./temp_right2]
    type = SideAverageValue
    boundary = 3
    variable = temp2
    execute_on = 'initial timestep_end'
  [../]

  [./flux_left2]
    type = SideFluxIntegral
    variable = temp2
    boundary = 2
    diffusivity = thermal_conductivity
    execute_on = 'initial timestep_end'
  [../]

  [./flux_right2]
    type = SideFluxIntegral
    variable = temp2
    boundary = 3
    diffusivity = thermal_conductivity
    execute_on = 'initial timestep_end'
  [../]

[]

[Outputs]
  exodus = true
[]
