# -----------------------------------------------------
# define some easy to access parameters here...

# Mesh scale
L = 0.012 # [m]

# Temporal integration parameters
dt = 0.001       # [s]
end_time = 160.0 # [s]

# Initial condition parameters
solid_initial_temp = 500 # [K]

# Material properties (tungsten armour and copper pipe)
armour_thermal_conductivity = 170.0   # [W.m^-1.K^-1]
armour_specific_heat        = 134.0   # [J.kg^-1.K^-1]
armour_density              = 19300.0 # [kg.m^-3]
pipe_thermal_conductivity   = 400.0   # [W.m^-1.K^-1]
pipe_specific_heat          = 385.0   # [J.kg^-1.K^-1]
pipe_density                = 8940.0  # [kg.m^-3]

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
    vector_value ='${L} ${L} ${L}'
  []
[]

[Problem]
  type = FEProblem
  # restart from LATEST time
  restart_file_base = ../monoblock_turbulent_RANS/cardinal_sub_checkpoint_cp/LATEST
  allow_initial_conditions_with_restart = true
[]

[Variables]
  [temp]
    #initial_condition = ${solid_initial_temp}
  []
[]

[Kernels]
  [diffusion]
    type = HeatConduction
    variable = temp
  []
  [heat_time_derivative]
    type = SpecificHeatConductionTimeDerivative
    variable = temp
  []
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
    value = 350.0 # [K]
    boundary = '5'
  []
  [fluid_solid_interface]
    type = CoupledVarNeumannBC
    variable = temp
    v = nek_flux
    boundary = 2
  []
  [hot_top_surface]
    type = DirichletBC
    variable = temp
    boundary = 4
    value = 700 # [K]
  []
[]

[Materials]
  [armour]
    type = HeatConductionMaterial
    thermal_conductivity = '${armour_thermal_conductivity}'
    specific_heat = '${armour_specific_heat}'
    temp = temp
    block = 1
  []
  [pipe]
    type = HeatConductionMaterial
    thermal_conductivity = '${pipe_thermal_conductivity}'
    specific_heat = '${pipe_specific_heat}'
    temp = temp
    block = 2
  []
  [armour_density_material]
    type = GenericConstantMaterial
    block = 1
    prop_names = density
    prop_values = '${armour_density}'
  []
  [pipe_density_material]
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
  [nek_flux]
  []
[]

[Postprocessors]
  [flux_integral]
    type = SideIntegralVariablePostprocessor
    variable = nek_flux
    boundary = '2'
    execute_on = transfer
  []
  [synchronize]  # For avoiding unnecessary synchronisations
     type = Receiver
     default = 1
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
  # force start time to zero, same as nek restarted time
  # start_time = 0.0

  type = Transient

  dt = ${dt}
  end_time = ${end_time}

  nl_abs_tol = 1e-6
  nl_rel_tol = 1e-6
  petsc_options_value = 'hypre boomeramg'
  petsc_options_iname = '-pc_type -pc_hypre_type'

  steady_state_detection = false
  steady_state_tolerance = 1e-6

  verbose = true
[]

[Outputs]
  json = true
  exodus = true
  hide = 'flux_integral synchronize'
  execute_on = 'timestep_end failed'
  #time_step_interval = 100
[]
