[Mesh]
 type = GeneratedMesh
 dim = 1
 xmin = 0
 xmax = 10
 nx = 8
[]

[Problem]
  null_space_dimension = 1
[]

[Variables]
  [./u]
    order = FIRST
    family = LAGRANGE
  [../]
[]

[Kernels]
  [./diff]
    type = Diffusion
    variable = u
  [../]

  [./eig]
    type = MassEigenKernel
    variable = u
    eigen_postprocessor = 1.0002920196258376e+01
    eigen = false
  [../]

  [./force]
    type = CoupledForce
    variable = u
    v = aux_v
  [../]
[]

[AuxVariables]
  [./aux_v]
    order = FIRST
    family = LAGRANGE
    [./InitialCondition]
      type = FunctionIC
      function = eigen_mode
    [../]
  [../]
[]

[AuxKernels]
  [./set_source]
    type = FunctionAux
    variable = aux_v
    function = second_harmonic
    execute_on = timestep_begin
  [../]
[]

[Functions]
  [./eigen_mode]
    type = ParsedFunction
    value = 'sqrt(2.0 / L) * sin(mode * pi  * x / L)'
    vars = 'L  mode'
    vals = '10 1'
  [../]

  [./second_harmonic]
    type = ParsedFunction
    value = 'sqrt(2.0 / L) * sin(mode * pi  * x / L)'
    vars = 'L  mode'
    vals = '10 2'
  [../]
[]

[BCs]
  [./homogeneous]
    type = DirichletBC
    variable = u
    boundary = '0 1'
    value = 0
  [../]
[]

[VectorPostprocessors]
  [./sample_solution]
    type = LineValueSampler
    variable = u
    start_point = '0 0 0'
    end_point = '10 0 0'
    sort_by = x
    num_points = 9
    execute_on = timestep_end
  [../]
[]

[Preconditioning]
  [./prec]
    type = SMP
    full = true
  [../]
[]

[Executioner]
  type = SteadyWithNull
  petsc_options_iname = '-pc_type -pc_hypre_type -ksp_pc_side -snes_type'
  petsc_options_value = 'hypre boomeramg  left ksponly'
  nl_rel_tol = 1.0e-14
  nl_abs_tol = 1.0e-14
[]

[Outputs]
  execute_on = 'timestep_end'
  csv = true
[]
