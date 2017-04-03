# unsaturated = true
# gravity = true
# supg = true
# transient = false

[Mesh]
  type = GeneratedMesh
  dim = 1
  nx = 20
  xmin = 0
  xmax = 1
[]


[GlobalParams]
  richardsVarNames_UO = PPNames
[]

[UserObjects]
  [./PPNames]
    type = RichardsVarNames
    richards_vars = 'pwater pgas'
  [../]
  [./DensityWater]
    type = RichardsDensityConstBulk
    dens0 = 1
    bulk_mod = 1.0E2
  [../]
  [./DensityGas]
    type = RichardsDensityConstBulk
    dens0 = 0.5
    bulk_mod = 0.5E2
  [../]
  [./SeffWater]
    type = RichardsSeff2waterVG
    m = 0.8
    al = 1
  [../]
  [./SeffGas]
    type = RichardsSeff2gasVG
    m = 0.8
    al = 1
  [../]
  [./RelPermWater]
    type = RichardsRelPermPower
    simm = 0.0
    n = 2
  [../]
  [./RelPermGas]
    type = RichardsRelPermPower
    simm = 0.0
    n = 3
  [../]
  [./SatWater]
    type = RichardsSat
    s_res = 0.1
    sum_s_res = 0.15
  [../]
  [./SatGas]
    type = RichardsSat
    s_res = 0.05
    sum_s_res = 0.15
  [../]
  [./SUPGwater]
    type = RichardsSUPGstandard
    p_SUPG = 1E-3
  [../]
  [./SUPGgas]
    type = RichardsSUPGstandard
    p_SUPG = 1E-3
  [../]
[]

[Variables]
  [./pwater]
    order = FIRST
    family = LAGRANGE
  [../]
  [./pgas]
    order = FIRST
    family = LAGRANGE
  [../]
[]

[ICs]
  # get nonconvergence if initial condition is too crazy
  [./water_ic]
    type = FunctionIC
    function = '1-x/2'
    variable = pwater
  [../]
  [./gas_ic]
    type = FunctionIC
    function = '4-x/5'
    variable = pgas
  [../]
[]


[Kernels]
  active = 'richardsfwater richardsfgas'
  [./richardstwater]
    type = RichardsMassChange
    variable = pwater
  [../]
  [./richardsfwater]
    type = RichardsFlux
    variable = pwater
  [../]
  [./richardstgas]
    type = RichardsMassChange
    variable = pgas
  [../]
  [./richardsfgas]
    type = RichardsFlux
    variable = pgas
  [../]
[]


[AuxVariables]
  [./seffgas]
  [../]
  [./seffwater]
  [../]
[]

[AuxKernels]
  [./seffgas_kernel]
    type = RichardsSeffAux
    pressure_vars = 'pwater pgas'
    seff_UO = SeffGas
    variable = seffgas
  [../]
  [./seffwater_kernel]
    type = RichardsSeffAux
    pressure_vars = 'pwater pgas'
    seff_UO = SeffWater
    variable = seffwater
  [../]
[]

[Postprocessors]
  [./pw_left]
    type = PointValue
    point = '0 0 0'
    variable = pwater
    outputs = none
  [../]
  [./pw_right]
    type = PointValue
    point = '1 0 0'
    variable = pwater
    outputs = none
  [../]
  [./error_water]
    type = FunctionValuePostprocessor
    function = fcn_error_water
  [../]

  [./pg_left]
    type = PointValue
    point = '0 0 0'
    variable = pgas
    outputs = none
  [../]
  [./pg_right]
    type = PointValue
    point = '1 0 0'
    variable = pgas
    outputs = none
  [../]
  [./error_gas]
    type = FunctionValuePostprocessor
    function = fcn_error_gas
  [../]
[]

[Functions]
  [./fcn_error_water]
    type = ParsedFunction
    value = 'abs((-b*log(-(gdens0*xval+(-b*exp(-p0/b)))/b)-p1)/p1)'
    vars = 'b gdens0 p0 xval p1'
    vals = '1E2 -1 pw_left 1 pw_right'
  [../]
  [./fcn_error_gas]
    type = ParsedFunction
    value = 'abs((-b*log(-(gdens0*xval+(-b*exp(-p0/b)))/b)-p1)/p1)'
    vars = 'b gdens0 p0 xval p1'
    vals = '0.5E2 -0.5 pg_left 1 pg_right'
  [../]
[]

[Materials]
  [./rock]
    type = RichardsMaterial
    block = 0
    mat_porosity = 0.1
    mat_permeability = '1E-5 0 0  0 1E-5 0  0 0 1E-5'
    density_UO = 'DensityWater DensityGas'
    relperm_UO = 'RelPermWater RelPermGas'
    SUPG_UO = 'SUPGwater SUPGgas'
    sat_UO = 'SatWater SatGas'
    seff_UO = 'SeffWater SeffGas'
    viscosity = '1E-3 0.5E-3'
    gravity = '-1 0 0'
    linear_shape_fcns = true
  [../]
[]



[Preconditioning]
  [./andy]
    type = SMP
    full = true
    petsc_options_iname = '-ksp_type -pc_type -sub_pc_type -sub_pc_factor_shift_type -snes_atol -snes_rtol -snes_max_it'
    petsc_options_value = 'gmres asm lu NONZERO 1E-10 1E-10 10000'
  [../]
[]

[Executioner]
  type = Steady
  solve_type = Newton
[]

[Outputs]
  execute_on = 'timestep_end'
  file_base = gh04
  csv = true
[]
