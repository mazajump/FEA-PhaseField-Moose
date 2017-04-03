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

#ifndef PENETRATIONAUX_H
#define PENETRATIONAUX_H

#include "AuxKernel.h"

// Forward Declarations
class PenetrationAux;
class PenetrationLocator;

template <>
InputParameters validParams<PenetrationAux>();

/**
 * Constant auxiliary value
 */
class PenetrationAux : public AuxKernel
{
public:
  /**
   * Factory constructor, takes parameters so that all derived classes can be built using the same
   * constructor.
   */
  PenetrationAux(const InputParameters & parameters);

protected:
  enum PA_ENUM
  {
    PA_DISTANCE,
    PA_TANG_DISTANCE,
    PA_NORMAL_X,
    PA_NORMAL_Y,
    PA_NORMAL_Z,
    PA_CLOSEST_POINT_X,
    PA_CLOSEST_POINT_Y,
    PA_CLOSEST_POINT_Z,
    PA_ELEM_ID,
    PA_SIDE,
    PA_INCREMENTAL_SLIP_MAG,
    PA_INCREMENTAL_SLIP_X,
    PA_INCREMENTAL_SLIP_Y,
    PA_INCREMENTAL_SLIP_Z,
    PA_ACCUMULATED_SLIP,
    PA_FORCE_X,
    PA_FORCE_Y,
    PA_FORCE_Z,
    PA_NORMAL_FORCE_MAG,
    PA_NORMAL_FORCE_X,
    PA_NORMAL_FORCE_Y,
    PA_NORMAL_FORCE_Z,
    PA_TANGENTIAL_FORCE_MAG,
    PA_TANGENTIAL_FORCE_X,
    PA_TANGENTIAL_FORCE_Y,
    PA_TANGENTIAL_FORCE_Z,
    PA_FRICTIONAL_ENERGY,
    PA_LAGRANGE_MULTIPLIER,
    PA_MECH_STATUS
  };

  PA_ENUM _quantity;

  virtual Real computeValue() override;

  PenetrationLocator & _penetration_locator;

public:
  static const Real NotPenetrated;
};

#endif // PENETRATIONAUX_H
