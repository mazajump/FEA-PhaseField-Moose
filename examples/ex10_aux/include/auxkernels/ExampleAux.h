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

#ifndef EXAMPLEAUX_H
#define EXAMPLEAUX_H

#include "AuxKernel.h"

// Forward Declarations
class ExampleAux;

template <>
InputParameters validParams<ExampleAux>();

/**
 * Coupled auxiliary value
 */
class ExampleAux : public AuxKernel
{
public:
  /**
   * Factory constructor, takes parameters so that all derived classes can be built using the same
   * constructor.
   */
  ExampleAux(const InputParameters & parameters);

protected:
  virtual Real computeValue() override;

  const VariableValue & _coupled_val;

  Real _value;
};

#endif // EXAMPLEAUX_H
