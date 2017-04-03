/****************************************************************/
/* MOOSE - Multiphysics Object Oriented Simulation Environment  */
/*                                                              */
/*          All contents are licensed under LGPL V2.1           */
/*             See LICENSE for full restrictions                */
/****************************************************************/

#ifndef RICHARDSSEFF1RSC_H
#define RICHARDSSEFF1RSC_H

#include "RichardsSeff.h"
#include "RichardsSeffRSC.h"

class RichardsSeff1RSC;

template <>
InputParameters validParams<RichardsSeff1RSC>();

/**
 * Rogers-Stallybrass-Clements version of effective saturation for single-phase simulations
 * as a function of porepressure, and its derivs wrt to that pressure.
 * Note that this is mostly useful for 2phase simulations, not this singlephase version.
 * Valid for residual saturations = 0, and viscosityOil = 2*viscosityWater.  (the "2" is important
 * here!).
 * C Rogers, MP Stallybrass and DL Clements "On two phase filtration under gravity and with boundary
 * infiltration: application of a Backlund transformation" Nonlinear Analysis Theory Methods and
 * Applications 7 (1983) 785--799.
 */
class RichardsSeff1RSC : public RichardsSeff
{
public:
  RichardsSeff1RSC(const InputParameters & parameters);

  /**
   * water effective saturation
   * @param p porepressures.  Here (*p[0])[qp] is the water pressure at quadpoint qp
   * @param qp the quadpoint to evaluate effective saturation at
   */
  Real seff(std::vector<const VariableValue *> p, unsigned int qp) const;

  /**
   * derivative of effective saturation as a function of porepressure
   * @param p porepressure in the element.  Note that (*p[0])[qp] is the porepressure at quadpoint
   * qp
   * @param qp the quad point to evaluate effective saturation at
   * @param result the derivtives will be placed in this array
   */
  void
  dseff(std::vector<const VariableValue *> p, unsigned int qp, std::vector<Real> & result) const;

  /**
   * second derivative of effective saturation as a function of porepressure
   * @param p porepressure in the element.  Note that (*p[0])[qp] is the porepressure at quadpoint
   * qp
   * @param qp the quad point to evaluate effective saturation at
   * @param result the derivtives will be placed in this array
   */
  void d2seff(std::vector<const VariableValue *> p,
              unsigned int qp,
              std::vector<std::vector<Real>> & result) const;

protected:
  /// oil viscosity
  Real _oil_viscosity;

  /// RSC scale ratio
  Real _scale_ratio;

  /// RSC shift
  Real _shift;

  /// RSC scale
  Real _scale;
};

#endif // RICHARDSSEFF1RSC_H
