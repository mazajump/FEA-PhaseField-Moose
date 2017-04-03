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

#ifndef ANALYTICALINDICATOR_H
#define ANALYTICALINDICATOR_H

#include "ElementIntegralIndicator.h"

class AnalyticalIndicator;

template <>
InputParameters validParams<AnalyticalIndicator>();

class AnalyticalIndicator : public ElementIntegralIndicator
{
public:
  AnalyticalIndicator(const InputParameters & parameters);

protected:
  virtual Real computeQpIntegral() override;

  Function & _func;
};

#endif /* ANALYTICALINDICATOR_H */
