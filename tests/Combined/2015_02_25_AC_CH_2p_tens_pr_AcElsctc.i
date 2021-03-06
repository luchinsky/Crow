[GlobalParams]
  var_name_base = gr
  op_num = 2
[]

[Mesh]
  type = GeneratedMesh
  dim = 2
  nx = 200
  ny = 120
  xmax = 100
  ymax = 60
[]

[Variables]
  [./c]
    order = THIRD
    family = HERMITE
    block = 0
  [../]
  [./PolycrystalVariables]
  [../]
  [./disp_x]
    block = 0
  [../]
  [./disp_y]
    block = 0
  [../]
[]

[AuxVariables]
  [./bnds]
    block = 0
  [../]
[]

[Functions]
  [./Load]
    type = PiecewiseLinear
    y = '0.0 0.0 65e-6 65e-6 0.0'
    x = '0 3 10 20 30'
  [../]
[]

[Kernels]
  [./CHBulk]
    type = CHChemPotential
    variable = c
    mob_name = D
    block = 0
  [../]
  [./Cdot]
    type = TimeDerivative
    variable = c
    block = 0
  [../]
  [./ChInt]
    type = CHInterface
    variable = c
    mob_name = D
    kappa_name = kappa_c
    grad_mob_name = grad_D
    block = 0
  [../]
  [./PolycrystalSinteringKernel]
  [../]
  [./TensorMechanics]
    disp_y = disp_y
    disp_x = disp_x
  [../]
  [./Elstc_en]
    type = CHParsed
    variable = c
    mob_name = D
    f_name = F
    args = 'c gr0 gr1'
  [../]
  [./ElstcEn_gr0]
    type = ACParsed
    variable = 'gr0 '
    f_name = F
    args = 'c gr0 gr1'
    block = 0
  [../]
  [./elstcEn_gr1]
    type = ACParsed
    variable = gr1
    f_name = F
    args = 'c gr0 gr1'
    block = 0
  [../]
[]

[AuxKernels]
  [./bnds_aux]
    type = BndsCalcAux
    variable = bnds
    block = 0
  [../]
[]

[BCs]
  [./Periodic]
    [./Periodic_c]
      variable = 'c gr0 gr1'
      auto_direction = 'x y'
    [../]
  [../]
  [./BC_x]
    type = PresetBC
    variable = disp_x
    boundary = bottom
    value = 0.0
  [../]
  [./BC_y]
    type = PresetBC
    variable = disp_y
    boundary = bottom
    value = 0.0
  [../]
  [./Pressure]
    [./top]
      function = Load
      boundary = top
      disp_y = disp_y
      disp_x = disp_x
    [../]
  [../]
[]

[Materials]
  active = 'AC_mat PFGrowth Eigen_strn elastc_energy'
  [./PFDiff]
    type = PFDiffusion
    block = 0
    rho = c
    kappa = 10
  [../]
  [./AC_mat]
    type = GenericConstantMaterial
    block = 0
    prop_names = 'L kappa_op'
    prop_values = '10.0 1.0'
  [../]
  [./PFGrowth]
    type = PFDiffusionGrowth
    block = 0
    kappa = 10
    rho = c
    v = 'gr0 gr1'
  [../]
  [./elastc_energy]
    type = ElasticEnergyMaterial
    block = 0
    outputs = console
    args = c
  [../]
  [./Eigen_strn]
    type = PFEigenStrainMaterial1
    block = 0
    c = c
    disp_y = disp_y
    disp_x = disp_x
    epsilon0 = 0.05
    C_ijkl = '487.33e-3 180.25e-3 180.25e-3 180.25e-3 487.33e-3  180.25e-3 180.25e-3 180.25e-3 487.33e-3 307.09e-3 307.09e-3 307.09e-3'
    v = 'gr0 gr1 '
    e_v = 0.01
  [../]
[]

[Postprocessors]
  [./Elem_Avg]
    type = ElementIntegralVariablePostprocessor
    variable = c
    block = 0
  [../]
  [./Side_Int_var]
    type = SideIntegralVariablePostprocessor
    variable = c
    boundary = top
  [../]
  [./density_elem]
    type = ElementAverageValue
    variable = c
    block = 0
  [../]
  [./no. of grain]
    type = NodalFloodCount
    variable = bnds
  [../]
  [./load]
    type = PlotFunction
    function = Load
  [../]
  [./Nodal_volume]
    type = NodalVolumeFraction
    variable = c
    threshold = 0.7
    mesh_volume = Volume
  [../]
  [./Volume]
    type = VolumePostprocessor
    block = 0
  [../]
[]

[Executioner]
  type = Transient
  dt = 0.5
  l_max_its = 30
  solve_type = NEWTON
  petsc_options_iname = '-pc_type -ksp_grmres_restart -sub_ksp_type -sub_pc_type -pc_asm_overlap'
  petsc_options_value = 'asm         31   preonly   lu      1'
  nl_abs_tol = 1e-9
  end_time = 30
  l_tol = 1e-04
  scheme = bdf2
[]

[Outputs]
  exodus = true
  output_final = true
  tecplot = true
  output_on = 'timestep_end initial'
  [./console]
    type = Console
    perf_log = true
    output_initial = true
    output_file = true
  [../]
[]

[ICs]
  [./2pdens]
    max = 0.01
    radius = '20.0 20.0'
    variable = c
    type = TwoParticleDensityIC
    block = 0
  [../]
  [./PolycrystalICs]
    [./TwoParticleGrainsIC]
    [../]
  [../]
[]

