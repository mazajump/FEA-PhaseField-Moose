#!/usr/bin/env python

import os
import sys
import numpy as np
import matplotlib.pyplot as plt

def expected_s01(t):
    bulk = 1.3
    dens0 = 1.1
    rate = -6
    por = 0.1
    area = 0.5
    vol = 0.25
    p0 = 1
    initial_mass = vol * por * dens0 * np.exp(p0 / bulk)
    return initial_mass + rate * area * t

def expected_s02(t):
    # rho = rho0*exp(rate*area*perm*t/visc/vol/por)
    bulk = 1.3
    dens0 = 1.1
    rate = -6
    por = 0.1
    area = 0.5
    vol = 0.25
    p0 = 1
    visc = 1.1
    perm = 0.2
    initial_dens = dens0 * np.exp(p0 / bulk)
    return vol * por * initial_dens * np.exp(rate * area * perm * t / visc / vol / por)

def expected_s03(s):
    rate = 6
    area = 0.5
    return rate * area * s * s

def expected_s04(p):
    return [8 * min(max(pp + 0.2, 0.5), 1) for pp in p]

def expected_s05(p):
    fcn = 6
    center = 0.9
    sd = 0.5
    return [fcn * np.exp(-0.5 * pow(min((pp - center) / sd, 0), 2)) for pp in p]

def expected_s06(p):
    fcn = 3
    center = 0.9
    cutoff = -0.8
    xx = p - center
    return [fcn if (x >= 0) else ( 0 if (x <= cutoff) else fcn / pow(cutoff, 3) * (2 * x + cutoff) * pow(x - cutoff, 2)) for x in xx]

def expected_s07(f):
    rate = 6
    area = 0.5
    return rate * area * f

def expected_s08(pc):
    mass_frac = 0.8
    rate = 100
    area = 0.5
    al = 1.1
    m = 0.5
    sg = 1 - pow(1.0 + pow(al * pc, 1.0 / (1.0 - m)), -m)
    return rate * area * mass_frac * sg * sg

def s01():
    f = open("../../tests/sinks/gold/s01.csv")
    data = [map(float, line.strip().split(",")) for line in f.readlines()[1:] if line.strip()]
    m00 = [d[2] for d in data]
    t = [d[0] for d in data]
    return (t, m00)

def s02():
    f = open("../../tests/sinks/gold/s02.csv")
    data = [map(float, line.strip().split(",")) for line in f.readlines()[1:] if line.strip()]
    m00 = [d[1] for d in data]
    t = [d[0] for d in data]
    return (t, m00)

def s03():
    f = open("../../tests/sinks/gold/s03.csv")
    data = [map(float, line.strip().split(",")) for line in f.readlines()[1:] if line.strip()]
    rate00 = [d[5] for d in data]
    s = [d[10] for d in data]
    return (s, rate00)

def s04():
    f = open("../../tests/sinks/gold/s04.csv")
    data = [map(float, line.strip().split(",")) for line in f.readlines()[1:] if line.strip()]
    rate10 = [d[3] for d in data]
    p = [d[9] for d in data]
    return (p, rate10)

def s05():
    f = open("../../tests/sinks/gold/s05.csv")
    data = [map(float, line.strip().split(",")) for line in f.readlines()[1:] if line.strip()]
    rate10 = [2*d[1] for d in data]
    p = [d[10] for d in data]
    return (p, rate10)

def s06():
    f = open("../../tests/sinks/gold/s06.csv")
    data = [map(float, line.strip().split(",")) for line in f.readlines()[1:] if line.strip()]
    prate = sorted(list(set([(d[11], d[1]) for d in data] + [(d[12], d[2]) for d in data] + [(d[13], d[3]) for d in data] + [(d[14], d[4]) for d in data])), key = lambda x: x[0])
    return zip(*prate)

def s07():
    f = open("../../tests/sinks/gold/s07.csv")
    data = [map(float, line.strip().split(",")) for line in f.readlines()[1:] if line.strip()]
    massfrac = [d[1] for d in data]
    flux = [d[4] for d in data]
    return (massfrac, flux)

def s08():
    f = open("../../tests/sinks/gold/s08.csv")
    data = [map(float, line.strip().split(",")) for line in f.readlines()[1:] if line.strip()]
    rate00 = [d[1] for d in data]
    pc = [(d[6] - d[7]) for d in data]
    return (pc, rate00)

plt.figure()
moose_results = s01()
mooset = moose_results[0]
moosem = moose_results[1]
delt = (mooset[-1] - mooset[0])/100
tpoints = np.arange(mooset[0] - delt, mooset[-1] + delt, delt)
plt.plot(tpoints, expected_s01(tpoints), 'k-', linewidth = 3.0, label = 'expected')
plt.plot(mooset, moosem, 'rs', markersize = 10.0, label = 'MOOSE')
plt.legend(loc = 'upper right')
plt.xlabel("t (s)")
plt.ylabel("Nodal mass (kg)")
plt.title("Basic sink")
plt.savefig("s01.pdf")

