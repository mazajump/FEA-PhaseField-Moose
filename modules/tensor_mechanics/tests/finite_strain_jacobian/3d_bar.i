[Mesh]
  type = GeneratedMesh
  dim = 3
  xmin = 0
  xmax = 2
  ymin = 0
  ymax = 2
  zmin = 0
  zmax = 10
  nx = 10
  ny = 2
  nz = 2
  elem_type = HEX8
[]

[GlobalParams]
  displacements = 'disp_x disp_y disp_z'
[]

[MeshModifiers]
  [./corner]
    type = AddExtraNodeset
    new_boundary = 101
    coord = '0 0 0'
  [../]
  [./side]
    type = AddExtraNodeset
    new_boundary = 102
    coord = '2 0 0'
  [../]
[]

[Modules/TensorMechanics/Master]
  [./all]
    strain = FINITE
    add_variables = true
    use_finite_deform_jacobian = true
    volumetric_locking_correction = false
  [../]
[]

[Materials]
  [./stress]
    type = ComputeFiniteStrainElasticStress
  [../]
  [./elasticity_tensor]
    type = ComputeElasticityTensor
    fill_method = symmetric9
    C_ijkl = '1.684e5 1.214e5 1.214e5 1.684e5 1.214e5 1.684e5 0.754e5 0.754e5 0.754e5'
  [../]
[]

[BCs]
 [./fix_corner_x]
   type = PresetBC
   variable = disp_x
   boundary = 101
   value = 0
 [../]
 [./fix_corner_y]
   type = PresetBC
   variable = disp_y
   boundary = 101
   value = 0
 [../]
 [./fix_side_y]
   type = PresetBC
   variable = disp_y
   boundary = 102
   value = 0
 [../]
 [./fix_z]
   type = PresetBC
   variable = disp_z
   boundary = back
   value = 0
 [../]
 [./move_z]
   type = FunctionPresetBC
   variable = disp_z
   boundary = front
   function = 't'
 [../]
[]

[Executioner]
  type = Transient

  solve_type = NEWTON
  petsc_options_iname = '_pc_type'
  petsc_options_value = 'lu'

  nl_rel_tol = 1e-10
  nl_max_its = 10

  l_tol  = 1e-4
  l_max_its = 50

  dt = 0.2
  dtmin = 0.2

  num_steps = 2
[]

[Preconditioning]
  [./smp]
    type = SMP
    full = true
  [../]
[]

[Outputs]
  exodus = true
[]
