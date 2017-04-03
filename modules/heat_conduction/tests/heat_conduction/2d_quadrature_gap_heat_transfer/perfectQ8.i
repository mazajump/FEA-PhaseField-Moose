[GlobalParams]
  order = SECOND
[]

[Mesh]
  file = perfectQ8.e
[]

[Variables]
  [./temp]
  [../]
[]

[Kernels]
  [./hc]
    type = HeatConduction
    variable = temp
  [../]
[]

[BCs]
  [./left]
    type = DirichletBC
    variable = temp
    boundary = leftleft
    value = 300
  [../]
  [./right]
    type = DirichletBC
    variable = temp
    boundary = rightright
    value = 400
  [../]
[]

[ThermalContact]
  [./left_to_right]
    slave = leftright
    quadrature = true
    master = rightleft
    variable = temp
    type = GapHeatTransfer
  [../]
[]

[Materials]
  [./hcm]
    type = HeatConductionMaterial
    block = 'left right'
    specific_heat = 1
    thermal_conductivity = 1
  [../]
[]

[Executioner]
  type = Steady
  solve_type = 'PJFNK'

  [./Quadrature]
    order = THIRD
  [../]
[]

[Outputs]
  exodus = true
[]
