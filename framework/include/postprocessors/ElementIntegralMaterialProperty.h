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

#ifndef ELEMENTINTEGRALMATERIALPROPERTY_H
#define ELEMENTINTEGRALMATERIALPROPERTY_H

#include "ElementIntegralPostprocessor.h"

class ElementIntegralMaterialProperty;

template <>
InputParameters validParams<ElementIntegralMaterialProperty>();

class ElementIntegralMaterialProperty : public ElementIntegralPostprocessor
{
public:
  ElementIntegralMaterialProperty(const InputParameters & parameters);

protected:
  virtual Real computeQpIntegral() override;

  const MaterialProperty<Real> & _scalar;
};

#endif
