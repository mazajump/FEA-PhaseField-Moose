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

#ifndef SIDESETSBETWEENSUBDOMAINS_H
#define SIDESETSBETWEENSUBDOMAINS_H

#include "MeshModifier.h"

class SideSetsBetweenSubdomains;

template <>
InputParameters validParams<SideSetsBetweenSubdomains>();

class SideSetsBetweenSubdomains : public MeshModifier
{
public:
  SideSetsBetweenSubdomains(const InputParameters & parameters);

protected:
  virtual void modify() override;
};

#endif /* SIDESETSBETWEENSUBDOMAINS_H */
