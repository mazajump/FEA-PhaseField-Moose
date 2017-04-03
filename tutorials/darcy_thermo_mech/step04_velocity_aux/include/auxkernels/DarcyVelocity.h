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

#ifndef DARCYVELOCITY_H
#define DARCYVELOCITY_H

#include "AuxKernel.h"

// Forward Declarations
class DarcyVelocity;

template <>
InputParameters validParams<DarcyVelocity>();

/**
 * Auxiliary kernel responsible for computing the Darcy velocity given
 * several fluid properties and the pressure gradient.
 */
class DarcyVelocity : public AuxKernel
{
public:
  DarcyVelocity(const InputParameters & parameters);

  virtual ~DarcyVelocity() {}

protected:
  /**
   * AuxKernels MUST override computeValue.  computeValue() is called on
   * every quadrature point.  For Nodal Auxiliary variables those quadrature
   * points coincide with the nodes.
   */
  virtual Real computeValue() override;

  /// Will hold 0, 1, or 2 corresponding to x, y, or z.
  int _component;

  /// The gradient of a coupled variable
  const VariableGradient & _pressure_gradient;

  /// Holds the permeability and viscosity from the material system
  const MaterialProperty<Real> & _permeability;
  const MaterialProperty<Real> & _viscosity;
};

#endif // DARCYVELOCITY_H
