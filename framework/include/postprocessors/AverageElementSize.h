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

#ifndef AVERAGEELEMENTSIZE_H
#define AVERAGEELEMENTSIZE_H

#include "ElementAverageValue.h"

// Forward Declarations
class AverageElementSize;

template <>
InputParameters validParams<AverageElementSize>();

/**
 * This postprocessor computes an average element size (h) for the whole domain.
 */
class AverageElementSize : public ElementAverageValue
{
public:
  AverageElementSize(const InputParameters & parameters);

  virtual void initialize() override;
  virtual void execute() override;

  virtual Real computeIntegral() override;

  virtual Real getValue() override;
  virtual void threadJoin(const UserObject & y) override;

protected:
  int _elems;
};

#endif // AVERAGEELEMENTSIZE_H
