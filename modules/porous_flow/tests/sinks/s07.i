# apply a sink flux on just one component of a 3-component system and observe the correct behavior
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
    porous_flow_vars = 'pp frac0 frac1'
    number_fluid_phases = 1
    number_fluid_components = 3
  [../]
[]

[Variables]
  [./pp]
  [../]
  [./frac0]
    initial_condition = 0.1
  [../]
  [./frac1]
    initial_condition = 0.6
  [../]
[]

[ICs]
  [./pp]
    type = FunctionIC
    variable = pp
    function = y
  [../]
[]

[Kernels]
  [./mass0]
    type = PorousFlowMassTimeDerivative
    fluid_component = 0
    variable = frac0
  [../]
  [./mass1]
    type = PorousFlowMassTimeDerivative
    fluid_component = 1
    variable = frac1
  [../]
  [./mass2]
    type = PorousFlowMassTimeDerivative
    fluid_component = 2
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
    mass_fraction_vars = 'frac0 frac1'
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
    permeability = '0.2 0 0 0 0.1 0 0 0 0.1'
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
  [./mass1_00]
    type = ParsedFunction
    value = 'frac*vol*por*dens0*exp(pp/bulk)*pow(1+pow(-al*pp,1.0/(1-m)),-m)'
    vars = 'frac  vol  por dens0 pp bulk al m'
    vals = 'f1_00 0.25 0.1 1.1  p00 1.3 1.1 0.5'
  [../]
  [./expected_mass_change1_00]
    type = ParsedFunction
    value = 'frac*fcn*area*dt'
    vars = 'frac fcn area dt'
    vals = 'f1_00 6  0.5  1E-3'
  [../]
  [./mass1_00_expect]
    type = ParsedFunction
    value = 'mass_prev-mass_change'
    vars = 'mass_prev mass_change'
    vals = 'm1_00_prev  del_m1_00'
  [../]
  [./mass1_01]
    type = ParsedFunction
    value = 'frac*vol*por*dens0*exp(pp/bulk)*pow(1+pow(-al*pp,1.0/(1-m)),-m)'
    vars = 'frac  vol  por dens0 pp bulk al m'
    vals = 'f1_01 0.25 0.1 1.1  p01 1.3 1.1 0.5'
  [../]
  [./expected_mass_change1_01]
    type = ParsedFunction
    value = 'frac*fcn*area*dt'
    vars = 'frac fcn area dt'
    vals = 'f1_01 6  0.5  1E-3'
  [../]
  [./mass1_01_expect]
    type = ParsedFunction
    value = 'mass_prev-mass_change'
    vars = 'mass_prev mass_change'
    vals = 'm1_01_prev  del_m1_01'
  [../]
[]

[Postprocessors]
  [./f1_00]
    type = PointValue
    point = '0 0 0'
    variable = frac1
    execute_on = 'initial timestep_end'
  [../]
  [./flux_00]
    type = PointValue
    point = '0 0 0'
    variable = flux_out
    execute_on = 'initial timestep_end'
  [../]
  [./p00]
    type = PointValue
    point = '0 0 0'
    variable = pp
    execute_on = 'initial timestep_end'
  [../]
  [./m1_00]
    type = FunctionValuePostprocessor
    function = mass1_00
    execute_on = 'initial timestep_end'
  [../]
  [./m1_00_prev]
    type = FunctionValuePostprocessor
    function = mass1_00
    execute_on = 'timestep_begin'
    outputs = 'console'
  [../]
  [./del_m1_00]
    type = FunctionValuePostprocessor
    function = expected_mass_change1_00
    execute_on = 'timestep_end'
    outputs = 'console'
  [../]
  [./m1_00_expect]
    type = FunctionValuePostprocessor
    function = mass1_00_expect
    execute_on = 'timestep_end'
  [../]
  [./f1_01]
    type = PointValue
    point = '0 1 0'
    variable = frac1
    execute_on = 'initial timestep_end'
  [../]
  [./flux_01]
    type = PointValue
    point = '0 1 0'
    variable = flux_out
    execute_on = 'initial timestep_end'
  [../]
  [./p01]
    type = PointValue
    point = '0 1 0'
    variable = pp
    execute_on = 'initial timestep_end'
  [../]
  [./m1_01]
    type = FunctionValuePostprocessor
    function = mass1_01
    execute_on = 'initial timestep_end'
  [../]
  [./m1_01_prev]
    type = FunctionValuePostprocessor
    function = mass1_01
    execute_on = 'timestep_begin'
    outputs = 'console'
  [../]
  [./del_m1_01]
    type = FunctionValuePostprocessor
    function = expected_mass_change1_01
    execute_on = 'timestep_end'
    outputs = 'console'
  [../]
  [./m1_01_expect]
    type = FunctionValuePostprocessor
    function = mass1_01_expect
    execute_on = 'timestep_end'
  [../]
  [./f1_11]
    type = PointValue
    point = '1 1 0'
    variable = frac1
    execute_on = 'initial timestep_end'
  [../]
  [./flux_11]
    type = PointValue
    point = '1 1 0'
    variable = flux_out
    execute_on = 'initial timestep_end'
  [../]
  [./p11]
    type = PointValue
    point = '1 1 0'
    variable = pp
    execute_on = 'initial timestep_end'
  [../]
[]

[BCs]
  [./flux]
    type = PorousFlowSink
    boundary = 'left'
    variable = frac1
    use_mobility = false
    use_relperm = false
    mass_fraction_component = 1
    fluid_phase = 0
    flux_function = 6
    save_in = flux_out
  [../]
[]

[Preconditioning]
  [./andy]
    type = SMP
    full = true
    petsc_options_iname = '-ksp_type -pc_type -sub_pc_type -snes_max_it -sub_pc_factor_shift_type -pc_asm_overlap'
    petsc_options_value = 'gmres asm lu 10 NONZERO 2'
  [../]
[]

[Executioner]
  type = Transient
  solve_type = Newton
  dt = 1E-3
  end_time = 0.01
  nl_rel_tol = 1E-12
  nl_abs_tol = 1E-12
[]

[Outputs]
  file_base = s07
  [./console]
    type = Console
    execute_on = 'nonlinear linear'
  [../]
  [./csv]
    type = CSV
    execute_on = 'timestep_end'
  [../]
[]
