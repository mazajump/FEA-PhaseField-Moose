# A sample is constrained on all sides, except its top
# and its boundaries are
# also impermeable.  Fluid is pumped into the sample via a
# volumetric source (ie kg/second per cubic meter), and the
# rise in the top surface, porepressure, and stress are observed.
#
# In the standard poromechanics scenario, the Biot Modulus is held
# fixed and the source has units 1/time.  Then the expected result
# is
# strain_zz = disp_z = BiotCoefficient*BiotModulus*s*t/((bulk + 4*shear/3) + BiotCoefficient^2*BiotModulus)
# porepressure = BiotModulus*(s*t - BiotCoefficient*strain_zz)
# stress_xx = (bulk - 2*shear/3)*strain_zz   (remember this is effective stress)
# stress_zz = (bulk + 4*shear/3)*strain_zz   (remember this is effective stress)
#
# In porous_flow, however, the source has units kg/s/m^3.  The ratios remain
# fixed:
# stress_xx/strain_zz = (bulk - 2*shear/3) = 1 (for the parameters used here)
# stress_zz/strain_zz = (bulk + 4*shear/3) = 4 (for the parameters used here)
# porepressure/strain_zz = 13.3333333 (for the parameters used here)
#
# Expect
# disp_z = 0.3*10*s*t/((2 + 4*1.5/3) + 0.3^2*10) = 0.612245*s*t
# porepressure = 10*(s*t - 0.3*0.612245*s*t) = 8.163265*s*t
# stress_xx = (2 - 2*1.5/3)*0.612245*s*t = 0.612245*s*t
# stress_zz = (2 + 4*shear/3)*0.612245*s*t = 2.44898*s*t
# The relationship between the constant poroelastic source
# s (m^3/second/m^3) and the PorousFlow source, S (kg/second/m^3) is
# S = fluid_density * s = s * exp(porepressure/fluid_bulk)
#
# Finally, note that the volumetric strain has
# consistent_with_displaced_mesh = false
# which is needed when using the FullySaturated version of the Kernels
# in order to generate the above results
[Mesh]
  type = GeneratedMesh
  dim = 3
  nx = 1
  ny = 1
  nz = 1
  xmin = -0.5
  xmax = 0.5
  ymin = -0.5
  ymax = 0.5
  zmin = -0.5
  zmax = 0.5
[]

[GlobalParams]
  displacements = 'disp_x disp_y disp_z'
  PorousFlowDictator = dictator
  block = 0
[]

[UserObjects]
  [./dictator]
    type = PorousFlowDictator
    porous_flow_vars = 'porepressure disp_x disp_y disp_z'
    number_fluid_phases = 1
    number_fluid_components = 1
  [../]
[]

[Variables]
  [./disp_x]
  [../]
  [./disp_y]
  [../]
  [./disp_z]
  [../]
  [./porepressure]
  [../]
[]

[BCs]
  [./confinex]
    type = PresetBC
    variable = disp_x
    value = 0
    boundary = 'left right'
  [../]
  [./confiney]
    type = PresetBC
    variable = disp_y
    value = 0
    boundary = 'bottom top'
  [../]
  [./confinez]
    type = PresetBC
    variable = disp_z
    value = 0
    boundary = 'back'
  [../]
[]


[Kernels]
  [./grad_stress_x]
    type = StressDivergenceTensors
    variable = disp_x
    component = 0
  [../]
  [./grad_stress_y]
    type = StressDivergenceTensors
    variable = disp_y
    component = 1
  [../]
  [./grad_stress_z]
    type = StressDivergenceTensors
    variable = disp_z
    component = 2
  [../]
  [./poro_x]
    type = PorousFlowEffectiveStressCoupling
    biot_coefficient = 0.3
    variable = disp_x
    component = 0
  [../]
  [./poro_y]
    type = PorousFlowEffectiveStressCoupling
    biot_coefficient = 0.3
    variable = disp_y
    component = 1
  [../]
  [./poro_z]
    type = PorousFlowEffectiveStressCoupling
    biot_coefficient = 0.3
    component = 2
    variable = disp_z
  [../]
  [./mass0]
    type = PorousFlowFullySaturatedMassTimeDerivative
    variable = porepressure
    simulation_type = HydroMechanical
    biot_coefficient = 0.3
  [../]
  [./source]
    type = UserForcingFunction
    function = '0.1*exp(8.163265306*0.1*t/3.3333333333)'
    variable = porepressure
  [../]
[]

[AuxVariables]
  [./stress_xx]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./stress_xy]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./stress_xz]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./stress_yy]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./stress_yz]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./stress_zz]
    order = CONSTANT
    family = MONOMIAL
  [../]
[]

