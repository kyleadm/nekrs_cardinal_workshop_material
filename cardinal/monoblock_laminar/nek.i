[Mesh]
  type = NekRSMesh
  # This is the nekRS boundary we are coupling via conjugate heat transfer to MOOSE
  boundary = '3'
  #order = SECOND
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
  time_step_interval = 100
[]

[Postprocessors]
  [max_nek_T]
    type = NekVolumeExtremeValue
    field = temperature
    value_type = max
  []
  [min_nek_T]
    type = NekVolumeExtremeValue
    field = temperature
    value_type = min
  []
[]
