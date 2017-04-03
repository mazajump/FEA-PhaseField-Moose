# Tests correct calculation of properties in PorousFlowFluidStateWaterNCG.
# This test is run three times, with the initial condition of z (the total mass
# fraction of NCG in all phases) varied to give either a single phase liquid, a
# single phase gas, or two phases.

[Mesh]
  type = GeneratedMesh
  dim = 2
[]

[GlobalParams]
  PorousFlowDictator = dictator
[]

[Variables]
  [./pgas]
    initial_condition = 1e6
  [../]
  [./z]
     initial_condition = 0.005
  [../]
[]

[AuxVariables]
  [./pressure_gas]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./pressure_water]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./saturation_gas]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./saturation_water]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./density_water]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./density_gas]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./viscosity_water]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./viscosity_gas]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./x0_water]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./x0_gas]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./x1_water]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./x1_gas]
    order = CONSTANT
    family = MONOMIAL
  [../]
[]

[AuxKernels]
  [./pressure_water]
    type = PorousFlowPropertyAux
    variable = pressure_water
    property = pressure
    phase = 0
    execute_on = timestep_end
  [../]
  [./pressure_gas]
    type = PorousFlowPropertyAux
    variable = pressure_gas
    property = pressure
    phase = 1
    execute_on = timestep_end
  [../]
  [./saturation_water]
    type = PorousFlowPropertyAux
    variable = saturation_water
    property = saturation
    phase = 0
    execute_on = timestep_end
  [../]
  [./saturation_gas]
    type = PorousFlowPropertyAux
    variable = saturation_gas
    property = saturation
    phase = 1
    execute_on = timestep_end
  [../]
  [./density_water]
    type = PorousFlowPropertyAux
    variable = density_water
    property = density
    phase = 0
    execute_on = timestep_end
  [../]
  [./density_gas]
    type = PorousFlowPropertyAux
    variable = density_gas
    property = density
    phase = 1
    execute_on = timestep_end
  [../]
  [./viscosity_water]
    type = PorousFlowPropertyAux
    variable = viscosity_water
    property = viscosity
    phase = 0
    execute_on = timestep_end
  [../]
  [./viscosity_gas]
    type = PorousFlowPropertyAux
    variable = viscosity_gas
    property = viscosity
    phase = 1
    execute_on = timestep_end
  [../]
  [./x1_water]
    type = PorousFlowPropertyAux
    variable = x1_water
    property = mass_fraction
    phase = 0
    fluid_component = 1
    execute_on = timestep_end
  [../]
  [./x1_gas]
    type = PorousFlowPropertyAux
    variable = x1_gas
    property = mass_fraction
    phase = 1
    fluid_component = 1
    execute_on = timestep_end
  [../]
  [./x0_water]
    type = PorousFlowPropertyAux
    variable = x0_water
    property = mass_fraction
    phase = 0
    fluid_component = 0
    execute_on = timestep_end
  [../]
  [./x0_gas]
    type = PorousFlowPropertyAux
    variable = x0_gas
    property = mass_fraction
    phase = 1
    fluid_component = 0
    execute_on = timestep_end
  [../]
[]

[Kernels]
  [./mass0]
    type = PorousFlowMassTimeDerivative
    variable = pgas
    fluid_component = 0
  [../]
  [./mass1]
    type = PorousFlowMassTimeDerivative
    variable = z
    fluid_component = 1
  [../]
[]

[UserObjects]
  [./dictator]
    type = PorousFlowDictator
    porous_flow_vars = 'pgas z'
    number_fluid_phases = 2
    number_fluid_components = 2
  [../]
[]

[Modules]
  [./FluidProperties]
    [./co2]
      type = CO2FluidProperties
    [../]
    [./water]
      type = Water97FluidProperties
    [../]
  [../]
[]

[Materials]
  [./temperature]
    type = PorousFlowTemperature
    temperature = 50
  [../]
  [./temperature_nodal]
    type = PorousFlowTemperature
    temperature = 50
    at_nodes = true
  [../]
  [./waterncg]
    type = PorousFlowFluidStateWaterNCG
    gas_porepressure = pgas
    z = z
    gas_fp = co2
    water_fp = water
    at_nodes = true
    temperature_unit = Celsius
  [../]
  [./waterncg_qp]
    type = PorousFlowFluidStateWaterNCG
    gas_porepressure = pgas
    z = z
    gas_fp = co2
    water_fp = water
    temperature_unit = Celsius
  [../]
  [./permeability]
    type = PorousFlowPermeabilityConst
    permeability = '1e-12 0 0 0 1e-12 0 0 0 1e-12'
  [../]
  [./relperm0]
    type = PorousFlowRelativePermeabilityCorey
    n = 2
    phase = 0
    at_nodes = true
  [../]
  [./relperm1]
    type = PorousFlowRelativePermeabilityCorey
    n = 3
    phase = 1
    at_nodes = true
  [../]
  [./relperm_all]
    type = PorousFlowJoiner
    material_property = PorousFlow_relative_permeability_nodal
    at_nodes = true
  [../]
  [./porosity]
    type = PorousFlowPorosityConst
    porosity = 0.1
    at_nodes = true
  [../]
[]

[Executioner]
  type = Transient
  solve_type = NEWTON
  dt = 1
  end_time = 1
  nl_abs_tol = 1e-12
[]

[Preconditioning]
  [./smp]
    type = SMP
    full = true
  [../]
[]

[Postprocessors]
  [./density_water]
    type = ElementIntegralVariablePostprocessor
    variable = density_water
  [../]
  [./density_gas]
    type = ElementIntegralVariablePostprocessor
    variable = density_gas
  [../]
  [./viscosity_water]
    type = ElementIntegralVariablePostprocessor
    variable = viscosity_water
  [../]
  [./viscosity_gas]
    type = ElementIntegralVariablePostprocessor
    variable = viscosity_gas
  [../]
  [./x1_water]
    type = ElementIntegralVariablePostprocessor
    variable = x1_water
  [../]
  [./x0_water]
    type = ElementIntegralVariablePostprocessor
    variable = x0_water
  [../]
  [./x1_gas]
    type = ElementIntegralVariablePostprocessor
    variable = x1_gas
  [../]
  [./x0_gas]
    type = ElementIntegralVariablePostprocessor
    variable = x0_gas
  [../]
  [./sg]
    type = ElementIntegralVariablePostprocessor
    variable = saturation_gas
  [../]
  [./sw]
    type = ElementIntegralVariablePostprocessor
    variable = saturation_water
  [../]
  [./pwater]
    type = ElementIntegralVariablePostprocessor
    variable = pressure_water
  [../]
  [./pgas]
    type = ElementIntegralVariablePostprocessor
    variable = pressure_gas
  [../]
  [./x0mass]
    type = PorousFlowFluidMass
    fluid_component = 0
    phase = '0 1'
  [../]
  [./x1mass]
    type = PorousFlowFluidMass
    fluid_component = 1
    phase = '0 1'
  [../]
[]

[Outputs]
  exodus = true
  file_base = waterncg_liquid
[]
