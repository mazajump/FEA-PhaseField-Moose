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
#ifndef MATCONVECTION_H
#define MATCONVECTION_H

#include "Kernel.h"

// Forward Declaration
class MatConvection;

template <>
InputParameters validParams<MatConvection>();

class MatConvection : public Kernel
{
public:
  MatConvection(const InputParameters & parameters);

protected:
  virtual Real computeQpResidual();
  virtual Real computeQpJacobian();

  const MaterialProperty<Real> & _conv_prop;

  RealVectorValue _velocity;

  Real _x;
  Real _y;
  Real _z;
};

#endif // MATCONVECTION_H
