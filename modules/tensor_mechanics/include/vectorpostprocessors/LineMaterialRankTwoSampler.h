/****************************************************************/
/* MOOSE - Multiphysics Object Oriented Simulation Environment  */
/*                                                              */
/*          All contents are licensed under LGPL V2.1           */
/*             See LICENSE for full restrictions                */
/****************************************************************/

#ifndef LINEMATERIALRANKTWOSAMPLER_H
#define LINEMATERIALRANKTWOSAMPLER_H

#include "LineMaterialSamplerBase.h"
#include "RankTwoTensor.h"

// Forward Declarations
class LineMaterialRankTwoSampler;

template <>
InputParameters validParams<LineMaterialRankTwoSampler>();

/**
 * This class samples components of RankTwoTensor material properties for the integration points
 * in all elements that are intersected by a user-defined line.
 */
class LineMaterialRankTwoSampler : public LineMaterialSamplerBase<RankTwoTensor>
{
public:
  /**
   * Class constructor
   * Sets up variables for output based on the properties to be output
   * @param parameters The input parameters
   */
  LineMaterialRankTwoSampler(const InputParameters & parameters);

  /**
   * Reduce the material property to a scalar for output
   * Call through to RankTwoScalarTools::component() to access the components
   * @param property The material property
   * @param curr_point The point corresponding to this material property
   * @return A scalar value from this material property to be output
   */
  virtual Real getScalarFromProperty(const RankTwoTensor & property, const Point & curr_point);

  const unsigned int _i;
  const unsigned int _j;
};

#endif // LINEMATERIALRANKTWOSAMPLER
