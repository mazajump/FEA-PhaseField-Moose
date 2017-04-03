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

#ifndef CONSTANTPOINTSOURCE_H
#define CONSTANTPOINTSOURCE_H

// Moose Includes
#include "DiracKernel.h"

// Forward Declarations
class ConstantPointSource;

template <>
InputParameters validParams<ConstantPointSource>();

/**
 * TOOD
 */
class ConstantPointSource : public DiracKernel
{
public:
  ConstantPointSource(const InputParameters & parameters);

  virtual void addPoints() override;

protected:
  virtual Real computeQpResidual() override;

  Real _value;
  std::vector<Real> _point_param;
  Point _p;
};

#endif // CONSTANTPOINTSOURCE_H
