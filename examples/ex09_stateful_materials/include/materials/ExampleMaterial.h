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

#include "Material.h"

#ifndef EXAMPLEMATERIAL_H
#define EXAMPLEMATERIAL_H

// Forward Declarations
class ExampleMaterial;

template <>
InputParameters validParams<ExampleMaterial>();

/**
 * Example material class that defines a few properties.
 */
class ExampleMaterial : public Material
{
public:
  ExampleMaterial(const InputParameters & parameters);

protected:
  virtual void initQpStatefulProperties() override;
  virtual void computeQpProperties() override;

private:
  Real _initial_diffusivity;

  /**
   * Create two MooseArray Refs to hold the current
   * and previous material properties respectively
   */
  MaterialProperty<Real> & _diffusivity;
  const MaterialProperty<Real> & _diffusivity_old;
};

#endif // EXAMPLEMATERIAL_H
