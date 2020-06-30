[Mesh]
  type = GeneratedMesh
  dim = 2
  nx = 60
  ny = 60
  xmin = 4.0
  xmax = 33.0
  ymin = 8.0
  ymax = 34.0
  elem_type = QUAD4
[]

[GlobalParams]
  displacements = 'disp_x disp_y'
  var_name_base = gr
  op_num = 2.0
  int_width = 1.0
[]

[Variables]
  [./c]
    #scaling = 10
  [../]
  [./w]
  [../]
  [./PolycrystalVariables]
  [../]
  [./disp_x]
    order = FIRST
    family = LAGRANGE
  [../]
  [./disp_y]
    order = FIRST
    family = LAGRANGE
  [../]
  [./temp]
    initial_condition = 400
  [../]
[]

[ICs]
#   [./ic_gr8]
#     int_width = 2.0
#     x1 = 28.9158
#     y1 = 18.2981
#     radius = 3.895
#     outvalue = 0.01
#     variable = gr8
#     invalue = 0.99
#     type = SmoothCircleIC
#   [../]
#   [./ic_gr7]
#     int_width = 2.0
#     x1 = 10.6328
#     y1 = 29.4843
#     radius = 3.75
#     outvalue = 0.01
#     variable = gr7
#     invalue = 0.99
#     type = SmoothCircleIC
#   [../]
#   [./ic_gr6]
#     int_width = 2.0
#     x1 = 21.7174
#     y1 = 15.3236
#     radius = 3.75
#     outvalue = 0.0
#     variable = gr6
#     invalue = 1.0
#     type = SmoothCircleIC
#   [../]
#   [./ic_gr5]
#     int_width = 2.0
#     x1 = 20.0109
#     y1 = 30.5594
#     radius = 4.32
#     outvalue = 0.01
#     variable = gr5
#     invalue = 0.99
#     type = SmoothCircleIC
#   [../]
#   [./ic_gr4]
#     int_width = 2.0
#     x1 = 27.8199
#     y1 = 28.1836
#     radius = 3.375
#     outvalue = 0.01
#     variable = gr4
#     invalue = 0.99
#     type = SmoothCircleIC
#   [../]
#   [./ic_gr3]
#     int_width = 2.0
#     x1 = 22.0109
#     y1 = 22.7441
#     radius = 3.375
#     outvalue = 0.0
#     variable = gr3
#     invalue = 1.0
#     type = SmoothCircleIC
#   [../]
# [./ic_g2]
#     int_width = 2.0
#     x1 = 13.5818
#     y1 = 17.6532
#     radius = 3.375
#     outvalue = 0.01
#     variable = gr2
#     invalue = 0.99
#     type = SmoothCircleIC
#   [../]
  [./ic_gr1]
    int_width = 2.0
    x1 = 12.592
    y1 = 22.4133
    radius = 6.25
    outvalue = 0.01
    variable = gr1
    invalue = 0.99
    type = SmoothCircleIC
  [../]
  [./ic_gr0]
    int_width = 2.0
    x1 = 24.6702
    y1 = 24.1294
    radius = 6.25
    outvalue = 0.01
    variable = gr0
    invalue = .99
    type = SmoothCircleIC
  [../]
  [./multip]
    # x_positions = '28.9158 10.6328	21.7174	20.0109	27.8199	22.9458	13.5818	8.592	15.6702'
    # y_positions = '18.2981 29.4843	15.3236	30.5594	28.1836	22.7441	17.6532	22.4133	24.1294'
    # z_positions = '0 0 0 0 0 0 0 0 0'
    # radii = '3.875	3.75	3.75	4.325	3.5	3.375	3.375	3.25	3.25'
    x_positions = '12.592	24.6702'
    y_positions = '22.4133	24.1294'
    z_positions = '0 0'
    radii = '6.25	8.25'
    int_width = 2.0
    3D_spheres = false
    outvalue = 0.01
    variable = c
    invalue = 0.99
    type = SpecifiedSmoothCircleIC
    block = 0
  [../]
[]

[AuxVariables]
  [./bnds]
  [../]
  [./total_en]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./unique_grains]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./var_indices]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./centroids]
    order = CONSTANT
    family = MONOMIAL
  [../]
    [./sigma11_aux]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./sigma22_aux]
    order = CONSTANT
    family = MONOMIAL
  [../]
[]

[Functions]
#   [./Dv]
#     type = ConstantFunction
#     value = 0.001
#   [../]
  [./load]
    type = ConstantFunction
    value = 0.01
  [../]
  # [./tempFunc]
  #   type = PiecewiseLinear
  #   x = '10       20'
  #   y = '400   700'
  # [../]
[]

