/****************************************************************/
/* MOOSE - Multiphysics Object Oriented Simulation Environment  */
/*                                                              */
/*          All contents are licensed under LGPL V2.1           */
/*             See LICENSE for full restrictions                */
/****************************************************************/

#ifndef RICHARDSDENSITYMETHANE20DEGC_H
#define RICHARDSDENSITYMETHANE20DEGC_H

#include "RichardsDensity.h"

class RichardsDensityMethane20degC;

template <>
InputParameters validParams<RichardsDensityMethane20degC>();

/**
 * Methane density - a quadratic fit to expressions in:
 * "Results of (pressure, density, temperature) measurements on methane and on nitrogen in the
 * temperature range from 273.15K to 323.15K at pressures up to 12MPa using new apparatus for
 * accurate gas-density"
 * This is only valid for p>=0, which is the physical region.  I extend to the p>0 domain with an
 * exponential, which will probably be sampled as the newton interative process converges towards
 * the solution.
 * NOTE: this expression is only valid to about P=20MPa.  Use van der Waals (RichardsDensityVDW) for
 * higher pressures.
 */
class RichardsDensityMethane20degC : public RichardsDensity
{
public:
  RichardsDensityMethane20degC(const InputParameters & parameters);

  /**
   * fluid density as a function of porepressure
   * @param p porepressure
   */
  Real density(Real p) const;

  /**
   * derivative of fluid density wrt porepressure
   * @param p porepressure
   */
  Real ddensity(Real p) const;

  /**
   * second derivative of fluid density wrt porepressure
   * @param p porepressure
   */
  Real d2density(Real p) const;

private:
  /// Unit of measurement for pressure (should be 1 for pressure in Pa, 1E6 for pressure in MPa, etc)
  Real _p_unit;
};

#endif // RICHARDSDENSITYMETHANE20DEGC_H
