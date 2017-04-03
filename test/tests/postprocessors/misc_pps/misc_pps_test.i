[Mesh]
  type = GeneratedMesh
  dim = 2
  xmin = -1
  xmax = 1
  ymin = -1
  ymax = 1
  nx = 10
  ny = 10
  elem_type = QUAD9
[]

[Variables]
  [./u]
    order = SECOND
    family = LAGRANGE
    [./InitialCondition]
      type = ConstantIC
      value = 0
    [../]
  [../]
[]

[AuxVariables]
  [./aux_var]
    family = SCALAR
  [../]
[]

[Functions]
  [./forcing_fn]
    type = ParsedFunction
    value = 3*t*t*((x*x)+(y*y))-(4*t*t*t)
  [../]
  [./exact_fn]
    type = ParsedFunction
    value = t*t*t*((x*x)+(y*y))
  [../]
[]

[Kernels]
  [./ie]
    type = TimeDerivative
    variable = u
  [../]
  [./diff]
    type = Diffusion
    variable = u
  [../]
  [./ffn]
    type = UserForcingFunction
    variable = u
    function = forcing_fn
  [../]
[]

[BCs]
  active = 'all'
  [./all]
    type = FunctionDirichletBC
    variable = u
    boundary = '0 1 2 3'
    function = exact_fn
  [../]
  [./left]
    type = DirichletBC
    variable = u
    boundary = 3
    value = 0
  [../]
  [./right]
    type = DirichletBC
    variable = u
    boundary = 1
    value = 1
  [../]
[]

[Postprocessors]
  # Should be zero since we aren't setting this inside any MooseObject
  # This PPS will also always report zero in this test
  [./elapsed_time]
    type = RunTime
    time_type = active
  [../]
  [./num_nonlinear_its]
    type = NumNonlinearIterations
  [../]
  [./num_linear_its]
    type = NumLinearIterations
  [../]
  [./residual]
    type = Residual
  [../]
  [./reporter]
    type = ScalarVariable
    variable = aux_var
  [../]
  [./empty]
    type = EmptyPostprocessor
  [../]
  [./side_flux_integral]
    type = SideFluxIntegral
    diffusivity = diffusivity
    variable = u
    boundary = 2 # top
  [../]
[]

[Materials]
  [./constant_block]
    type = GenericConstantMaterial
    prop_names = diffusivity
    prop_values = 1
    block = 0
  [../]
[]

[Executioner]
  # Preconditioned JFNK (default)
  type = Transient
  scheme = implicit-euler
  solve_type = PJFNK
  start_time = 0.0
  num_steps = 10
  dt = 0.25
[]

[Outputs]
  execute_on = 'timestep_end'
  file_base = pps_out
  [./exodus]
    type = Exodus
    execute_scalars_on = none
  [../]
[]
