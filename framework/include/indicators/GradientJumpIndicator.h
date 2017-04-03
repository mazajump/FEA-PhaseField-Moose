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

#ifndef GRADIENTJUMPINDICATOR_H
#define GRADIENTJUMPINDICATOR_H

#include "InternalSideIndicator.h"

class GradientJumpIndicator;

template <>
InputParameters validParams<GradientJumpIndicator>();

class GradientJumpIndicator : public InternalSideIndicator
{
public:
  GradientJumpIndicator(const InputParameters & parameters);

protected:
  virtual Real computeQpIntegral() override;
};

#endif /* GRADIENTJUMPINDICATOR_H */
