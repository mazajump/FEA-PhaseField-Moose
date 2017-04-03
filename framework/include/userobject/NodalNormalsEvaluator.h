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

#ifndef NODALNORMALSEVALUATOR_H
#define NODALNORMALSEVALUATOR_H

#include "NodalUserObject.h"

class NodalNormalsEvaluator;
class AuxiliarySystem;

template <>
InputParameters validParams<NodalNormalsEvaluator>();

/**
 * Works on top of NodalNormalsPreprocessor
 */
class NodalNormalsEvaluator : public NodalUserObject
{
public:
  NodalNormalsEvaluator(const InputParameters & parameters);

  virtual void initialize() override;
  virtual void finalize() override;
  virtual void execute() override;
  virtual void threadJoin(const UserObject & uo) override;

protected:
  AuxiliarySystem & _aux;
};

#endif /* NODALNORMALSEVALUATOR_H */
