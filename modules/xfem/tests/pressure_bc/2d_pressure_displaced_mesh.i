[GlobalParams]
  order = FIRST
  family = LAGRANGE
  volumetric_locking_correction = False
[]

[XFEM]
  cut_data = '0.0 0.5 1.0 0.5 0 0'
  qrule = volfrac
  output_cut_plane = true
[]

[Mesh]
  type = GeneratedMesh
  dim = 2
  nx = 4
  ny = 5
  xmin = 0.0
  xmax = 1.0
  ymin = 0.0
  ymax = 1.0
  elem_type = QUAD4
  displacements = 'disp_x disp_y'
[]

[Variables]
  [./disp_x]
  [../]
  [./disp_y]
  [../]
[]

[AuxVariables]
  [./stress_xx]      # stress aux variables are defined for output; this is a way to get integration point variables to the output file
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./stress_yy]
    order = CONSTANT
    family = MONOMIAL
  [../]
[]

[AuxKernels]
  [./stress_xx]               # computes stress components for output
    type = MaterialTensorAux
    tensor = stress
    variable = stress_xx
    index = 0
    execute_on = timestep_end     # for efficiency, only compute at the end of a timestep
  [../]
  [./stress_yy]
    type = MaterialTensorAux
    tensor = stress
    variable = stress_yy
    index = 1
    execute_on = timestep_end
  [../]
[]

[SolidMechanics]
  [./solid]
    disp_x = disp_x
    disp_y = disp_y
    use_displaced_mesh = true
  [../]
[]

[Functions]
  [./pressure]
    type = PiecewiseLinear
    x = '0 1.0'
    y = '500 500'
  [../]
  [./bc_func_tx]
    type = ParsedFunction
    value = '0.5-(0.5-x)*cos(pi*t/2.0)-x'
  [../]
  [./bc_func_ty]
    type = ParsedFunction
    value = '(0.5-x)*sin(pi*t/2.0)+0.5'
  [../]
[]

[BCs]
  [./bottom_y]
    type = PresetBC
    boundary = 0
    variable = disp_y
    value = 0.0
  [../]
  [./bottom_x]
    type = PresetBC
    boundary = 0
    variable = disp_x
    value = 0.0
  [../]
  [./top_right_y]
    type = FunctionDirichletBC
    boundary = 2
    variable = disp_y
    function = bc_func_ty
  [../]
  [./top_right_x]
    type = FunctionDirichletBC
    boundary = 2
    variable = disp_x
    function = bc_func_tx
  [../]
[]

[DiracKernels]
  [./pressure_x]
    type = XFEMPressure
    variable = disp_x
    component = 0
    function = pressure
    use_displaced_mesh = true
  [../]
  [./pressure_y]
    type = XFEMPressure
    variable = disp_y
    component = 1
    function = pressure
    use_displaced_mesh = true
  [../]
[]

[Materials]
  [./elast]
    type = Elastic
    block = 0
    disp_x = disp_x
    disp_y = disp_y
    poissons_ratio = 0.3
    youngs_modulus = 1e6
    formulation = NonlinearPlaneStrain
  [../]
[]

[Executioner]
  type = Transient

  solve_type = 'PJFNK'
  petsc_options_iname = '-ksp_gmres_restart -pc_type -pc_hypre_type -pc_hypre_boomeramg_max_iter'
  petsc_options_value = '201                hypre    boomeramg      8'

  line_search = 'none'

  [./Predictor]
    type = SimplePredictor
    scale = 1.0
  [../]

# controls for linear iterations
  l_max_its = 100
  l_tol = 1e-2

# controls for nonlinear iterations
  nl_max_its = 15
  nl_rel_tol = 1e-12
  nl_abs_tol = 1e-14

# time control
  start_time = 0.0
  dt = 0.1
  end_time = 1.0
[]

[Outputs]
  file_base = 2d_pressure_displaced_mesh_out
  exodus = true
  [./console]
    type = Console
    perf_log = true
    output_linear = true
  [../]
[]
