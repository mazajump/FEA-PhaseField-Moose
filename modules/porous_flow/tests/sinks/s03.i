# apply a sink flux with use_relperm=true and observe the correct behavior
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
    function = -y
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
    at_nodes = true
    include_old = true
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
  [./xval]
  [../]
  [./yval]
  [../]
[]

[ICs]
  [./xval]
    type = FunctionIC
    variable = xval
    function = x
  [../]
  [./yval]
    type = FunctionIC
    variable = yval
    function = y
  [../]
[]

[Functions]
  [./mass00]
    type = ParsedFunction
    value = 'vol*por*dens0*exp(pp/bulk)*pow(1+pow(-al*pp,1.0/(1-m)),-m)'
    vars = 'vol por dens0 pp bulk al m'
    vals = '0.25 0.1 1.1 p00 1.3 1.1 0.5'
  [../]
  [./sat00]
    type = ParsedFunction
    value = 'pow(1+pow(-al*pp,1.0/(1-m)),-m)'
    vars = 'pp al m'
    vals = 'p00 1.1 0.5'
  [../]
  [./mass01]
    type = ParsedFunction
    value = 'vol*por*dens0*exp(pp/bulk)*pow(1+pow(-al*pp,1.0/(1-m)),-m)'
    vars = 'vol por dens0 pp bulk al m'
    vals = '0.25 0.1 1.1 p01 1.3 1.1 0.5'
  [../]
  [./expected_mass_change00]
    type = ParsedFunction
    value = 'fcn*pow(pow(1+pow(-al*pp,1.0/(1-m)),-m),2)*area*dt'
    vars = 'fcn perm dens0 pp bulk visc area dt   al  m'
    vals = '6   0.2  1.1  p00 1.3  1.1  0.5  1E-3 1.1 0.5'
  [../]
  [./expected_mass_change01]
    type = ParsedFunction
    value = 'fcn*pow(pow(1+pow(-al*pp,1.0/(1-m)),-m),2)*area*dt'
    vars = 'fcn perm dens0 pp bulk visc area dt   al  m'
    vals = '6   0.2  1.1  p01 1.3  1.1  0.5  1E-3 1.1 0.5'
  [../]
  [./mass00_expect]
    type = ParsedFunction
    value = 'mass_prev-mass_change'
    vars = 'mass_prev mass_change'
    vals = 'm00_prev  del_m00'
  [../]
  [./mass01_expect]
    type = ParsedFunction
    value = 'mass_prev-mass_change'
    vars = 'mass_prev mass_change'
    vals = 'm01_prev  del_m01'
  [../]
  [./sat01]
    type = ParsedFunction
    value = 'pow(1+pow(-al*pp,1.0/(1-m)),-m)'
    vars = 'pp al m'
    vals = 'p01 1.1 0.5'
  [../]
  [./expected_mass_change_rate]
    type = ParsedFunction
    value = 'fcn*pow(pow(1+pow(-al*pp,1.0/(1-m)),-m),2)*area'
    vars = 'fcn perm dens0 pp bulk visc area dt   al  m'
    vals = '6   0.2  1.1  p00 1.3  1.1  0.5  1E-3 1.1 0.5'
  [../]
[]

[Postprocessors]
  [./p00]
    type = PointValue
    point = '0 0 0'
    variable = pp
    execute_on = 'initial timestep_end'
  [../]
  [./m00]
    type = FunctionValuePostprocessor
    function = mass00
    execute_on = 'initial timestep_end'
  [../]
  [./m00_prev]
    type = FunctionValuePostprocessor
    function = mass00
    execute_on = 'timestep_begin'
    outputs = 'console'
  [../]
  [./del_m00]
    type = FunctionValuePostprocessor
    function = expected_mass_change00
    execute_on = 'timestep_end'
    outputs = 'console'
  [../]
  [./m00_expect]
    type = FunctionValuePostprocessor
    function = mass00_expect
    execute_on = 'timestep_end'
  [../]
  [./p10]
    type = PointValue
    point = '1 0 0'
    variable = pp
    execute_on = 'initial timestep_end'
  [../]
  [./p01]
    type = PointValue
    point = '0 1 0'
    variable = pp
    execute_on = 'initial timestep_end'
  [../]
  [./m01]
    type = FunctionValuePostprocessor
    function = mass01
    execute_on = 'initial timestep_end'
  [../]
  [./m01_prev]
    type = FunctionValuePostprocessor
    function = mass01
    execute_on = 'timestep_begin'
    outputs = 'console'
  [../]
  [./del_m01]
    type = FunctionValuePostprocessor
    function = expected_mass_change01
    execute_on = 'timestep_end'
    outputs = 'console'
  [../]
  [./m01_expect]
    type = FunctionValuePostprocessor
    function = mass01_expect
    execute_on = 'timestep_end'
  [../]
  [./p11]
    type = PointValue
    point = '1 1 0'
    variable = pp
    execute_on = 'initial timestep_end'
  [../]
  [./s00]
    type = FunctionValuePostprocessor
    function = sat00
    execute_on = 'initial timestep_end'
  [../]
  [./mass00_rate]
    type = FunctionValuePostprocessor
    function = expected_mass_change_rate
    execute_on = 'initial timestep_end'
  [../]
[]

[BCs]
  [./flux]
    type = PorousFlowSink
    boundary = 'left'
    variable = pp
    use_mobility = false
    use_relperm = true
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
  end_time = 0.018
  nl_rel_tol = 1E-12
  nl_abs_tol = 1E-12
[]

[Outputs]
  file_base = s03
  [./console]
    type = Console
    execute_on = 'nonlinear linear'
    interval = 5
  [../]
  [./csv]
    type = CSV
    execute_on = 'timestep_end'
    interval = 2
  [../]
[]
