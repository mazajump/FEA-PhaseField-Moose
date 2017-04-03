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
#ifndef MMSDIFFUSION_H_
#define MMSDIFFUSION_H_

#include "Kernel.h"

class MMSDiffusion;

template <>
InputParameters validParams<MMSDiffusion>();

class MMSDiffusion : public Kernel
{
public:
  MMSDiffusion(const InputParameters & parameters);

protected:
  virtual Real computeQpResidual();
  virtual Real computeQpJacobian();

  unsigned int _mesh_dimension;
};

#endif // MMSDIFFUSION_H
