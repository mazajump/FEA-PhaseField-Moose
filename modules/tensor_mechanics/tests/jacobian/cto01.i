# checking jacobian for a fully-elastic situation
[Mesh]
  type = GeneratedMesh
  dim = 3
[]

[GlobalParams]
  block = 0
[]

[Variables]
  [./disp_x]
  [../]
  [./disp_y]
  [../]
  [./disp_z]
  [../]
[]

[ICs]
  [./disp_x]
    type = RandomIC
    variable = disp_x
    min = -0.1
    max = 0.1
  [../]
  [./disp_y]
    type = RandomIC
    variable = disp_y
    min = -0.1
    max = 0.1
  [../]
  [./disp_z]
    type = RandomIC
    variable = disp_z
    min = -0.1
    max = 0.1
  [../]
[]

[Kernels]
  [./TensorMechanics]
    displacements = 'disp_x disp_y disp_z'
  [../]
[]

[Materials]
  [./elasticity_tensor]
    type = ComputeElasticityTensor
    fill_method = symmetric_isotropic
    C_ijkl = '1 2'
  [../]
  [./strain]
    type = ComputeIncrementalSmallStrain
    displacements = 'disp_x disp_y disp_z'
  [../]
  [./mc]
    type = ComputeMultiPlasticityStress
    initial_stress = '1 2 3  2 -4 -5  3 -5 2'
    transverse_direction = '0 0 1'
    ep_plastic_tolerance = 1E-5
  [../]
[]

[Preconditioning]
  [./andy]
    type = SMP
    full = true
    petsc_options_iname = '-ksp_type -pc_type -snes_atol -snes_rtol -snes_max_it -snes_type'
    petsc_options_value = 'bcgs bjacobi 1E-15 1E-10 10000 test'
  [../]
[]

[Executioner]
  type = Transient
  solve_type = Newton
[]
