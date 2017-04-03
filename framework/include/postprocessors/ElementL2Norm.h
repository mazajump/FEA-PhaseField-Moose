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

#ifndef ELEMENTL2NORM_H
#define ELEMENTL2NORM_H

#include "ElementIntegralVariablePostprocessor.h"

// Forward Declarations
class ElementL2Norm;

template <>
InputParameters validParams<ElementL2Norm>();

class ElementL2Norm : public ElementIntegralVariablePostprocessor
{
public:
  ElementL2Norm(const InputParameters & parameters);

  virtual Real getValue() override;

protected:
  virtual Real computeQpIntegral() override;
};

#endif // ELEMENTL2NORM_H
