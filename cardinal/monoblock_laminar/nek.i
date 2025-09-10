# reference values
u   = 7.5e-03    # m/s
T   = 350.0      # K
mu  = 8.9e-4     # Pa.s 
L   = 0.012      # m
rho = 997.0      # kg/m^3
Cp  = 4186.0     # J/kg/K
k   = 0.6        # W/m/K

[Mesh]
  type = NekRSMesh
  # This is the nekRS boundary we are coupling via conjugate heat transfer to MOOSE
  boundary = '3'
  order = SECOND
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

[Outputs]
  exodus = true
  hide = 'heat_flux_integral'
  #time_step_interval = 100
[]
