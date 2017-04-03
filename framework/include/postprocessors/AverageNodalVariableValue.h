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

#ifndef AVERAGENODALVARIABLEVALUE_H
#define AVERAGENODALVARIABLEVALUE_H

#include "NodalVariablePostprocessor.h"

// Forward Declarations
class AverageNodalVariableValue;

template <>
InputParameters validParams<AverageNodalVariableValue>();

class AverageNodalVariableValue : public NodalVariablePostprocessor
{
public:
  AverageNodalVariableValue(const InputParameters & parameters);

  virtual void initialize() override;
  virtual void execute() override;

  virtual Real getValue() override;

  virtual void threadJoin(const UserObject & y) override;

protected:
  Real _avg;
  unsigned int _n;
};

#endif // AVERAGENODALVARIABLEVALUE_H
