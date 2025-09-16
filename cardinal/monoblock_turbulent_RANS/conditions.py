#! /usr/bin/env python
#
# This program computes the turbulence model inlet boundary conditions.
#
# author: Kyle A. Damm
# date:   2025-07-10
#

import numpy as np


if __name__=='__main__':

    # geometry
    w = 0.0015                      # m       --> hypervapotron slot width
    h = 0.004                       # m       --> hypervapotron slot height
    W = 0.048                       # m       --> hypervapotron water channel width
    H = 0.008                       # m       --> hypervapotron water channel height
    A = W*H + 2*w*h                 # m^2     --> inlet area
    P = 2*H + 2*W + 4*h             # m       --> inlet perimeter
    Dh = 4*A/P                      # m       --> hydraulic diameter
    Lref = 0.006                    # m       --> characteristic length of computational domain (e.g. length of hypervapotron repeating unit)
    print("A (m**2) = ", A)
    print("P (m) = ", P)
    print("Dh (m) = ", Dh)

    # water properties
    Uref = 4.0                      # m/s     --> inlet velocity
    rho = 1000.0                    # kg/m^3  --> density
    T = 323.15                      # K       --> temperature (assuming 50 degrees Celcius inlet temperature as done by Milnes)
    mu = 0.0005474                  # Pa.s    --> dynamic viscosity
    Cp = 4186.0                     # J/kg/K  --> specific heat capacity
    k = 0.6406                      # W/m/K   --> thermal conductivity
    alpha = k/(rho*Cp)              # m^2/s   --> thermal diffusivity
    
    # nondimensional quantities of interest
    Re = rho*Uref*Lref/mu           #         --> Reynolds number
    Pe = Lref*Uref/alpha            #         --> Peclet number
    print("Re = ", Re)
    print("Pe = ", Pe)

    # inlet turbulent properties
    Ti = 0.05                       #         --> turbulence intensity (assumed to be 5% same as Milnes)
    k = (3.0/2.0)*(Uref*Ti)**2      # J/kg    --> turbulent kinetic energy
    Lc = 0.07*Dh                    # m       --> turbulence length scale
    C_mu = 0.09                     #         --> k-epsilon turbulence model constant
    tau = Lc/(C_mu**0.75 * k**0.5)  # s       --> turbulence time scale
    k_nd = k/Uref**2                #         --> nondimensional k (as defined by https://nekrsdoc.readthedocs.io/en/latest/theory.html#the-k-tau-model)
    tau_nd = tau*Uref/Lref          #         --> nondimensional tau (as defined by https://nekrsdoc.readthedocs.io/en/latest/theory.html#the-k-tau-model)
    print("k* = ", k_nd)
    print("tau* = ", tau_nd)