[Kernels]
  # [./Diffusion]
  #   type = MatDiffusion
  #   variable = Dvol
  #   diffusivity = diffusivity
  # [../]
  [./heat]
    type = HeatConduction
    variable = temp
  [../]
  [./HeatSource]
    type = HeatSource
    # function = '1*sin(3.14159*x/20)*sin(3.14159*y/80)*sin(3.14159*z/20)'
    function = '10*exp(-((x-(31-2.7*t))^2/2))*exp(-abs(y-34)/1)'
    variable = temp
  [../]
  # [./HeatTdot]
  #   type = HeatConductionTimeDerivative
  #   variable = temp
  # [../]
  [./TensorMechanics]
    displacements = 'disp_x disp_y'
  [../]
  [./cres]
    type = SplitCHParsed
    variable = c
    kappa_name = kappa_c
    w = w
    f_name = F
    args = 'gr0 gr1'
  [../]
  [./wres]
    type = SplitCHWRes
    variable = w
    mob_name = D
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
    grain_force = grain_force
    grain_tracker_object = grain_center
    grain_volumes = grain_volumes
    translation_constant = 10.0
    rotation_constant = 1.0
  [../]
[]

[AuxKernels]
  [./bnds]
    type = BndsCalcAux
    variable = bnds
    v = 'gr0 gr1 '
  [../]
  [./Total_en]
    type = TotalFreeEnergy
    variable = total_en
    kappa_names = 'kappa_c kappa_op kappa_op '
    interfacial_vars = 'c  gr0 gr1 '
  [../]
  [./unique_grains]
    type = FeatureFloodCountAux
    variable = unique_grains
    flood_counter = grain_center
    field_display = UNIQUE_REGION
    execute_on = timestep_begin
  [../]
  [./var_indices]
    type = FeatureFloodCountAux
    variable = var_indices
    flood_counter = grain_center
    field_display = VARIABLE_COLORING
    execute_on = timestep_begin
  [../]
  [./centroids]
    type = FeatureFloodCountAux
    variable = centroids
    execute_on = timestep_begin
    field_display = CENTROID
    flood_counter = grain_center
  [../]
  [./matl_sigma11]
    type = RankTwoAux
    rank_two_tensor = stress
    index_i = 0
    index_j = 0
    variable = sigma11_aux
  [../]
  [./matl_sigma22]
    type = RankTwoAux
    rank_two_tensor = stress
    index_i = 1
    index_j = 1
    variable = sigma22_aux
  [../]
[]

[BCs]
# Boundary Condition block
  # [./Periodic]
  #   [./top_bottom]
  #     auto_direction = 'x ' # Makes problem periodic in the x and y directions
  #   [../]
  # [../]
  [./Periodic]
    [./left_right]
      auto_direction = 'x ' # Makes problem periodic in the x and y directions
    [../]
  [../]
  # [./left]
  #   type = DirichletBC
  #   variable = temp
  #   boundary = top
  #   value = 300
  # [../]
  [./bottom]
    type = DirichletBC
    variable = temp
    boundary = bottom
    value = 700
  [../]
  # [./temp]
  #   type = FunctionDirichletBC
  #   variable = temp
  #   boundary = 'top bottom'
  #   function = tempFunc
  # [../]
[]

[Materials]
#   [./chemical_free_energy]
#     type = SinteringFreeEnergy
#     block = 0
#     c = c
#     v = 'gr0 gr1 '
#     f_name = Fc
#     derivative_order = 2
#     #outputs = console
#   [../]
#   [./free_energy]
#     type = DerivativeParsedMaterial
#     f_name = F
#     args = 'c eta0 eta1'
#     constant_names = 'barr_height  cv_eq'
#     constant_expressions = '0.1          1.0e-2'
#     function = 16*barr_height*(c-cv_eq)^2*(1-cv_eq-c)^2+eta0*(1-eta0)*c+eta1*(1-eta1)*c
#     derivative_order = 2
#   [../]
#   
  [./chemical_free_energy]
    type = DerivativeParsedMaterial
    f_name = Fc
    args = 'c gr0 gr1'
    constant_names = 'A  B'
    constant_expressions = '16.0 1.0'
    function = A*c^2*(1-c)^2+B*(c^2+6*(1-c)*(gr0^2+gr1^2)-4*(2-c)*(gr0^3+gr1^3)+3*(gr0^2+gr1^2)^2)
    derivative_order = 2
  [../]
  # [./Dv]
  #   type = GenericConstantMaterial
  #   block = 0
  #   prop_names = '  Dv'
  #   prop_values = ' 0.01 '
  # [../]
