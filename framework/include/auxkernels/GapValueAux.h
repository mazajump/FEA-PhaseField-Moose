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

#ifndef GAPVALUEAUX_H
#define GAPVALUEAUX_H

#include "AuxKernel.h"

// Forward Declarations
class GapValueAux;
class PenetrationLocator;

template <>
InputParameters validParams<GapValueAux>();

class GapValueAux : public AuxKernel
{
public:
  GapValueAux(const InputParameters & parameters);

protected:
  virtual Real computeValue() override;

  PenetrationLocator & _penetration_locator;

  MooseVariable & _moose_var;

  const NumericVector<Number> *& _serialized_solution;

  const DofMap & _dof_map;

  const bool _warnings;
};

#endif // GAPVALUEAUX_H