[AuxKernels]
  [./stress_xx]
    type = RankTwoAux
    rank_two_tensor = stress
    variable = stress_xx
    index_i = 0
    index_j = 0
  [../]
  [./stress_xy]
    type = RankTwoAux
    rank_two_tensor = stress
    variable = stress_xy
    index_i = 0
    index_j = 1
  [../]
  [./stress_xz]
    type = RankTwoAux
    rank_two_tensor = stress
    variable = stress_xz
    index_i = 0
    index_j = 2
  [../]
  [./stress_yy]
    type = RankTwoAux
    rank_two_tensor = stress
    variable = stress_yy
    index_i = 1
    index_j = 1
  [../]
  [./stress_yz]
    type = RankTwoAux
    rank_two_tensor = stress
    variable = stress_yz
    index_i = 1
    index_j = 2
  [../]
  [./stress_zz]
    type = RankTwoAux
    rank_two_tensor = stress
    variable = stress_zz
    index_i = 2
    index_j = 2
  [../]
[]



[Materials]
  [./temperature_qp]
    type = PorousFlowTemperature
  [../]
  [./elasticity_tensor]
    type = ComputeElasticityTensor
    C_ijkl = '1 1.5'
    # bulk modulus is lambda + 2*mu/3 = 1 + 2*1.5/3 = 2
    fill_method = symmetric_isotropic
  [../]
  [./strain]
    type = ComputeSmallStrain
    displacements = 'disp_x disp_y disp_z'
  [../]
  [./stress]
    type = ComputeLinearElasticStress
  [../]
  [./eff_fluid_pressure]
    type = PorousFlowEffectiveFluidPressure
  [../]
  [./vol_strain]
    type = PorousFlowVolumetricStrain
    consistent_with_displaced_mesh = false
  [../]
  [./ppss]
    type = PorousFlow1PhaseP
    porepressure = porepressure
  [../]
  [./dens0_qp]
    type = PorousFlowDensityConstBulk
    density_P0 = 1
    bulk_modulus = 3.3333333333
    phase = 0
  [../]
  [./dens_all_at_quadpoints]
    type = PorousFlowJoiner
    material_property = PorousFlow_fluid_phase_density_qp
    at_nodes = false
  [../]
  [./porosity]
    type = PorousFlowPorosityConst # the "const" is irrelevant here: all that uses Porosity is the BiotModulus, which just uses the initial value of porosity
    porosity = 0.1
  [../]
  [./biot_modulus]
    type = PorousFlowConstantBiotModulus
    biot_coefficient = 0.3
    fluid_bulk_modulus = 3.3333333333
    solid_bulk_compliance = 0.5
  [../]
[]

[Postprocessors]
  [./p0]
    type = PointValue
    outputs = csv
    point = '0 0 0'
    variable = porepressure
  [../]
  [./zdisp]
    type = PointValue
    outputs = csv
    point = '0 0 0.5'
    variable = disp_z
  [../]
  [./stress_xx]
    type = PointValue
    outputs = csv
    point = '0 0 0'
    variable = stress_xx
  [../]
  [./stress_yy]
    type = PointValue
    outputs = csv
    point = '0 0 0'
    variable = stress_yy
  [../]
  [./stress_zz]
    type = PointValue
    outputs = csv
    point = '0 0 0'
    variable = stress_zz
  [../]
  [./stress_xx_over_strain]
    type = FunctionValuePostprocessor
    function = stress_xx_over_strain_fcn
    outputs = csv
  [../]
  [./stress_zz_over_strain]
    type = FunctionValuePostprocessor
    function = stress_zz_over_strain_fcn
    outputs = csv
  [../]
  [./p_over_strain]
    type = FunctionValuePostprocessor
    function = p_over_strain_fcn
    outputs = csv
  [../]
[]

[Functions]
  [./stress_xx_over_strain_fcn]
    type = ParsedFunction
    value = a/b
    vars = 'a b'
    vals = 'stress_xx zdisp'
  [../]
  [./stress_zz_over_strain_fcn]
    type = ParsedFunction
    value = a/b
    vars = 'a b'
    vals = 'stress_zz zdisp'
  [../]
  [./p_over_strain_fcn]
    type = ParsedFunction
    value = a/b
    vars = 'a b'
    vals = 'p0 zdisp'
  [../]
[]


[Preconditioning]
  [./andy]
    type = SMP
    full = true
    petsc_options_iname = '-ksp_type -pc_type -snes_atol -snes_rtol -snes_max_it'
    petsc_options_value = 'bcgs bjacobi 1E-14 1E-10 10000'
  [../]
[]

[Executioner]
  type = Transient
  solve_type = Newton
  start_time = 0
  end_time = 10
  dt = 1
[]

[Outputs]
  execute_on = 'timestep_end'
  file_base = pp_generation_unconfined_fully_saturated
  [./csv]
    type = CSV
  [../]
[]
