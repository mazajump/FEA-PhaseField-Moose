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

#ifndef MAXINCREMENT_H
#define MAXINCREMENT_H

// Moose Includes
#include "ElementDamper.h"

// Forward Declarations
class MaxIncrement;

template <>
InputParameters validParams<MaxIncrement>();

/**
 * TODO
 */
class MaxIncrement : public ElementDamper
{
public:
  MaxIncrement(const InputParameters & parameters);

protected:
  virtual Real computeQpDamping() override;

  ///The maximum Newton increment for the variable.
  Real _max_increment;
};

#endif // MAXINCREMENT_H
