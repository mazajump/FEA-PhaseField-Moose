/****************************************************************/
/* MOOSE - Multiphysics Object Oriented Simulation Environment  */
/*                                                              */
/*          All contents are licensed under LGPL V2.1           */
/*             See LICENSE for full restrictions                */
/****************************************************************/
#ifndef NSTHERMALINFLOWBC_H
#define NSTHERMALINFLOWBC_H

// MOOSE includes
#include "NodalBC.h"

// Forward Declarations
class NSInflowThermalBC;
class IdealGasFluidProperties;

template <>
InputParameters validParams<NSInflowThermalBC>();

/**
 * This class is used on a boundary where the incoming flow
 * values (rho, u, v, T) are all completely specified.
 */
class NSInflowThermalBC : public NodalBC
{
public:
  NSInflowThermalBC(const InputParameters & parameters);

protected:
  // In general, the residual equation is u-u_d=0, where u_d
  // is a Dirichlet value.  Note that no computeQpJacobian()
  // function can be specified in this class... it is assumed
  // to simply have a 1 on the diagonal.
  virtual Real computeQpResidual();

  // The specified density for this inflow boundary
  const Real _specified_rho;

  // The specified temperature for this inflow boundary
  const Real _specified_temperature;

  // The specified velocity magnitude for this inflow boundary
  const Real _specified_velocity_magnitude;

  // Fluid properties
  const IdealGasFluidProperties & _fp;
};

#endif // NSTHERMALINFLOWBC_H
