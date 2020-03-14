[GlobalParams]
  var_name_base = gr
  op_num = 4.0
  displacements = 'disp_x disp_y'
  #en_ratio = 1
[]

[Mesh]
  type = GeneratedMesh
  dim = 2
  nx = 40
  ny = 40
  nz = 0
  xmin = 0.0
  xmax = 400.0
  ymin = 0.0
  ymax = 400.0
  zmax = 0
  #uniform_refine = 1
  elem_type = QUAD4
[]

[Variables]
  [./c]
    #scaling = 10
  [../]
  [./w]
    #scaling = 10
  [../]
  [./PolycrystalVariables]
  [../]
  [./disp_x]
  [../]
  [./disp_y]
  [../]
[]

[AuxVariables]
  [./bnds]
  [../]
  [./total_en]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./S11]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./S22]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./E_11]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./E_22]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./S_von]
    order = CONSTANT
    family = MONOMIAL
  [../]
[]

[Functions]
  [./load]
    type = PiecewiseLinear
    y = '0.0 -1.0 -5.0 -10.0 -10.0'
    x = '0.0 20.0 100.0 500.0 1000.0'
  [../]
[]

[Kernels]
  [./cres]
    type = SplitCHParsed
    variable = c
    kappa_name = kappa_c
    w = w
    f_name = F
    args = 'gr0 gr1 gr2 gr3'
  [../]
  [./wres]
    type = SplitCHWRes
    variable = w
    mob_name = M
  [../]
  [./time]
    type = CoupledTimeDerivative
    variable = w
    v = c
  [../]
  [./PolycrystalSinteringKernel]
    c = c
    consider_rigidbodymotion = false
    anisotropic = false
    #grain_force = grain_force
    #grain_tracker_object = grain_center
    #grain_volumes = grain_volumes
    #translation_constant = 10.0
    #rotation_constant = 1.0
  [../]
  [./ElstcEn_gr0]
    type = AllenCahn
    variable = gr0
    args = 'c gr1 gr2 gr3'
    f_name = E
  [../]
  [./ElstcEn_gr1]
    type = AllenCahn
    variable = gr1
    args = 'c gr0 gr2 gr3 '
    f_name = E
  [../]
  [./ElstcEn_gr2]
    type = AllenCahn
    variable = gr2
    args = 'c gr0 gr1 gr3'
    f_name = E
  [../]
  [./ElstcEn_gr3]
    type = AllenCahn
    variable = gr3
    args = 'c gr0 gr1 gr2 '
    f_name = E
  [../]
  [./TensorMechanics]
    displacements = 'disp_x disp_y'
    use_displaced_mesh = true
  [../]
[]

[AuxKernels]
  [./bnds]
    type = BndsCalcAux
    variable = bnds
    v = 'gr0 gr1 gr2 gr3'
  [../]
  [./Total_en]
    type = TotalFreeEnergy
    variable = total_en
    kappa_names = 'kappa_c kappa_op kappa_op kappa_op kappa_op'
    interfacial_vars = 'c  gr0 gr1 gr2 gr3'
  [../]
  [./S11]
    type = RankTwoAux
    variable = S11
    rank_two_tensor = stress
    index_j = 0
    index_i = 0
    block = 0
  [../]
  [./S22]
    type = RankTwoAux
    variable = S22
    rank_two_tensor = stress
    index_j = 1
    index_i = 1
    block = 0
  [../]
  [./E_11]
    type = RankTwoAux
    variable = E_11
    rank_two_tensor = mechanical_strain
    index_j = 0
    index_i = 0
    block = 0
  [../]
  [./E_22]
    type = RankTwoAux
    variable = E_22
    rank_two_tensor = mechanical_strain
    index_j = 1
    index_i = 1
    block = 0
  [../]
  [./S_von]
    type = RankTwoScalarAux
    variable = S_von
    rank_two_tensor = stress
    scalar_type = VonMisesStress
  [../]
[]

[BCs]
  [./flux]
    type = CahnHilliardFluxBC
    variable = w
    boundary = 'top bottom left right'
    flux = '0 0 0'
    mob_name = M
    args = 'c'
  [../]
  [./bottom_y]
    type = PresetBC
    variable = disp_y
    boundary = bottom
    value = 0
  [../]
  [./left_x]
    type = PresetBC
    variable = disp_x
    boundary = left
    value = 0
  [../]
  [./right_x]
    type = PresetBC
    variable = disp_x
    boundary = right
    value = 0
  [../]
  [./top_y]
    type = FunctionPresetBC
    variable = disp_y
    boundary = top
    function = load
  [../]
