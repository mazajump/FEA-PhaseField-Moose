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

#ifndef FUNCTIONAUX_H
#define FUNCTIONAUX_H

#include "AuxKernel.h"

// Forward Declarations
class FunctionAux;
class Function;

template <>
InputParameters validParams<FunctionAux>();

/**
 * Function auxiliary value
 */
class FunctionAux : public AuxKernel
{
public:
  /**
   * Factory constructor, takes parameters so that all derived classes can be built using the same
   * constructor.
   */
  FunctionAux(const InputParameters & parameters);

protected:
  virtual Real computeValue() override;

  /// Function being used to compute the value of this kernel
  Function & _func;
};

#endif // FUNCTIONAUX_H
