# This test covers the usage of the VariableTimeIntegrationAux
# kernel. Here we test three different schemes for integrating a field
# variable in time.  Midpoint, Trapezoidal, and Simpson's rule are
# used.  For this test, we use a manufactured solution and we compare
# the Trapezoidal and Simpson's rule, which must be exact for this
# exact solution, which is a linear function of time.
#
# The set up problem is
#
#  du/dt - Laplacian(u) = Q
#
# with exact solution: u = t*(x*x+y*y).
[Mesh]
  type = GeneratedMesh
  dim = 2
  elem_type = QUAD9
  xmin = 0
  xmax = 1
  ymin = 0
  ymax = 1
  nx = 10
  ny = 10
[]

[Variables]
  [./u]
    initial_condition = 0.0
    family = LAGRANGE
    order = SECOND
  [../]
[]

[Kernels]
  active = 'diff timederivative sourceterm'
  [./diff]
     type = Diffusion
     variable = u
  [../]
  [./timederivative]
     type = TimeDerivative
     variable = u
  [../]
  [./sourceterm]
     type =  UserForcingFunction
     variable = u
     function = Source
  [../]
[]

[AuxVariables]
  active = 'v_midpoint v_trapazoid v_simpson'
  [./v_midpoint]
  [../]
  [./v_trapazoid]
  [../]
  [./v_simpson]
  [../]
[]

[AuxKernels]
  [./MidpointTimeIntegrator]
    type = VariableTimeIntegrationAux
    variable_to_integrate = u
    variable = v_midpoint
    order = 1
  [../]
  [./TrapazoidalTimeIntegrator]
    type = VariableTimeIntegrationAux
    variable_to_integrate = u
    variable = v_trapazoid
    order = 2
  [../]
  [./SimpsonsTimeIntegrator]
    type = VariableTimeIntegrationAux
    variable_to_integrate = u
    variable = v_simpson
    order = 3
  [../]
[]

[BCs]
  active = 'RightBC LeftBC TopBC BottomBC'
 [./RightBC]
    type = FunctionDirichletBC
    variable = u
    function = RightBC
    boundary = 'right'
 [../]
 [./LeftBC]
    type = FunctionDirichletBC
    variable = u
    function = LeftBC
    boundary = 'left'
 [../]
 [./TopBC]
    type = FunctionDirichletBC
    variable = u
    function = TopBC
    boundary = 'top'
 [../]
 [./BottomBC]
    type = FunctionDirichletBC
    variable = u
    function = BottomBC
    boundary = 'bottom'
 [../]
[]

[Functions]
  active = 'Soln Source TopBC BottomBC RightBC LeftBC'
 [./Soln]
    type = ParsedFunction
    value = 't*(x*x+y*y)'
 [../]
 [./Source]
    type = ParsedFunction
    value = '(x*x + y*y) - 4*t'
 [../]
 [./TopBC]
    type = ParsedFunction
    value = 't*(x*x+1)'
 [../]
 [./BottomBC]
    type = ParsedFunction
    value = 't*x*x'
 [../]
 [./RightBC]
   type = ParsedFunction
   value = 't*(y*y+1)'
 [../]
 [./LeftBC]
    type = ParsedFunction
    value = 't*y*y'
  [../]
[]
[Postprocessors]
  [./l2_error]
    type = NodalL2Error
    variable = u
    function = Soln
  [../]
[]

[Executioner]
  type = Transient

  end_time = 0.1
#  dt = 0.1
#  num_steps = 10
  [./TimeStepper]
     type = FunctionDT
     time_t = '0.01 0.1'
     time_dt = '0.005 0.05'
  [../]

  nl_abs_tol = 1.e-15
[]

[Outputs]
  execute_on = 'timestep_end'
  exodus = true
[]
