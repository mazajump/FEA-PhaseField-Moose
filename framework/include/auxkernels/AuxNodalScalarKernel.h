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

#ifndef AUXNODALSCALARKERNEL_H
#define AUXNODALSCALARKERNEL_H

#include "AuxScalarKernel.h"
#include "Coupleable.h"
#include "MooseVariableDependencyInterface.h"

class NodalScalarKernel;

template <>
InputParameters validParams<NodalScalarKernel>();

/**
 *
 */
class AuxNodalScalarKernel : public AuxScalarKernel,
                             public Coupleable,
                             public MooseVariableDependencyInterface
{
public:
  AuxNodalScalarKernel(const InputParameters & parameters);

  virtual void compute() override;

protected:
  /// List of node IDs
  std::vector<dof_id_type> _node_ids;
};

#endif /* AUXNODALSCALARKERNEL_H */
