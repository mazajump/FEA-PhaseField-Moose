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

#ifndef FDDIFFUSION_H
#define FDDIFFUSION_H

#include "FDKernel.h"

class FDDiffusion;

template <>
InputParameters validParams<FDDiffusion>();

class FDDiffusion : public FDKernel
{
public:
  FDDiffusion(const InputParameters & parameters);
  virtual ~FDDiffusion();

protected:
  virtual Real computeQpResidual();
};

#endif /* FDDIFFUSION_H */