[]

[Materials]
  [./free_energy]
    type = SinteringFreeEnergy
    block = 0
    c = c
    v = 'gr0 gr1 gr2 gr3'
    f_name = S
    derivative_order = 2
    outputs = exodus
    output_properties = 'S'
  [../]
  [./coeff]
    type = SinteringCoefficients
    block = 0
    T = 800.0
    int_width = 20
    GBmob0 = 2.5e-6
    Qgbm = 0.23
    surface_energy = 1.03e19
    GB_energy = 4.42e18
    length_scale = 1e-08
    time_scale = 0.1
    energy_scale = 100.0
    energy_unit = eV
    outputs = exodus
  [../]
  [./mob]
    type = SinteringMobility
    T = 800.0
    int_width = 20
    Qv = 2.19
    Qvc = 2.19
    Qgb = 0.75
    Qs = 0.9
    Dgb0 = 1.95e-8
    Dsurf0 = 2.6e-5
    Dvap0 = 7.8e-5
    Dvol0 = 7.8e-5
    c = c
    v = 'gr0 gr1 gr2 gr3'
    Vm = 1.182e-29
    length_scale = 1e-08
    time_scale = 0.1
    bulkindex = 1.0
    surfindex = 1.0
    gbindex = 1.0
    prefactor = 1.0
    outputs = exodus
  [../]

  [./elasticity_tensor_phase1]
    type = ComputePolycrystalElasticityTensor
    base_name = phase1
    block = 0
    grain_tracker = grain_tracker
    length_scale = 1e-08
    pressure_scale = 1.0
  [../]
  #elastic properties for phase with c = 0
  [./elasticity_tensor_phase0]
    type = ComputeElasticityTensor
    base_name = phase0
    block = 0
    fill_method = symmetric_isotropic
    C_ijkl = '20.0 20.0'
  [../]
  #switching function for elastic energy calculation
  [./switching_phase1]
    type = SwitchingFunctionMaterial
    block = 0
    function_name = h1
    eta = c
    h_order = SIMPLE
  [../]
  [./switching_phase0]
    type = DerivativeParsedMaterial
    block = 0
    f_name = h0
    material_property_names = 'h1'
    function = (1-h1)
    args = c
  [../]
  [./elasticity_tensor]
    type = CompositeElasticityTensor
    block = 0
    args = 'c gr0 gr1 gr2 gr3'
    tensors = 'phase0   phase1'
    weights = 'h0       h1'
  [../]

  #[./smallstrain]
  #  type = ComputeSmallStrain
  #  block = 0
  #  displacements = 'disp_x disp_y'
  #[../]
  #[./stress]
  #  type = ComputeLinearElasticStress
  #  block = 0
  #[../]
  [./smallstrain]
    type = ComputeFiniteStrain
    block = 0
    displacements = 'disp_x disp_y'
  [../]
  [./stress]
    type = ComputeFiniteStrainElasticStress
    block = 0
  [../]
  [./elstc_en]
    type = ElasticEnergyMaterial
    f_name = E
    block = 0
    args = 'c gr0 gr1 gr2 gr3'
    derivative_order = 2
    outputs = exodus
    output_properties = 'E'
  [../]

  # total energy
  [./sum]
    type = DerivativeSumMaterial
    block = 0
    sum_materials = 'S E'
    args = 'c gr0 gr1 gr2 gr3'
    derivative_order = 2
    outputs = exodus
    output_properties = 'F'
  [../]
[]

[UserObjects]
  [./euler_angle_file]
    type = EulerAngleFileReader
    file_name = grn_100_rand.tex
  [../]
  [./grain_tracker]
    type = GrainTrackerElasticity
    threshold = 0.1
    #convex_hull_buffer = 5.0
    use_single_map = false
    enable_var_coloring = true
    condense_map_info = true
    connecting_threshold = 0.05
    #compute_op_maps = true
    execute_on = 'initial timestep_begin'
    flood_entity_type = elemental
    C_ijkl = '5936.14 3258.32 3258.32 5936.14 3258.32 5936.14 3508.00 3508.00 3508.00'
    fill_method = symmetric9
    euler_angle_provider = euler_angle_file
    compute_var_to_feature_map = true
  [../]
[]


