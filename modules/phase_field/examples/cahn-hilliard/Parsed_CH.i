#
# Example problem showing how to use the DerivativeParsedMaterial with CahnHilliard.
# The free energy is identical to that from CHMath, f_bulk = 1/4*(1-c)^2*(1+c)^2.
#

[Mesh]
  type = GeneratedMesh
  dim = 2
  nx = 100
  ny = 100
  xmax = 60
  ymax = 60
[]

[Variables]
  [./c]
    order = THIRD
    family = HERMITE
  [../]
[]

[AuxVariables]
  [./local_energy]
    order = CONSTANT
    family = MONOMIAL
  [../]
[]

[ICs]
  [./cIC]
    type = RandomIC
    variable = c
    min = -0.1
    max =  0.1
  [../]
[]

[Kernels]
  active = 'bulk interface dot'
  [./bulk]
    type = CahnHilliard
    variable = c
    f_name = fbulk
    mob_name = M
  [../]
  [./interface]
    type = CHInterface
    variable = c
    mob_name = M
    kappa_name = kappa_c
  [../]
  [./dot]
    type = TimeDerivative
    variable = c
  [../]

  # enable this kernel instead of 'bulk' to compare to CHMath
  [./bulk_reference]
    type = CHMath
    variable = c
    mob_name = M
  [../]
[]

[AuxKernels]
  [./local_energy]
    type = TotalFreeEnergy
    variable = local_energy
    f_name = fbulk
    interfacial_vars = c
    kappa_names = kappa_c
    execute_on = timestep_end
  [../]
[]

[BCs]
  [./Periodic]
    [./all]
      auto_direction = 'x y'
    [../]
  [../]
[]

[Materials]
  [./mat]
    type = GenericConstantMaterial
    prop_names  = 'M   kappa_c'
    prop_values = '1.0 0.5'
  [../]
  [./free_energy]
    type = DerivativeParsedMaterial
    f_name = fbulk
    args = c
    constant_names = W
    constant_expressions = 1.0/2^2
    function = W*(1-c)^2*(1+c)^2
    enable_jit = true
  [../]
[]

[Postprocessors]
  [./top]
    type = SideIntegralVariablePostprocessor
    variable = c
    boundary = top
  [../]
  [./total_free_energy]
    type = ElementIntegralVariablePostprocessor
    variable = local_energy
  [../]
[]

[Executioner]
  type = Transient
  solve_type = NEWTON
  scheme = bdf2

  # Alternative preconditioning using the additive Schwartz method and LU decomposition
  #petsc_options_iname = '-pc_type -sub_ksp_type -sub_pc_type'
  #petsc_options_value = 'asm      preonly       lu          '

  # Preconditioning options using Hypre (algebraic multi-grid)
  petsc_options_iname = '-pc_type -pc_hypre_type'
  petsc_options_value = 'hypre    boomeramg'

  l_max_its = 30
  l_tol = 1e-4
  nl_max_its = 20
  nl_rel_tol = 1e-9

  dt = 2.0
  end_time = 20.0
[]

[Outputs]
  exodus = true
  print_perf_log = true
[]
