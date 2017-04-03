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

#ifndef CHECKINTEGRITYACTION_H
#define CHECKINTEGRITYACTION_H

#include "Action.h"

class CheckIntegrityAction;

template <>
InputParameters validParams<CheckIntegrityAction>();

class CheckIntegrityAction : public Action
{
public:
  CheckIntegrityAction(InputParameters params);

  virtual void act() override;
};

#endif // CHECKINTEGRITYACTION_H
