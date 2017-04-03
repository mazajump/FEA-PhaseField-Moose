# Newton cooling from a bar.  1-phase and heat, steady
[Mesh]
  type = GeneratedMesh
  dim = 2
  nx = 100
  ny = 1
  xmin = 0
  xmax = 100
  ymin = 0
  ymax = 1
[]

[GlobalParams]
  PorousFlowDictator = dictator
[]

[UserObjects]
  [./dictator]
    type = PorousFlowDictator
    porous_flow_vars = 'pressure temp'
    number_fluid_phases = 1
    number_fluid_components = 1
  [../]
[]

[Variables]
  [./pressure]
  [../]
  [./temp]
  [../]
[]

[ICs]
  # have to start these reasonably close to their steady-state values
  [./pressure]
    type = FunctionIC
    variable = pressure
    function = '(2-x/100)*1E6'
  [../]
  [./temperature]
    type = FunctionIC
    variable = temp
    function = 100+0.1*x
  [../]
[]

[Kernels]
  [./flux]
    type = PorousFlowAdvectiveFlux
    fluid_component = 0
    gravity = '0 0 0'
    variable = pressure
  [../]
  [./heat_advection]
    type = PorousFlowHeatAdvection
    gravity = '0 0 0'
    variable = temp
  [../]
[]

[Materials]
  [./temperature]
    type = PorousFlowTemperature
    temperature = temp
  [../]
  [./temperature_nodal]
    type = PorousFlowTemperature
    at_nodes = true
    temperature = temp
  [../]
  [./ppss]
    type = PorousFlow1PhaseP_VG # irrelevant in this fully-saturated situation
    porepressure = pressure
    m = 0.8
    al = 1E-5
  [../]
  [./ppss_nodal]
    type = PorousFlow1PhaseP_VG # irrelevant in this fully-saturated situation
    at_nodes = true
    porepressure = pressure
    m = 0.8
    al = 1E-5
  [../]
  [./massfrac]
    type = PorousFlowMassFraction
    at_nodes = true
  [../]
  [./dens0]
    type = PorousFlowDensityConstBulk
    at_nodes = true
    density_P0 = 1000
    bulk_modulus = 1.0E6
    phase = 0
  [../]
  [./dens_all]
    type = PorousFlowJoiner
    include_old = true
    at_nodes = true
    material_property = PorousFlow_fluid_phase_density_nodal
  [../]
  [./dens0_qp]
    type = PorousFlowDensityConstBulk
    density_P0 = 1000
    bulk_modulus = 1.0E6
    phase = 0
  [../]
  [./dens_all_at_quadpoints]
    type = PorousFlowJoiner
    material_property = PorousFlow_fluid_phase_density_qp
    at_nodes = false
  [../]
  [./permeability]
    type = PorousFlowPermeabilityConst
    permeability = '1E-15 0 0 0 1E-15 0 0 0 1E-15'
  [../]
  [./relperm]
    type = PorousFlowRelativePermeabilityCorey # irrelevant in this fully-saturated situation
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
    viscosity = 1E-3
    phase = 0
  [../]
  [./visc_all]
    type = PorousFlowJoiner
    at_nodes = true
    material_property = PorousFlow_viscosity_nodal
  [../]
  [./enthalpy0]
    type = PorousFlowEnthalpy
    at_nodes = true
    phase = 0
    porepressure_coefficient = 0.0
  [../]
  [./enthalpy_all]
    type = PorousFlowJoiner
    at_nodes = true
    material_property = PorousFlow_fluid_phase_enthalpy_nodal
  [../]
  [./fluid_energy0]
    type = PorousFlowInternalEnergyIdeal
    at_nodes = true
    specific_heat_capacity = 1.0E6
    phase = 0
  [../]
  [./energy_all]
    type = PorousFlowJoiner
    at_nodes = true
    material_property = PorousFlow_fluid_phase_internal_energy_nodal
  [../]
[]

[BCs]
  [./leftp]
    type = DirichletBC
    variable = pressure
    boundary = left
    value = 2E6
  [../]
  [./leftt]
    type = DirichletBC
    variable = temp
    boundary = left
    value = 100
  [../]
  [./newtonp]
    type = PorousFlowPiecewiseLinearSink
    variable = pressure
    boundary = right
    pt_vals = '0 100000 200000 300000 400000 500000 600000 700000 800000 900000 1000000 1100000 1200000 1300000 1400000 1500000 1600000 1700000 1800000 1900000 2000000'
    multipliers = '0. 5.6677197748570516e-6 0.000011931518841831313 0.00001885408740732065 0.000026504708864284114 0.000034959953203725676 0.000044304443352900224 0.00005463170211001232 0.00006604508815181467 0.00007865883048198513 0.00009259917167338928 0.00010800563134618119 0.00012503240252705603 0.00014384989486488752 0.00016464644014777016 0.00018763017719085535 0.0002130311349595711 0.00024110353477682344 0.00027212833465544285 0.00030641604122040985 0.00034430981736352295'
    use_mobility = false
    use_relperm = false
    fluid_phase = 0
    flux_function = 1
  [../]
  [./newton]
    type = PorousFlowPiecewiseLinearSink
    variable = temp
    boundary = right
    pt_vals = '0 100000 200000 300000 400000 500000 600000 700000 800000 900000 1000000 1100000 1200000 1300000 1400000 1500000 1600000 1700000 1800000 1900000 2000000'
    multipliers = '0. 5.6677197748570516e-6 0.000011931518841831313 0.00001885408740732065 0.000026504708864284114 0.000034959953203725676 0.000044304443352900224 0.00005463170211001232 0.00006604508815181467 0.00007865883048198513 0.00009259917167338928 0.00010800563134618119 0.00012503240252705603 0.00014384989486488752 0.00016464644014777016 0.00018763017719085535 0.0002130311349595711 0.00024110353477682344 0.00027212833465544285 0.00030641604122040985 0.00034430981736352295'
    use_mobility = false
    use_relperm = false
    use_internal_energy = true
    fluid_phase = 0
    flux_function = 1
  [../]
[]

[VectorPostprocessors]
  [./porepressure]
    type = LineValueSampler
    variable = pressure
    start_point = '0 0.5 0'
    end_point = '100 0.5 0'
    sort_by = x
    num_points = 11
    execute_on = timestep_end
  [../]
  [./temperature]
    type = LineValueSampler
    variable = temp
    start_point = '0 0.5 0'
    end_point = '100 0.5 0'
    sort_by = x
    num_points = 11
    execute_on = timestep_end
  [../]
[]

[Preconditioning]
  [./andy]
    type = SMP
    full = true
    petsc_options = '-snes_converged_reason'
    petsc_options_iname = '-ksp_type -pc_type -sub_pc_type -snes_max_it -sub_pc_factor_shift_type -pc_asm_overlap -snes_atol -snes_rtol '
    petsc_options_value = 'gmres asm lu 100 NONZERO 2 1E-8 1E-15'
  [../]
[]

[Executioner]
  type = Steady
  solve_type = Newton
[]

[Outputs]
  file_base = nc06
  execute_on = timestep_end
  exodus = true
  [./along_line]
    type = CSV
    execute_vector_postprocessors_on = timestep_end
  [../]
[]
