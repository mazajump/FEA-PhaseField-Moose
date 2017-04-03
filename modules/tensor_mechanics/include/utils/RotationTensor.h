/****************************************************************/
/* MOOSE - Multiphysics Object Oriented Simulation Environment  */
/*                                                              */
/*          All contents are licensed under LGPL V2.1           */
/*             See LICENSE for full restrictions                */
/****************************************************************/
#ifndef ROTATIONTENSOR_H
#define ROTATIONTENSOR_H

#include "Moose.h"

// Any requisite includes here
#include "libmesh/tensor_value.h"
#include "libmesh/vector_value.h"

/**
 * This is a RealTensor version of a rotation matrix
 * It is instantiated
 *   with the Euler angles, which are measured in degrees.
 *     R = Z0 *X1 * Z2
 *     where Z0 = anticlockwise rotation about Z axis through euler_angles(0) degrees
 *     where X1 = anticlockwise rotation about X axis through euler_angles(1) degress
 *     where Z2 = anticlockwise rotation about Z axis through euler_angles(2) degrees
 *   or an axis, angle pair
 *     where the angle is taken anticlockwise in degrees
 */
class RotationTensor : public RealTensorValue
{
public:
  /// axis for single axis rotation constructor
  enum Axis
  {
    XAXIS = 0,
    YAXIS,
    ZAXIS
  };

  /// single axis rotation (in degrees)
  RotationTensor(Axis axis, Real angle);

  /// fills according to Euler angles (measured in degrees)
  RotationTensor(const RealVectorValue & euler_angles);

  /// reforms the rotation matrix according to axis and angle.
  void update(Axis axis, Real angle);

  /// reforms the rotation matrix according to the Euler angles.
  void update(const RealVectorValue & euler_angles);
};

#endif // ROTATIONTENSOR_H
