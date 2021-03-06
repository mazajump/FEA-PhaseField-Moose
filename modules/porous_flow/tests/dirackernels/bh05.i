# unsaturated
# injection
[Mesh]
  type = GeneratedMesh
  dim = 3
  nx = 1
  ny = 1
  nz = 1
  xmin = -1
  xmax = 1
  ymin = -1
  ymax = 1
  zmin = -1
  zmax = 1
[]

[GlobalParams]
  PorousFlowDictator = dictator
[]

[Variables]
  [./pp]
    initial_condition = -2E5
  [../]
[]

[Kernels]
  [./mass0]
    type = PorousFlowMassTimeDerivative
    fluid_component = 0
    variable = pp
  [../]
[]

[UserObjects]
  [./dictator]
    type = PorousFlowDictator
    porous_flow_vars = 'pp'
    number_fluid_phases = 1
    number_fluid_components = 1
  [../]
  [./borehole_total_outflow_mass]
    type = PorousFlowSumQuantity
  [../]
[]

[Materials]
  [./temperature]
    type = PorousFlowTemperature
    at_nodes = true
  [../]
  [./ppss_nodal]
    type = PorousFlow1PhaseP_VG
    at_nodes = true
    porepressure = pp
    al = 1E-5
    m = 0.8
  [../]
  [./ppss_qp]
    type = PorousFlow1PhaseP_VG
    porepressure = pp
    al = 1E-5
    m = 0.8
  [../]
  [./massfrac]
    type = PorousFlowMassFraction
    at_nodes = true
  [../]
  [./dens0]
    type = PorousFlowDensityConstBulk
    at_nodes = true
    density_P0 = 1000
    bulk_modulus = 2E9
    phase = 0
  [../]
  [./dens_all]
    type = PorousFlowJoiner
    at_nodes = true
    material_property = PorousFlow_fluid_phase_density_nodal
    include_old = true
  [../]
  [./porosity]
    type = PorousFlowPorosityConst
    at_nodes = true
    porosity = 0.1
  [../]
  [./permeability]
    type = PorousFlowPermeabilityConst
    permeability = '1E-12 0 0 0 1E-12 0 0 0 1E-12'
  [../]
  [./relperm]
    type = PorousFlowRelativePermeabilityFLAC
    at_nodes = true
    m = 2
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
[]


[DiracKernels]
  [./bh]
    type = PorousFlowPeacemanBorehole
    bottom_p_or_t = 0
    fluid_phase = 0
    point_file = bh03.bh
    use_mobility = true
    SumQuantityUO = borehole_total_outflow_mass
    variable = pp
    unit_weight = '0 0 0'
    character = -1
  [../]
[]


[Postprocessors]
  [./bh_report]
    type = PorousFlowPlotQuantity
    uo = borehole_total_outflow_mass
  [../]

  [./fluid_mass0]
    type = PorousFlowFluidMass
    execute_on = timestep_begin
  [../]

  [./fluid_mass1]
    type = PorousFlowFluidMass
    execute_on = timestep_end
  [../]

  [./zmass_error]
    type = FunctionValuePostprocessor
    function = mass_bal_fcn
    execute_on = timestep_end
  [../]

  [./p0]
    type = PointValue
    variable = pp
    point = '0 0 0'
    execute_on = timestep_end
  [../]
[]


[Functions]
  [./mass_bal_fcn]
    type = ParsedFunction
    value = abs((a-c+d)/2/(a+c))
    vars = 'a c d'
    vals = 'fluid_mass1 fluid_mass0 bh_report'
  [../]
[]

[Preconditioning]
  [./usual]
    type = SMP
    full = true
    petsc_options = '-snes_converged_reason'
    petsc_options_iname = '-ksp_type -pc_type -snes_atol -snes_rtol -snes_max_it -ksp_max_it'
    petsc_options_value = 'bcgs bjacobi 1E-10 1E-10 10000 30'
  [../]
[]


[Executioner]
  type = Transient
  end_time = 6500
  solve_type = NEWTON
  [./TimeStepper]
    type = FunctionDT
    time_dt = '500 500 1E1'
    time_t = '4000 5000 6500'
  [../]
[]

[Outputs]
  file_base = bh05
  exodus = false
  csv = true
  execute_on = timestep_end
[]
