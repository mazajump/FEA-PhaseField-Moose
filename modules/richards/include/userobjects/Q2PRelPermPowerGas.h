/****************************************************************/
/* MOOSE - Multiphysics Object Oriented Simulation Environment  */
/*                                                              */
/*          All contents are licensed under LGPL V2.1           */
/*             See LICENSE for full restrictions                */
/****************************************************************/

#ifndef Q2PRELPERMPOWERGAS_H
#define Q2PRELPERMPOWERGAS_H

#include "RichardsRelPerm.h"

class Q2PRelPermPowerGas;

template <>
InputParameters validParams<Q2PRelPermPowerGas>();

/**
 * PowerGas form of relative permeability
 * Define s = seff/(1 - simm).
 * Then relperm = 1 - (n+1)s^n + ns^(n+1) if s<simm, otherwise relperm=1 or 0
 * This is suitable for gas relative permeability as a function of water saturation in Q2P models
 */
class Q2PRelPermPowerGas : public RichardsRelPerm
{
public:
  Q2PRelPermPowerGas(const InputParameters & parameters);

  /**
   * Relative permeability
   * @param seff effective saturation
   */
  Real relperm(Real seff) const;

  /**
   * Derivative of relative permeability wrt seff
   * @param seff effective saturation
   */
  Real drelperm(Real seff) const;

  /**
   * Second derivative of relative permeability wrt seff
   * @param seff effective saturation
   */
  Real d2relperm(Real seff) const;

protected:
  /// immobile saturation
  Real _simm;

  /// exponent
  Real _n;
};

#endif // Q2PRELPERMPOWERGAS_H
