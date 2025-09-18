# fluid reference values
L   = 0.012      # m
u   = 7.5e-01    # m/s
T   = 350.0      # K
rho = 997.0      # kg/m^3
Cp  = 4186.0     # J/kg/K
k   = 0.6        # W/m/K
mu  = 8.9e-4     # Pa.s

[Mesh]
  type = NekRSMesh
  # This is the nekRS boundary we are coupling via conjugate heat transfer to MOOSE
  boundary = '3'
  order = SECOND # see https://cardinal.cels.anl.gov/source/mesh/NekRSMesh.html#vb
  scaling = ${L}
[]

[Problem]
  type = NekRSProblem
  casename = 'monoblock'
  n_usrwrk_slots = 2
  synchronization_interval = parent_app

  [FieldTransfers]
    [heat_flux]
      type = NekBoundaryFlux
      direction = from_nek
    []
    [temperature]
      type = NekFieldVariable
      direction = to_nek
      usrwrk_slot = 1
    []
  []

  [Dimensionalize]
    L  = ${L}
    U  = ${u}
    T  = ${T}
    dT = 1.0
    rho  = ${rho}
    Cp   = ${Cp}
  []
[]

[Executioner]
  type = Transient

  [TimeStepper]
    type = NekTimeStepper
  []
[]

[UserObjects]
  [x_bin]
   type = LayeredBin
   direction = x
   num_layers = 10
  []
  [y_bin]
   type = LayeredBin
   direction = y
   num_layers = 10
  []
  [z_bin]
   type = LayeredBin
   direction = z
   num_layers = 10
  []
  [bulk_temp]
   type = NekBinnedVolumeAverage
   bins = 'x_bin z_bin y_bin'
   field = temperature
   map_space_by_qp = true
   interval = 1
   check_zero_contributions = false
  []
[]

[Outputs]
  exodus = true
  hide = 'heat_flux_integral'
  #time_step_interval = 100
[]
