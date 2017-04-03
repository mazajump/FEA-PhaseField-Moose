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

#ifndef FLAGELEMENTSTHREAD_H
#define FLAGELEMENTSTHREAD_H

#include "ThreadedElementLoop.h"

// libMesh includes
#include "libmesh/elem_range.h"

class AuxiliarySystem;
class Adaptivity;
class DisplacedProblem;

class FlagElementsThread : public ThreadedElementLoop<ConstElemRange>
{
public:
  FlagElementsThread(FEProblemBase & fe_problem,
                     std::vector<Number> & serialized_solution,
                     unsigned int max_h_level,
                     const std::string & marker_name);

  // Splitting Constructor
  FlagElementsThread(FlagElementsThread & x, Threads::split split);

  virtual void onElement(const Elem * elem) override;

  void join(const FlagElementsThread & /*y*/);

protected:
  FEProblemBase & _fe_problem;
  std::shared_ptr<DisplacedProblem> _displaced_problem;
  AuxiliarySystem & _aux_sys;
  unsigned int _system_number;
  Adaptivity & _adaptivity;
  MooseVariable & _field_var;
  unsigned int _field_var_number;
  std::vector<Number> & _serialized_solution;
  unsigned int _max_h_level;
};

#endif // FLAGELEMENTSTHREAD_H