plt.figure()
moose_results = s02()
mooset = moose_results[0]
moosem = moose_results[1]
delt = (mooset[-1] - mooset[0])/100
tpoints = np.arange(mooset[0] - delt, mooset[-1] + delt, delt)
plt.plot(tpoints, expected_s02(tpoints), 'k-', linewidth = 3.0, label = 'expected')
plt.plot(mooset, moosem, 'rs', markersize = 10.0, label = 'MOOSE')
plt.legend(loc = 'upper right')
plt.xlabel("t (s)")
plt.ylabel("Nodal mass (kg)")
plt.title("Basic sink with mobility multiplier")
plt.savefig("s02.pdf")

plt.figure()
moose_results = s03()
mooses = moose_results[0]
mooser = moose_results[1]
dels = (mooses[0] - mooses[-1])/100
spoints = np.arange(mooses[-1] - dels, mooses[0] + dels, dels)
plt.plot(spoints, expected_s03(spoints), 'k-', linewidth = 3.0, label = 'expected')
plt.plot(mooses, mooser, 'rs', markersize = 10.0, label = 'MOOSE')
plt.legend(loc = 'upper right')
plt.xlabel("Saturation")
plt.ylabel("Sink rate")
plt.title("Basic sink with relative-permeability multiplier")
plt.savefig("s03.pdf")

plt.figure()
moose_results = s04()
moosep = moose_results[0]
mooser = moose_results[1]
delp = (moosep[0] - moosep[-1])/100
ppoints = np.arange(moosep[-1] - delp, moosep[0] + delp, delp)
plt.plot(ppoints, expected_s04(ppoints), 'k-', linewidth = 3.0, label = 'expected')
plt.plot(moosep, mooser, 'rs', markersize = 10.0, label = 'MOOSE')
plt.legend(loc = 'lower right')
plt.xlabel("Porepressure (Pa)")
plt.ylabel("Sink rate (kg/m^2/s)")
plt.title("Piecewise-linear sink")
plt.axis([0.1, 1, 3.9, 8.1])
plt.savefig("s04.pdf")

plt.figure()
moose_results = s05()
moosep = moose_results[0]
mooser = moose_results[1]
delp = (moosep[0] - moosep[-1])/100
ppoints = np.arange(moosep[-1] - delp, moosep[0] + delp, delp)
plt.plot(ppoints, expected_s05(ppoints), 'k-', linewidth = 3.0, label = 'expected')
plt.plot(moosep, mooser, 'rs', markersize = 10.0, label = 'MOOSE')
plt.legend(loc = 'lower right')
plt.xlabel("Porepressure (Pa)")
plt.ylabel("Sink rate (kg/m^2/s)")
plt.title("Half-Gaussian sink")
plt.axis([-0.4, 1.2, 0, 6.1])
plt.savefig("s05.pdf")

plt.figure()
moose_results = s06()
moosep = moose_results[0]
mooser = moose_results[1]
delp = (moosep[-1] - moosep[0])/100
ppoints = np.arange(moosep[0] - delp, moosep[-1] + delp, delp)
plt.plot(ppoints, expected_s06(ppoints), 'k-', linewidth = 3.0, label = 'expected')
plt.plot(moosep, mooser, 'rs', markersize = 10.0, label = 'MOOSE')
plt.legend(loc = 'lower right')
plt.xlabel("Porepressure (Pa)")
plt.ylabel("Sink rate (kg/m^2/s)")
plt.title("Half-cubic sink")
plt.axis([-0.1, 1.3, -0.1, 3.1])
plt.savefig("s06.pdf")

plt.figure()
moose_results = s07()
moosefrac = moose_results[0]
mooseflux = moose_results[1]
delfrac = (moosefrac[0] - moosefrac[-1])/100
fpoints = np.arange(moosefrac[-1] - delfrac, moosefrac[0] + delfrac, delfrac)
plt.plot(fpoints, expected_s07(fpoints), 'k-', linewidth = 3.0, label = 'expected')
plt.plot(moosefrac, mooseflux, 'rs', markersize = 10.0, label = 'MOOSE')
plt.legend(loc = 'lower right')
plt.xlabel("Mass fraction")
plt.ylabel("Sink rate (kg/m^2/s)")
plt.title("Mass-fraction dependent sink")
plt.savefig("s07.pdf")

plt.figure()
moose_results = s08()
moosepc = moose_results[0]
mooser = moose_results[1]
delpc = (moosepc[0] - moosepc[-1])/100
pcpoints = np.arange(moosepc[-1] - dels, moosepc[0] + dels, dels)
plt.plot(pcpoints, expected_s08(pcpoints), 'k-', linewidth = 3.0, label = 'expected')
plt.plot(moosepc, mooser, 'rs', markersize = 10.0, label = 'MOOSE')
plt.legend(loc = 'lower right')
plt.xlabel("Capillary pressure (Pa)")
plt.ylabel("Sink rate (kg/m^2/s)")
plt.title("Mass-fraction and relative-permeability dependent sink (2 phase, 3 comp)")
plt.savefig("s08.pdf")


sys.exit(0)
