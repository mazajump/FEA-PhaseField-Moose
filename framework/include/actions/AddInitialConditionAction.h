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

#ifndef ADDINITIALCONDITIONACTION_H
#define ADDINITIALCONDITIONACTION_H

#include "MooseObjectAction.h"

class AddInitialConditionAction;

template <>
InputParameters validParams<AddInitialConditionAction>();

class AddInitialConditionAction : public MooseObjectAction
{
public:
  AddInitialConditionAction(InputParameters params);

  virtual void act() override;
};

#endif // ADDINITIALCONDITIONACTION_H
