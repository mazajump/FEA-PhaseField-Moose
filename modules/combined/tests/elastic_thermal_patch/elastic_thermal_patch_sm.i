# Patch Test

# This test is designed to compute constant xx, yy, zz, xy, yz, and zx
#  stress on a set of irregular hexes.  The mesh is composed of one
#  block with seven elements.  The elements form a unit cube with one
#  internal element.  There is a nodeset for each exterior node.

# The cube is displaced by 1e-6 units in x, 2e-6 in y, and 3e-6 in z.
#  The faces are sheared as well (1e-6, 2e-6, and 3e-6 for xy, yz, and
#  zx).  This gives a uniform strain/stress state for all six unique
#  tensor components.

# With Young's modulus at 1e6 and Poisson's ratio at 0, the shear
#  modulus is 5e5 (G=E/2/(1+nu)).  Therefore, for the mechanical strain,
#
#  stress xx = 1e6 * 1e-6 = 1
#  stress yy = 1e6 * 2e-6 = 2
#  stress zz = 1e6 * 3e-6 = 3
#  stress xy = 2 * 5e5 * 1e-6 / 2 = 0.5
#             (2 * G   * gamma_xy / 2 = 2 * G * epsilon_xy)
#  stress yz = 2 * 5e5 * 2e-6 / 2 = 1
#  stress zx = 2 * 5e5 * 3e-6 / 2 = 1.5

# However, we must also consider the thermal strain.
# The temperature moves 100 degrees, and the coefficient of thermal
#  expansion is 1e-8.  Therefore, the thermal strain (and the displacement
#  since this is a unit cube) is 1e-6.

# Therefore, the overall effect is (at time 1, with a 50 degree delta):
#
#  stress xx = 1e6 * (1e-6-0.5e-6) = 0.5
#  stress yy = 1e6 * (2e-6-0.5e-6) = 1.5
#  stress zz = 1e6 * (3e-6-0.5e-6) = 2.5
#  stress xy = 2 * 5e5 * 1e-6 / 2 = 0.5
#             (2 * G   * gamma_xy / 2 = 2 * G * epsilon_xy)
#  stress yz = 2 * 5e5 * 2e-6 / 2 = 1
#  stress zx = 2 * 5e5 * 3e-6 / 2 = 1.5
#
# At time 2:
#
#  stress xx = 1e6 * (1e-6-1e-6) = 0
#  stress yy = 1e6 * (2e-6-1e-6) = 1
#  stress zz = 1e6 * (3e-6-1e-6) = 2
#  stress xy = 2 * 5e5 * 1e-6 / 2 = 0.5
#             (2 * G   * gamma_xy / 2 = 2 * G * epsilon_xy)
#  stress yz = 2 * 5e5 * 2e-6 / 2 = 1
#  stress zx = 2 * 5e5 * 3e-6 / 2 = 1.5

[Mesh]
  file = elastic_thermal_patch_test.e
  displacements = 'disp_x disp_y disp_z'
[]

[Functions]
  [./rampConstant1]
    type = PiecewiseLinear
    x = '0. 1. 2.'
    y = '0. 1. 1.'
    scale_factor = 1e-6
  [../]
  [./rampConstant2]
    type = PiecewiseLinear
    x = '0. 1. 2.'
    y = '0. 1. 1.'
    scale_factor = 2e-6
  [../]
  [./rampConstant3]
    type = PiecewiseLinear
    x = '0. 1. 2.'
    y = '0. 1. 1.'
    scale_factor = 3e-6
  [../]
  [./rampConstant4]
    type = PiecewiseLinear
    x = '0. 1. 2.'
    y = '0. 1. 1.'
    scale_factor = 4e-6
  [../]
  [./rampConstant6]
    type = PiecewiseLinear
    x = '0. 1. 2.'
    y = '0. 1. 1.'
    scale_factor = 6e-6
  [../]
  [./tempFunc]
    type = PiecewiseLinear
    x = '0. 2.'
    y = '117.56 217.56'
  [../]
[]

[Variables]
  [./disp_x]
  [../]
  [./disp_y]
  [../]
  [./disp_z]
  [../]

  [./temp]
    initial_condition = 117.56
  [../]
[]

[AuxVariables]
  [./stress_xx]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./stress_yy]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./stress_zz]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./stress_xy]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./stress_yz]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./stress_zx]
    order = CONSTANT
    family = MONOMIAL
  [../]
[]

[SolidMechanics]
  [./solid]
    disp_x = disp_x
    disp_y = disp_y
    disp_z = disp_z
  [../]
[]

[Kernels]
  [./heat]
    type = HeatConduction
    variable = temp
  [../]
[]

