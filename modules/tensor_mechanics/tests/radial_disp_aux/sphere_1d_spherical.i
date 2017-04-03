# The purpose of this set of tests is to check the values computed
# by the RadialDisplacementAux AuxKernel. They should match the
# radial component of the displacment for a cylindrical or spherical
# model.
# This particular model is of a sphere subjected to uniform thermal
# expansion represented using a 1D spherical model.

[Mesh]
  type = GeneratedMesh
  dim = 1
  elem_type = EDGE3
  nx = 4
  xmin = 0.0
  xmax = 1.0
[]

[GlobalParams]
  displacements = 'disp_x'
[]

[Problem]
  coord_type = RSPHERICAL
[]

[AuxVariables]
  [./temp]
  [../]
  [./rad_disp]
  [../]
[]

[Functions]
  [./temperature_load]
    type = ParsedFunction
    value = t+300.0
  [../]
[]

[Modules/TensorMechanics/Master]
  [./all]
    strain = FINITE
    add_variables = true
    eigenstrain_names = eigenstrain
  [../]
[]

[AuxKernels]
  [./tempfuncaux]
    type = FunctionAux
    variable = temp
    function = temperature_load
    use_displaced_mesh = false
  [../]
  [./raddispaux]
    type = RadialDisplacementSphereAux
    variable = rad_disp
  [../]
[]

[BCs]
  [./x]
    type = DirichletBC
    variable = disp_x
    boundary = left
    value = 0.0
  [../]
[]

[Materials]
  [./elasticity_tensor]
    type = ComputeIsotropicElasticityTensor
    youngs_modulus = 2.1e5
    poissons_ratio = 0.3
  [../]
  [./small_stress]
    type = ComputeFiniteStrainElasticStress
  [../]
  [./thermal_expansion]
    type = ComputeThermalExpansionEigenstrain
    stress_free_temperature = 300
    thermal_expansion_coeff = 1.3e-5
    temperature = temp
    incremental_form = true
    eigenstrain_name = eigenstrain
  [../]
[]

[Executioner]
  type = Transient
  solve_type = 'PJFNK'

  petsc_options = '-snes_ksp_ew'
  petsc_options_iname = '-ksp_gmres_restart'
  petsc_options_value = '51'

  line_search = 'none'

  l_max_its = 50
  nl_max_its = 50
  nl_rel_tol = 1e-11
  nl_abs_tol = 1e-10

  start_time = 0.0
  end_time = 1
  dt = 1
  dtmin = 1
[]

[Outputs]
  csv = true
  exodus = true
[]
