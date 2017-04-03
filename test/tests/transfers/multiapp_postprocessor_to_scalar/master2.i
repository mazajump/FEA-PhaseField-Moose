[Mesh]
  type = GeneratedMesh
  dim = 2
  nx = 10
  ny = 10
[]

[Variables]
  [./u]
  [../]
[]

[AuxVariables]
  [./from_sub_app]
    order = THIRD
    family = SCALAR
  [../]
[]

[Kernels]
  [./diff]
    type = CoefDiffusion
    variable = u
    coef = 0.01
  [../]
  [./td]
    type = TimeDerivative
    variable = u
  [../]
[]

[BCs]
  [./left]
    type = DirichletBC
    variable = u
    boundary = left
    value = 0
  [../]
  [./right]
    type = DirichletBC
    variable = u
    boundary = right
    value = 1
  [../]
[]

[Postprocessors]
  [./average]
    type = ElementAverageValue
    variable = u
  [../]
  [./point_value_0]
    type = ScalarVariable
    variable = from_sub_app
    component = 0
  [../]
  [./point_value_1]
    type = ScalarVariable
    variable = from_sub_app
    component = 1
  [../]
  [./point_value_2]
    type = ScalarVariable
    variable = from_sub_app
    component = 2
  [../]
[]

[Executioner]
  # Preconditioned JFNK (default)
  type = Transient
  num_steps = 5
  solve_type = PJFNK
  petsc_options_iname = '-pc_type -pc_hypre_type'
  petsc_options_value = 'hypre boomeramg'
[]

[Outputs]
  exodus = true
  hide = from_sub_app
[]

[MultiApps]
  [./pp_sub]
    app_type = MooseTestApp
    positions = '0.5 0.5 0
                 0.7 0.7 0
                 0.8 0.8 0'
    execute_on = timestep_end
    type = TransientMultiApp
    input_files = sub2.i
  [../]
[]

[Transfers]
  [./pp_transfer]
    type = MultiAppPostprocessorToAuxScalarTransfer
    direction = from_multiapp
    multi_app = pp_sub
    from_postprocessor = point_value
    to_aux_scalar = from_sub_app
  [../]
[]