[AuxKernels]
  [./stress_xx]
    type = MaterialTensorAux
    tensor = stress
    variable = stress_xx
    index = 0
  [../]
  [./stress_yy]
    type = MaterialTensorAux
    tensor = stress
    variable = stress_yy
    index = 1
  [../]
  [./stress_zz]
    type = MaterialTensorAux
    tensor = stress
    variable = stress_zz
    index = 2
  [../]
  [./stress_xy]
    type = MaterialTensorAux
    tensor = stress
    variable = stress_xy
    index = 3
  [../]
  [./stress_yz]
    type = MaterialTensorAux
    tensor = stress
    variable = stress_yz
    index = 4
  [../]
  [./stress_zx]
    type = MaterialTensorAux
    tensor = stress
    variable = stress_zx
    index = 5
  [../]
[]

[BCs]
  [./node1_x]
    type = DirichletBC
    variable = disp_x
    boundary = 1
    value = 0.0
  [../]
  [./node1_y]
    type = FunctionDirichletBC
    variable = disp_y
    boundary = 1
    function = rampConstant2
  [../]
  [./node1_z]
    type = FunctionDirichletBC
    variable = disp_z
    boundary = 1
    function = rampConstant3
  [../]

  [./node2_x]
    type = FunctionDirichletBC
    variable = disp_x
    boundary = 2
    function = rampConstant1
  [../]
  [./node2_y]
    type = FunctionDirichletBC
    variable = disp_y
    boundary = 2
    function = rampConstant2
  [../]
  [./node2_z]
    type = FunctionDirichletBC
    variable = disp_z
    boundary = 2
    function = rampConstant6
  [../]

  [./node3_x]
    type = FunctionDirichletBC
    variable = disp_x
    boundary = 3
    function = rampConstant1
  [../]
  [./node3_y]
    type = DirichletBC
    variable = disp_y
    boundary = 3
    value = 0.0
  [../]
  [./node3_z]
    type = FunctionDirichletBC
    variable = disp_z
    boundary = 3
    function = rampConstant3
  [../]

  [./node4_x]
    type = DirichletBC
    variable = disp_x
    boundary = 4
    value = 0.0
  [../]
  [./node4_y]
    type = DirichletBC
    variable = disp_y
    boundary = 4
    value = 0.0
  [../]
  [./node4_z]
    type = DirichletBC
    variable = disp_z
    boundary = 4
    value = 0.0
  [../]

  [./node5_x]
    type = FunctionDirichletBC
    variable = disp_x
    boundary = 5
    function = rampConstant1
  [../]
  [./node5_y]
    type = FunctionDirichletBC
    variable = disp_y
    boundary = 5
    function = rampConstant4
  [../]
  [./node5_z]
    type = FunctionDirichletBC
    variable = disp_z
    boundary = 5
    function = rampConstant3
  [../]

  [./node6_x]
    type = FunctionDirichletBC
    variable = disp_x
    boundary = 6
    function = rampConstant2
  [../]
  [./node6_y]
    type = FunctionDirichletBC
    variable = disp_y
    boundary = 6
    function = rampConstant4
  [../]
  [./node6_z]
    type = FunctionDirichletBC
    variable = disp_z
    boundary = 6
    function = rampConstant6
  [../]

  [./node7_x]
    type = FunctionDirichletBC
    variable = disp_x
    boundary = 7
    function = rampConstant2
  [../]
  [./node7_y]
    type = FunctionDirichletBC
    variable = disp_y
    boundary = 7
    function = rampConstant2
  [../]
  [./node7_z]
    type = FunctionDirichletBC
    variable = disp_z
    boundary = 7
    function = rampConstant3
  [../]

  [./node8_x]
    type = FunctionDirichletBC
    variable = disp_x
    boundary = 8
    function = rampConstant1
  [../]
  [./node8_y]
    type = FunctionDirichletBC
    variable = disp_y
    boundary = 8
    function = rampConstant2
  [../]
  [./node8_z]
    type = DirichletBC
    variable = disp_z
    boundary = 8
    value = 0.0
  [../]

  [./temp]
    type = FunctionDirichletBC
    variable = temp
    boundary = '10 12'
    function = tempFunc
  [../]
[]

[Materials]
  [./stiffStuff1]
    type = Elastic
    block = '1 2 3 4 5 6 7'

    disp_x = disp_x
    disp_y = disp_y
    disp_z = disp_z

    bulk_modulus = 0.333333333333333e6
    shear_modulus = 0.5e6

    temp = temp
    thermal_expansion = 1e-8

    increment_calculation = eigen
  [../]

  [./heat]
    type = HeatConductionMaterial
    block = '1 2 3 4 5 6 7'

    specific_heat = 1.0
    thermal_conductivity = 1.0
  [../]

  [./density]
    type = Density
    block = '1 2 3 4 5 6 7'
    density = 1.0
    disp_x = disp_x
    disp_y = disp_y
    disp_z = disp_z
  [../]
[]

[Executioner]
  type = Transient
  solve_type = 'PJFNK'

  nl_rel_tol = 1e-12
  l_max_its = 20

  start_time = 0.0
  dt = 1.0
  num_steps = 2
  end_time = 2.0
[]

[Outputs]
  file_base = elastic_thermal_patch_out
  [./exodus]
    type = Exodus
    elemental_as_nodal = true
  [../]
[]
