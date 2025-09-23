#! /usr/bin/env python
#
# This program computes the nondimensional input parameters for a turbulent fluid simulation.
#
# author: Kyle A. Damm
# date:   2025-07-10
#

if __name__=='__main__':

    # geometry
    R = 0.006                       # m       --> pipe radius
    Lref = 2*R                      # m       --> characteristic length of computational domain (e.g. pipe diameter or hydraulic diameter)
    print("Lref (m) = ", Lref)

    # water properties
    Uref = 0.75                     # m/s     --> velocity
    rho = 997.0                     # kg/m^3  --> density
    T = 350.0                       # K       --> temperature
    mu = 8.90e-4                    # Pa.s    --> dynamic viscosity
    Cp = 4186.0                     # J/kg/K  --> specific heat capacity
    k = 0.6                         # W/m/K   --> thermal conductivity
    alpha = k/(rho*Cp)              # m^2/s   --> thermal diffusivity

    # nondimensional quantities of interest
    Re = rho*Uref*Lref/mu           #       --> Reynolds number
    Pe = Lref*Uref/alpha            #       --> Peclet number
    print("Re = ", Re)
    print("Pe = ", Pe)

    # inlet turbulent properties approximated using approach described on pg. 77 of
    #   An Introduction to Computational Fluid Dynamics,
    #   Versteeg and Malalasekera,
    #   2E, Pearson Education India, 2007
    Ti = 0.05                        #       --> turbulence intensity
    tke = (3.0/2.0)*(Uref*Ti)**2     # J/kg  --> turbulent kinetic energy
    Lc = 0.07*Lref                   # m     --> turbulence length scale
    C_mu = 0.09                      #       --> k-epsilon turbulence model constant
    tau = Lc/(C_mu**0.75 * tke**0.5) # s     --> turbulence time scale
    tke_nd = tke/Uref**2             #       --> nondimensional k (as defined by https://nekrsdoc.readthedocs.io/en/latest/theory.html#the-k-tau-model)
    tau_nd = tau*Uref/Lref           #       --> nondimensional tau (as defined by https://nekrsdoc.readthedocs.io/en/latest/theory.html#the-k-tau-model)
    print("tke* = ", tke_nd)
    print("tau* = ", tau_nd)
