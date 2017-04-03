/****************************************************************/
/*               DO NOT MODIFY THIS HEADER                      */
/* MOOSE - Multiphysics Object Oriented Simulation Environment  */
/*                                                              */
/*           (c) 2010 Battelle Energy Alliance, LLC             */
/*                   ALL RIGHTS RESERVED                        */
/*                                                              */
/*          Prepared by Battelle Energy Alliance, LLC           */
/*            Under Contract No. DE-AC07-05ID14517              */
/*            With the U. S. Department of Energy               */
/*                                                              */
/*            See COPYRIGHT for full restrictions               */
/****************************************************************/

#ifndef ELEMENTLPNORMAUX_H
#define ELEMENTLPNORMAUX_H

// MOOSE includes
#include "AuxKernel.h"

// Forward declarations
class ElementLpNormAux;

template <>
InputParameters validParams<ElementLpNormAux>();

/**
 * Compute an elemental field variable (single value per element)
 * equal to the Lp-norm of a coupled Variable.
 */
class ElementLpNormAux : public AuxKernel
{
public:
  /**
   * Class constructor
   * @param name Object name
   * @param parameters Object input parameters
   */
  ElementLpNormAux(const InputParameters & parameters);

  /**
   * Override the base class functionality to compute the element
   * integral withou scaling by element volume.
   */
  virtual void compute() override;

protected:
  /**
   * Called by compute() to get the value of the integrand at the
   * current qp.
   */
  virtual Real computeValue() override;

  // The exponent used in the norm
  Real _p;

  /// A reference to the variable to compute the norm of.
  const VariableValue & _coupled_var;
};

#endif // ELEMENTLPNORMAUX_H
