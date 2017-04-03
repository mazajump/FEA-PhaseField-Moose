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

#ifndef TIMEKERNEL_H
#define TIMEKERNEL_H

#include "Kernel.h"

// Forward Declaration
class TimeKernel;

template <>
InputParameters validParams<TimeKernel>();

/**
 * All time kernels should inherit from this class
 *
 */
class TimeKernel : public Kernel
{
public:
  TimeKernel(const InputParameters & parameters);

  virtual void computeResidual() override;
};

#endif // TIMEKERNEL_H
