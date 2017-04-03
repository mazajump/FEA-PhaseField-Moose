# The purpose of this test is to test the simple predictor.  This is a very
# small, monotonically loaded block of material.  If things are working right,
# the predictor should come very close to exactly nailing the solution on steps
# after the first step.

# The main thing to check here is that when the predictor is applied in the
# second step, the initial residual is almost zero.

[Mesh]
  type = GeneratedMesh
  dim = 2
  xmin = 0
  xmax = 1
  ymin = 0
  ymax = 1
  nx = 3
  ny = 3
[]

[Functions]
  [./ramp1]
    type = ParsedFunction
    value = 't'
  [../]
[]

[Variables]
  [./u]
    order = FIRST
    family = LAGRANGE
  [../]
[]

[Kernels]
  [./diff_u]
    type = Diffusion
    variable = u
  [../]
[]

[BCs]
  [./bot]
    type = PresetBC
    variable = u
    boundary = bottom
    value = 0.0
  [../]
  [./ss2_x]
    type = FunctionPresetBC
    variable = u
    boundary = top
    function = ramp1
  [../]
[]

[Executioner]
  type = Transient
  solve_type = 'PJFNK'

  nl_max_its = 15
  nl_rel_tol = 1e-14
  nl_abs_tol = 1e-14

  start_time = 0.0
  dt = 0.5
  end_time = 1.0

  [./Predictor]
    type = SimplePredictor
    scale = 1.0
  [../]
[]

[Postprocessors]
  [./final_residual]
    type = Residual
    residual_type = final
  [../]
  [./initial_residual_before]
    type = Residual
    residual_type = initial_before_preset
  [../]
  [./initial_residual_after]
    type = Residual
    residual_type = initial_after_preset
  [../]
[]

[Outputs]
  csv = true
[]
