# apply a half-gaussian sink flux and observe the correct behavior
[Mesh]
  type = GeneratedMesh
  dim = 3
  nx = 1
  ny = 1
  nz = 1
  xmin = 0
  xmax = 1
  ymin = 0
  ymax = 1
  zmin = 0
  zmax = 2
[]

[GlobalParams]
  PorousFlowDictator = dictator
[]

[UserObjects]
  [./dictator]
    type = PorousFlowDictator
    porous_flow_vars = 'pp'
    number_fluid_phases = 1
    number_fluid_components = 1
  [../]
[]

[Variables]
  [./pp]
  [../]
[]

[ICs]
  [./pp]
    type = FunctionIC
    variable = pp
    function = y+1.4
  [../]
[]

[Kernels]
  [./mass0]
    type = PorousFlowMassTimeDerivative
    fluid_component = 0
    variable = pp
  [../]
[]

[Materials]
  [./temperature]
    type = PorousFlowTemperature
    at_nodes = true
  [../]
  [./ppss]
    type = PorousFlow1PhaseP_VG
    at_nodes = true
    porepressure = pp
    al = 1.1
    m = 0.5
  [../]
  [./massfrac]
    type = PorousFlowMassFraction
    at_nodes = true
  [../]
  [./dens0]
    type = PorousFlowDensityConstBulk
    at_nodes = true
    density_P0 = 1.1
    bulk_modulus = 1.3
    phase = 0
  [../]
  [./dens_all]
    type = PorousFlowJoiner
    include_old = true
    at_nodes = true
    material_property = PorousFlow_fluid_phase_density_nodal
  [../]
  [./porosity]
    type = PorousFlowPorosityConst
    at_nodes = true
    porosity = 0.1
  [../]
  [./permeability]
    type = PorousFlowPermeabilityConst
    permeability = '1E-5 0 0 0 1E-5 0 0 0 1E-5'
  [../]
  [./relperm]
    type = PorousFlowRelativePermeabilityCorey
    at_nodes = true
    n = 2
    phase = 0
  [../]
  [./relperm_all]
    type = PorousFlowJoiner
    at_nodes = true
    material_property = PorousFlow_relative_permeability_nodal
  [../]
  [./visc0]
    type = PorousFlowViscosityConst
    at_nodes = true
    viscosity = 1.1
    phase = 0
  [../]
  [./visc_all]
    type = PorousFlowJoiner
    at_nodes = true
    material_property = PorousFlow_viscosity_nodal
  [../]
[]

[AuxVariables]
  [./flux_out]
  [../]
[]

[Functions]
  [./mass10]
    type = ParsedFunction
    value = 'vol*por*dens0*exp(pp/bulk)*if(pp>=0,1,pow(1+pow(-al*pp,1.0/(1-m)),-m))'
    vars = 'vol por dens0 pp bulk al m'
    vals = '0.25 0.1 1.1 p10 1.3 1.1 0.5'
  [../]
  [./rate10]
    type = ParsedFunction
    value = 'if(pp>center,fcn,fcn*exp(-0.5*(pp-center)*(pp-center)/sd/sd))'
    vars = 'fcn pp  center sd'
    vals = '6   p10 0.9    0.5'
  [../]
  [./mass10_expect]
    type = ParsedFunction
    value = 'mass_prev-rate*area*dt'
    vars = 'mass_prev rate     area dt'
    vals = 'm10_prev  m10_rate 0.5 2E-3'
  [../]
  [./mass11]
    type = ParsedFunction
    value = 'vol*por*dens0*exp(pp/bulk)*if(pp>=0,1,pow(1+pow(-al*pp,1.0/(1-m)),-m))'
    vars = 'vol por dens0 pp bulk al m'
    vals = '0.25 0.1 1.1 p11 1.3 1.1 0.5'
  [../]
  [./rate11]
    type = ParsedFunction
    value = 'if(pp>center,fcn,fcn*exp(-0.5*(pp-center)*(pp-center)/sd/sd))'
    vars = 'fcn pp  center sd'
    vals = '6   p11 0.9    0.5'
  [../]
  [./mass11_expect]
    type = ParsedFunction
    value = 'mass_prev-rate*area*dt'
    vars = 'mass_prev rate     area dt'
    vals = 'm11_prev  m11_rate 0.5 2E-3'
  [../]
[]

[Postprocessors]
  [./flux10]
    type = PointValue
    variable = flux_out
    point = '1 0 0'
  [../]
  [./p00]
    type = PointValue
    point = '0 0 0'
    variable = pp
    execute_on = 'initial timestep_end'
  [../]
  [./p10]
    type = PointValue
    point = '1 0 0'
    variable = pp
    execute_on = 'initial timestep_end'
  [../]
  [./m10]
    type = FunctionValuePostprocessor
    function = mass10
    execute_on = 'initial timestep_end'
  [../]
  [./m10_prev]
    type = FunctionValuePostprocessor
    function = mass10
    execute_on = 'timestep_begin'
    outputs = 'console'
  [../]
  [./m10_rate]
    type = FunctionValuePostprocessor
    function = rate10
    execute_on = 'timestep_end'
  [../]
  [./m10_expect]
    type = FunctionValuePostprocessor
    function = mass10_expect
    execute_on = 'timestep_end'
  [../]
  [./p01]
    type = PointValue
    point = '0 1 0'
    variable = pp
    execute_on = 'initial timestep_end'
  [../]
  [./p11]
    type = PointValue
    point = '1 1 0'
    variable = pp
    execute_on = 'initial timestep_end'
  [../]
  [./m11]
    type = FunctionValuePostprocessor
    function = mass11
    execute_on = 'initial timestep_end'
  [../]
  [./m11_prev]
    type = FunctionValuePostprocessor
    function = mass11
    execute_on = 'timestep_begin'
    outputs = 'console'
  [../]
  [./m11_rate]
    type = FunctionValuePostprocessor
    function = rate11
    execute_on = 'timestep_end'
  [../]
  [./m11_expect]
    type = FunctionValuePostprocessor
    function = mass11_expect
    execute_on = 'timestep_end'
  [../]
[]

[BCs]
  [./flux]
    type = PorousFlowHalfGaussianSink
    boundary = 'right'
    max = 6
    sd = 0.5
    center = 0.9
    variable = pp
    use_mobility = false
    use_relperm = false
    fluid_phase = 0
    flux_function = 1
    save_in = flux_out
  [../]
[]

[Preconditioning]
  [./andy]
    type = SMP
    full = true
    petsc_options_iname = '-ksp_type -pc_type -sub_pc_type -snes_max_it -sub_pc_factor_shift_type -pc_asm_overlap'
    petsc_options_value = 'gmres asm lu 10000 NONZERO 2'
  [../]
[]

[Executioner]
  type = Transient
  solve_type = Newton
  dt = 2E-3
  end_time = 6E-2
  nl_rel_tol = 1E-12
  nl_abs_tol = 1E-12
[]

[Outputs]
  file_base = s05
  [./console]
    type = Console
    execute_on = 'nonlinear linear'
    interval = 5
  [../]
  [./csv]
    type = CSV
    execute_on = 'timestep_end'
    interval = 3
  [../]
[]