#   [./Volumetricdiffusion]
#     type = ParsedMaterial
#     block = 0
#     f_name = Dv
#     args = 'temp'
#     function = 0.01+0.00001*temp
#   [../]
  [./CH_mat]
    type = PFDiffusionGrowthM3
    block = 0
    Dvol = 0.01
    rho = c
    T = temp
    v = 'gr0 gr1'
    outputs = console
  [../]
  [./constant_mat]
    type = GenericConstantMaterial
    block = 0
    prop_names = '  A    B   L    kappa_op kappa_c'
    prop_values = ' 16.0 1.0 1.0  0.5      1.0    '
  [../]
  [./elasticity_tensor]
    type = ComputeElasticityTensor
    block = 0
    # lambda, mu values
    C_ijkl = '7 7'
    # Stiffness tensor is created from lambda=7, mu=7 using symmetric_isotropic fill method
    fill_method = symmetric_isotropic
    # See RankFourTensor.h for details on fill methods
    # '15 15' results in a high stiffness (the elastic free energy will dominate)
    # '7 7' results in a low stiffness (the chemical free energy will dominate)
  [../]
  [./stress]
    type = ComputeLinearElasticStress
    block = 0
  [../]
    [./var_dependence]
    type = DerivativeParsedMaterial
    block = 0
    function = 0.2*c
    args = c
    f_name = var_dep
    enable_jit = true
    derivative_order = 2
  [../]
  # [./eigenstrain]
  #   type = ComputeVariableEigenstrain
  #   block = 0
  #   eigen_base = '1 1 1 0 0 0'
  #   prefactor = var_dep
  #   #outputs = exodus
  #   args = 'c'
  #   eigenstrain_name = eigenstrain
  # [../]
  [./strain]
    type = ComputeSmallStrain
    # block = 0
    displacements = 'disp_x disp_y'
    eigenstrain_names = eigenstrain
  [../]
  [./elastic_free_energy]
    type = ElasticEnergyMaterial
    f_name = Fe
    block = 0
    args = 'c'
    derivative_order = 2
  [../]
  # Sum up chemical and elastic contributions
  [./free_energy]
    type = DerivativeSumMaterial
    block = 0
    f_name = F
    sum_materials = 'Fc Fe'
    args = 'c'
    derivative_order = 2
  [../]
  [./thermal_strain]
    type = ComputeThermalExpansionEigenstrain
    block = 0
    # eigen_base = '1 1 1 0 0 0'
    # prefactor = var_dep
    temperature = temp
    # outputs = exodus
    # args = 'c'
    stress_free_temperature = 400
    thermal_expansion_coeff = 1e-8
    eigenstrain_name = eigenstrain
  [../]
  [./heat]
    type = HeatConductionMaterial
    block = 0
    specific_heat = 1.0
    thermal_conductivity = 1.0
  [../]
  [./poissons_ratio]
    type = PiecewiseLinearInterpolationMaterial
    x = '100 500'
    y = '0   0.25'
    property = poissons_ratio
    variable = temp
  [../]
  # [./density]
  #   type = Density
  #   density = 1.0
  #   disp_x = disp_x
  #   disp_y = disp_y
  #   # disp_z = disp_z
  # [../]
[]

[VectorPostprocessors]
  [./grain_volumes]
    type = FeatureVolumeVectorPostprocessor
    flood_counter = grain_center
    execute_on = 'initial timestep_begin'
  [../]
  # undersized solute (voidlike)
[]

[UserObjects]
  [./grain_center]
    type = GrainTracker
    outputs = none
    compute_var_to_feature_map = true
    execute_on = 'initial timestep_begin'
  [../]
[]

[Postprocessors]
  # [./temp]
  #   type = AverageNodalVariableValue
  #   variable = temp
  #   output = exodus
  # [../]
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
  [./el_free_en]
    type = ElementIntegralMaterialProperty
    mat_prop = Fe
  [../]
  [./ch_free_en]
    type = ElementIntegralMaterialProperty
    mat_prop = Fc
  [../]
  [./dofs]
    type = NumDOFs
    system = 'NL'
  [../]
  [./tstep]
    type = TimestepSize
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
#   [./grain_size_gr2]
#     type = ElementIntegralVariablePostprocessor
#     variable = gr2
#   [../]
  [./gb_area]
    type = GrainBoundaryArea
  [../]
[]

[Preconditioning]
  [./SMP]
    type = SMP
    coupled_groups = 'c,w c,gr0,gr1 '
  [../]
[]

[Executioner]
  # Preconditioned JFNK (default)
  type = Transient
  scheme = BDF2
  # solve_type = NEWTON
   solve_type = 'PJFNK'
 petsc_options_iname = '-pc_type -ksp_grmres_restart -sub_ksp_type -sub_pc_type -pc_asm_overlap'
  petsc_options_value = 'asm         31   preonly   lu      1'
  l_max_its = 15
  nl_max_its = 15
  nl_abs_tol = 1e-04
  nl_rel_tol = 1e-04
  l_tol = 1e-04
  end_time = 10
  #dt = 0.01
  [./TimeStepper]
    type = IterationAdaptiveDT
    dt = 0.05
    growth_factor = 1.15
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
      upper_bound = 0.99
      variable = bnds
    [../]
  [../]
[]

[Outputs]
  print_linear_residuals = true
  csv = true
  # exodus = true
  gnuplot = true
  print_perf_log = true
  [./console]
    type = Console
    perf_log = true
  [../]
  [./exodus]
    type = Exodus
    elemental_as_nodal = true
  [../]
[]

[Debug]
  show_var_residual_norms = true
[]