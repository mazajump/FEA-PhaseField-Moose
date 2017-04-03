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

#ifndef NODALNORMALSCORNER_H
#define NODALNORMALSCORNER_H

#include "SideUserObject.h"

class NodalNormalsCorner;
class AuxiliarySystem;

template <>
InputParameters validParams<NodalNormalsCorner>();

/**
 *
 */
class NodalNormalsCorner : public SideUserObject
{
public:
  NodalNormalsCorner(const InputParameters & parameters);

  virtual void initialize() override;
  virtual void finalize() override;
  virtual void execute() override;
  virtual void threadJoin(const UserObject & uo) override;

protected:
  AuxiliarySystem & _aux;
  BoundaryID _corner_boundary_id;
};

#endif /* NODALNORMALSCORNER_H */
