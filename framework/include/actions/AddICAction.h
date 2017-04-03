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

#ifndef ADDICACTION_H
#define ADDICACTION_H

#include "MooseObjectAction.h"

class AddICAction;

template <>
InputParameters validParams<AddICAction>();

class AddICAction : public MooseObjectAction
{
public:
  AddICAction(InputParameters params);

  virtual void act() override;
};

#endif // ADDICACTION_H
