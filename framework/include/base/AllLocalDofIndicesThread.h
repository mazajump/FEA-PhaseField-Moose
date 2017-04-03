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

#ifndef ALLLOCALDOFINDICESTHREAD_H
#define ALLLOCALDOFINDICESTHREAD_H

#include "Moose.h"
#include "MooseTypes.h"

// libmesh includes
#include "libmesh/elem_range.h"

// Forward declare classes in libMesh
namespace libMesh
{
class System;
class DofMap;
}

/**
 * Grab all the local dof indices for the variables passed in, in the system passed in.
 */
class AllLocalDofIndicesThread
{
public:
  AllLocalDofIndicesThread(System & sys, std::vector<std::string> vars);
  // Splitting Constructor
  AllLocalDofIndicesThread(AllLocalDofIndicesThread & x, Threads::split split);

  void operator()(const ConstElemRange & range);

  void join(const AllLocalDofIndicesThread & y);

  std::set<dof_id_type> _all_dof_indices;

protected:
  System & _sys;
  DofMap & _dof_map;
  std::vector<std::string> _vars;
  std::vector<unsigned int> _var_numbers;
  THREAD_ID _tid;
};

#endif // ALLLOCALDOFINDICESTHREAD_H
