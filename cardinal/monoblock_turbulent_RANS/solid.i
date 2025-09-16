# Initial and boundary condition parameters
solid_initial_temp = 500 # [K]
fluid_initial_temp = 350 # [K]

# Material properties
armour_thermal_conductivity = 170.0   # Tungsten [W.m^-1.K^-1]
armour_specific_heat = 134            # Tungsten [J.kg^-1.K^-1]
armour_density = 19300                # Tungsten [kg.m^-3]
pipe_thermal_conductivity = 400.0     # Copper [W.m^-1.K^-1]
pipe_specific_heat = 385              # Copper [J.kg^-1.K^-1]
pipe_density = 8940                   # Copper [kg.m^-3]

# -----------------------------------------------------

[Mesh]
  [solid_mesh]
    type = FileMeshGenerator
    file = './mesh/solid.exo'
  []
  [scaled]
    type = TransformGenerator
    input = solid_mesh
    transform = SCALE
    vector_value ='0.012 0.012 0.012'
  []
[]

[Variables]
  [temp]
    initial_condition = ${solid_initial_temp}
  []
[]

[Kernels]
  [diffusion]
    type = HeatConduction
    variable = temp
  []
  #[heat_time_derivative]  # heat time derivative
  #  type = SpecificHeatConductionTimeDerivative
  #  variable = temp
  #[]
[]

[BCs]
  [insulated]
    type = NeumannBC
    variable = temp
    value = 0.0
    boundary = '1 3'
  []
  [fixed_inlet]
    type = DirichletBC
    variable = temp
    value = 350.0
    boundary = '5'
  []
  [fluid_solid_interface]
    type = CoupledConvectiveHeatFluxBC
    variable = temp
    boundary = '2'
    T_infinity = nek_bulk_temp
    htc = h 
  []
  [hot_top_surface]
    type = DirichletBC
    variable = temp
    boundary = 4
    value = 700
  []
[]

[Materials]
  [armour]
    type = HeatConductionMaterial
    thermal_conductivity = '${armour_thermal_conductivity}'
    specific_heat = '${armour_specific_heat}' # heat time derivative
    temp = temp
    block = 1
  []
  [pipe]
    type = HeatConductionMaterial
    thermal_conductivity = '${pipe_thermal_conductivity}'
    specific_heat = '${pipe_specific_heat}' # heat time derivative
    temp = temp
    block = 2
  []
  [armour_density_material] # heat time derivative
    type = GenericConstantMaterial
    block = 1
    prop_names = density
    prop_values = '${armour_density}'
  []
  [pipe_density_material] # heat time derivative
    type = GenericConstantMaterial
    block = 2
    prop_names = density
    prop_values = '${pipe_density}'
  []

[]

[MultiApps]
  [nek]
    type = TransientMultiApp
    input_files = 'nek.i'
    sub_cycling = true
    execute_on = timestep_begin
  []
[]

[AuxVariables]
  [nek_bulk_temp]
  []
  [h]
  []
  [nek_flux]
  []
[]

[AuxKernels]
  [h]
    type = ParsedAux
    variable = h
    expression = '-nek_flux/(temp - nek_bulk_temp)'
    coupled_variables = 'nek_flux nek_bulk_temp temp'
    boundary = '2'
    execute_on = timestep_begin
  []
[]

[Postprocessors]
  [flux_integral]
    type = SideIntegralVariablePostprocessor
    variable = nek_flux
    boundary = '2'
    execute_on = transfer
  []
  [synchronize]
    type = Receiver
    default = 1
  []
[]

[AuxVariables]
  [nek_flux]
  []
[]

[Transfers]
  [flux] # grabs the Nek flux and stores it in nek_flux
    type = MultiAppGeneralFieldNearestLocationTransfer
    source_variable = heat_flux
    from_multi_app = nek
    variable = nek_flux
    search_value_conflicts = false
    source_boundary = '2'
    from_postprocessors_to_preserved = heat_flux_integral
    to_postprocessors_to_be_preserved = flux_integral
  []
  [nek_bulk_temp] # grabs the Nek Tinf and stores it in nek_bulk_temp
    type = MultiAppGeneralFieldUserObjectTransfer
    source_user_object = bulk_temp
    from_multi_app = nek
    variable = nek_bulk_temp
    error_on_miss = false
  []
  [temp] # grabs the MOOSE temperature to send to Nek
    type = MultiAppGeneralFieldNearestLocationTransfer
    source_variable = temp
    to_multi_app = nek
    variable = temperature
    source_boundary = '2'
    search_value_conflicts = false
  []
  [synchronize_in]
    type = MultiAppPostprocessorTransfer
    to_postprocessor = transfer_in
    from_postprocessor = synchronize
    to_multi_app = nek
  []
[]

[Executioner]
  type = Transient

  dt = 0.1
  end_time = 160.0

  nl_abs_tol = 1e-6
  nl_rel_tol = 1e-6
  petsc_options_value = 'hypre boomeramg'
  petsc_options_iname = '-pc_type -pc_hypre_type'

  steady_state_detection = true
  steady_state_tolerance = 1e-4

  verbose = true
[]

[Outputs]
  json = true
  exodus = true
  hide = 'flux_integral synchronize'
  execute_on = 'timestep_end failed'
  [checkpoint]
    file_base = 'cardinal_sub_checkpoint'
    type = Checkpoint
    num_files = 5
    time_step_interval = 1
  []
[]