[Postprocessors]
  [./elem_c]
    type = ElementIntegralVariablePostprocessor
    variable = c
  [../]
  [./elem_bnds]
    type = ElementIntegralVariablePostprocessor
    variable = bnds
  [../]
  [./total_energy]
    type = ElementIntegralVariablePostprocessor
    variable = total_en
  [../]
  [./free_en]
    type = ElementIntegralMaterialProperty
    mat_prop = F
  [../]
  [./chem_free_en]
    type = ElementIntegralMaterialProperty
    mat_prop = S
  [../]
  [./elstc_en]
    type = ElementIntegralMaterialProperty
    mat_prop = E
  [../]
  [./dofs]
    type = NumDOFs
    system = NL
  [../]
  [./tstep]
    type = TimestepSize
  [../]
  [./s11]
    type = ElementIntegralVariablePostprocessor
    variable = S11
  [../]
  [./s22]
    type = ElementIntegralVariablePostprocessor
    variable = S22
  [../]
  [./int_area]
    type = InterfaceAreaPostprocessor
    variable = c
  [../]
  [./grain_size_gr0]
    type = ElementIntegralVariablePostprocessor
    variable = gr0
  [../]
  [./grain_size_gr1]
    type = ElementIntegralVariablePostprocessor
    variable = gr1
  [../]
  [./gb_area]
    type = GrainBoundaryArea
  [../]
  [./neck]
    type = NeckAreaPostprocessor
  [../]
[]

[Preconditioning]
  [./SMP]
    type = SMP
    coupled_groups = 'c,w c,gr0,gr1,gr2,gr3 disp_x,disp_y'
  [../]
[]

[Executioner]
  # Preconditioned JFNK (default)
  type = Transient
  scheme = BDF2
  solve_type = PJFNK
  petsc_options_iname = '-pc_type -ksp_grmres_restart -sub_ksp_type -sub_pc_type -pc_asm_overlap -sub_pc_factor_shift_type'
  petsc_options_value = 'asm         31   preonly   lu      1 nonzero'
  petsc_options = '-snes_converged_reason'
  l_max_its = 20
  nl_max_its = 20
  nl_abs_tol = 1e-10
  nl_rel_tol = 1e-08
  l_tol = 1e-04
  end_time = 1000
  #dt = 0.01
  [./TimeStepper]
    type = IterationAdaptiveDT
    dt = 0.01
    growth_factor = 1.2
  [../]
[]

[Adaptivity]
  marker = bound_adapt
  max_h_level = 2
  [./Indicators]
    [./error]
      type = GradientJumpIndicator
      variable = bnds
    [../]
  [../]
  [./Markers]
    [./bound_adapt]
      type = ValueRangeMarker
      lower_bound = 0.01
      upper_bound = 0.93
      variable = bnds
      #third_state = COARSEN
    [../]
  [../]
[]

[Outputs]
  print_linear_residuals = true
  csv = true
  gnuplot = true
  print_perf_log = true
  #file_base = 2017_08_25_4p_cu_T800_adap_check
  [./console]
    type = Console
    perf_log = true
  [../]
  [./exodus]
    type = Exodus
    elemental_as_nodal = true
  [../]
[]

[ICs]
  [./ic_gr1]
    type = SmoothCircleIC
    int_width = 20.0
    x1 = 300.0
    y1 = 120.0
    radius = 60.0
    outvalue = 0.0
    variable = gr1
    invalue = 1.0
  [../]
  [./multip]
    type = SpecifiedSmoothCircleIC
    x_positions = '150.0 300.0 100.0 250.0'
    int_width = 20.0
    z_positions = '0 0'
    y_positions = '125.0 120.0 270.0 270.0 '
    radii = '80.0 60.0 60.0 90.0'
    3D_spheres = false
    outvalue = 0.001
    variable = c
    invalue = 0.999
    block = 0
  [../]
  [./ic_gr0]
    type = SmoothCircleIC
    int_width = 20.0
    x1 = 150.0
    y1 = 125.0
    radius = 80.0
    outvalue = 0.0
    variable = gr0
    invalue = 1.0
  [../]
  [./ic_gr2]
    type = SmoothCircleIC
    int_width = 20.0
    x1 = 100.0
    y1 = 270.0
    radius = 60.0
    outvalue = 0.0
    variable = gr2
    invalue = 1.0
  [../]
  [./ic_gr3]
    type = SmoothCircleIC
    int_width = 20.0
    x1 = 250.0
    y1 = 270.0
    radius = 90.0
    outvalue = 0.0
    variable = gr3
    invalue = 1.0
  [../]
[]

[Debug]
  show_var_residual_norms = true
[]