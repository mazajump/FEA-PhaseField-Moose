# checking radioactive decay
# 1phase, 1component, constant porosity
#
# Note that we don't get mass = mass0 * exp(-Lambda * t)
# because of the time discretisation.  We are solving
# the equation
# (mass - mass0)/dt = -Lambda * mass
# which has the solution
# mass = mass0/(1 + Lambda * dt)
[Mesh]
  type = GeneratedMesh
  dim = 1
  nx = 3
  xmin = -1
  xmax = 1
[]

[GlobalParams]
  PorousFlowDictator = dictator
[]

[Variables]
  [./pp]
  [../]
[]

[ICs]
  [./pinit]
    type = FunctionIC
    function = 10
    variable = pp
  [../]
[]

[Kernels]
  [./mass0]
    type = PorousFlowMassTimeDerivative
    fluid_component = 0
    variable = pp
  [../]
  [./decay]
    type = PorousFlowMassRadioactiveDecay
    fluid_component = 0
    variable = pp
    decay_rate = 2.0
  [../]
[]

[UserObjects]
  [./dictator]
    type = PorousFlowDictator
    porous_flow_vars = 'pp'
    number_fluid_phases = 1
    number_fluid_components = 1
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
    al = 1
    m = 0.5
  [../]
  [./massfrac]
    type = PorousFlowMassFraction
    at_nodes = true
  [../]
  [./dens0]
    type = PorousFlowDensityConstBulk
    at_nodes = true
    density_P0 = 1
    bulk_modulus = 1
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
[]

[Postprocessors]
  [./total_mass]
    type = PorousFlowFluidMass
    execute_on = 'timestep_end'
  [../]
  [./total_mass0]
    type = PorousFlowFluidMass
    execute_on = 'timestep_begin'
  [../]
  [./should_be_zero]
    type = FunctionValuePostprocessor
    function = should_be_0
  [../]
[]

[Functions]
  [./should_be_0]
    type = ParsedFunction
    vars = 'm0 m rate dt'
    vals = 'total_mass0 total_mass 2.0 1'
    value = 'm-m0/(1.0+rate*dt)'
  [../]
[]

[Preconditioning]
  [./andy]
    type = SMP
    full = true
    petsc_options_iname = '-ksp_type -pc_type -snes_atol -snes_rtol -snes_max_it'
    petsc_options_value = 'bcgs bjacobi 1E-10 1E-10 10000'
  [../]
[]

[Executioner]
  type = Transient
  solve_type = Newton
  dt = 1
  num_steps = 1
[]

[Outputs]
  execute_on = 'timestep_end'
  file_base = radioactive_decay01
  csv = true
[]
