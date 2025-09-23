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
    Lref = 2*R                      # m       --> characteristic length of computational domain (e.g. pipe diameter or hydrualic diameter)
    print("Lref (m) = ", Lref)

    # water properties
    Uref = 7.5e-03                  # m/s     --> velocity
    rho = 997.0                     # kg/m^3  --> density
    T = 350.0                       # K       --> temperature
    mu = 8.90e-4                    # Pa.s    --> dynamic viscosity
    Cp = 4186.0                     # J/kg/K  --> specific heat capacity
    k = 0.6                         # W/m/K   --> thermal conductivity
    alpha = k/(rho*Cp)              # m^2/s   --> thermal diffusivity
    
    # nondimensional quantities of interest
    Re = rho*Uref*Lref/mu           #         --> Reynolds number
    Pe = Lref*Uref/alpha            #         --> Peclet number
    print("Re = ", Re)
    print("Pe = ", Pe)
