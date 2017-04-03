# This tests the thermal expansion coefficient function using both
# options to specify that function: mean and instantaneous.  There
# two blocks, each containing a single element, and these use the
# two variants of the function.

# In this test, the instantaneous CTE function is a linear function
# while the mean CTE function is an analytic function designed to
# give the same response.  If \bar{alpha}(T) is the mean CTE function,
# and \alpha(T) is the instantaneous CTE function,

# \bar{\alpha}(T) = 1/(T-Tref) \intA^{T}_{Tsf} \alpha(T) dT

# where Tref is the reference temperature used to define the mean CTE
# function, and Tsf is the stress-free temperature.

# This version of the test uses small deformation theory.  The results
# from the two models are identical.

[Mesh]
  file = 'blocks.e'
[]

[GlobalParams]
  displacements = 'disp_x disp_y disp_z'
[]

[AuxVariables]
  [./temp]
    order = FIRST
    family = LAGRANGE
  [../]
[]

[Modules/TensorMechanics/Master]
  [./all]
    strain = SMALL
    incremental = false
    add_variables = true
    eigenstrain_names = eigenstrain
    generate_output = 'strain_xx strain_yy strain_zz'
  [../]
[]

[BCs]
  [./left]
    type = DirichletBC
    variable = disp_x
    boundary = 3
    value = 0.0
  [../]

  [./bottom]
    type = DirichletBC
    variable = disp_y
    boundary = 2
    value = 0.0
  [../]

  [./back]
    type = DirichletBC
    variable = disp_z
    boundary = 1
    value = 0.0
  [../]
[]

[AuxKernels]
  [./temp]
    type = FunctionAux
    variable = temp
    block = '1 2'
    function = temp_func
  [../]
[]

[Materials]
  [./elasticity_tensor]
    type = ComputeIsotropicElasticityTensor
    youngs_modulus = 1e6
    poissons_ratio = 0.3
  [../]
  [./small_stress]
    type = ComputeLinearElasticStress
  [../]
  [./thermal_expansion_strain1]
    type = ComputeMeanThermalExpansionFunctionEigenstrain
    block = 1
    thermal_expansion_function = cte_func_mean
    thermal_expansion_function_reference_temperature = 0.5
    stress_free_temperature = 0.0
    temperature = temp
    incremental_form = false
    eigenstrain_name = eigenstrain
  [../]
  [./thermal_expansion_strain2]
    type = ComputeInstantaneousThermalExpansionFunctionEigenstrain
    block = 2
    thermal_expansion_function = cte_func_inst
    stress_free_temperature = 0.0
    temperature = temp
    incremental_form = false
    eigenstrain_name = eigenstrain
  [../]
[]

[Functions]
  [./cte_func_mean]
    type = ParsedFunction
    vars = 'tsf tref scale' #stress free temp, reference temp, scale factor
    vals = '0.0 0.5  1e-4'
    value = 'scale * (0.5 * t^2 - 0.5 * tsf^2) / (t - tref)'
  [../]
  [./cte_func_inst]
    type = PiecewiseLinear
    xy_data = '0 0.0
               2 2.0'
    scale_factor = 1e-4
  [../]

  [./temp_func]
    type = PiecewiseLinear
    xy_data = '0 1
               1 2'
  [../]
[]

[Postprocessors]
  [./disp_1]
    type = NodalMaxValue
    variable = disp_x
    boundary = 101
  [../]

  [./disp_2]
    type = NodalMaxValue
    variable = disp_x
    boundary = 102
  [../]
[]

[Executioner]
  type = Transient

  solve_type = PJFNK
  l_max_its = 100
  l_tol = 1e-4
  nl_abs_tol = 1e-8
  nl_rel_tol = 1e-12

  start_time = 0.0
  end_time = 1.0
  dt = 0.1
[]

[Outputs]
  file_base = small_linear_alpha_out
  exodus = true
  csv = true
[]
