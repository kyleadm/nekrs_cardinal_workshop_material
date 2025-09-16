#! /usr/bin/env python
#
# A script that reads a logfile containing terminal output from a Cardinal simulation
# and post-processes the data to generate a plot of the temperature differential norm.
#
# author: Kyle A. Damm
# date:   10-09-2025
#

import matplotlib.pyplot as plt

def extract_array(filename):
    with open(filename, 'r') as f:
        lines = f.readlines()

    vals = []
    for i, line in enumerate(lines):
        # extract the temperature differential at a specific step
        if line.startswith("Steady-State Relative Differential Norm"):
            dT = float(line.split(":")[1])
            vals.append(dT)
    if not vals:
        raise ValueError("No 'Steady-State' lines with a numeric value found.")

    return vals


def plot(x, y):
    plt.figure(figsize=(8, 5))
    plt.plot(x, y, linewidth=2)
    plt.xlabel("Coupled Step")
    plt.ylabel("Temperature Differential Norm")
    plt.yscale("log")
    plt.ylim(1e-7, 5.0)
    plt.grid(True, which="both", linestyle="-", linewidth=0.7, alpha=0.5)
    plt.tight_layout()
    plt.show()

if __name__=='__main__':

    # path to Cardinal logfile
    path = 'log.run'

    # read in temperature differential norm data
    dT = extract_array(path)
    step = list(range(1, len(dT)+1))

    # plot
    plot(step, dT)
