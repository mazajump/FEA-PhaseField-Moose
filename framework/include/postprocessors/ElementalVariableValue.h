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

#ifndef ELEMENTALVARIABLEVALUE_H
#define ELEMENTALVARIABLEVALUE_H

// MOOSE includes
#include "GeneralPostprocessor.h"

// Forward Declarations
class ElementalVariableValue;
class MooseMesh;

namespace libMesh
{
class Elem;
}

template <>
InputParameters validParams<ElementalVariableValue>();

class ElementalVariableValue : public GeneralPostprocessor
{
public:
  ElementalVariableValue(const InputParameters & parameters);

  virtual void initialize() override {}
  virtual void execute() override {}
  virtual Real getValue() override;

protected:
  MooseMesh & _mesh;
  std::string _var_name;
  Elem * _element;
};

#endif // ELEMENTALVARIABLEVALUE_H
