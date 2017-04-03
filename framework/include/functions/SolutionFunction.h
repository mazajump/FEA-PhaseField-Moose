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

#ifndef SOLUTIONFUNCTION_H
#define SOLUTIONFUNCTION_H

#include "Function.h"

// Forward decleration
class SolutionFunction;
class SolutionUserObject;

template <>
InputParameters validParams<SolutionFunction>();

/** Function for reading a solution from file
 * Creates a function that extracts values from a solution read from a file,
 * via a SolutionUserObject. It is possible to scale and add a constant to the
 * solution read.
 */
class SolutionFunction : public Function
{
public:
  /** Constructor
   * @param parameters The input parameters for the function
   */
  SolutionFunction(const InputParameters & parameters);

  /**
   * Extract a value from the solution
   * @param t Time at which to extract
   * @param p Spatial location of desired data
   * @return The value at t and p
   */
  virtual Real value(Real t, const Point & p) override;

  /**
   * Extract a gradient from the solution
   * @param t Time at which to extract
   * @param p Spatial location of desired data
   * @return The value at t and p
   */
  virtual RealGradient gradient(Real t, const Point & p) override;

  /**
   * Setup the function for use
   * Gathers a pointer to the SolutionUserObject containing the solution that
   * was read. A pointer is required because Functions are created prior to UserObjects,
   * see Moose.C.
   */
  virtual void initialSetup() override;

protected:
  /// Pointer to SolutionUserObject containing the solution of interest
  const SolutionUserObject * _solution_object_ptr;

  /// The local SolutionUserObject index for the variable extracted from the file
  unsigned int _solution_object_var_index;

  /// Factor to scale the solution by (default = 1)
  const Real _scale_factor;

  /// Factor to add to the solution (default = 0)
  const Real _add_factor;

  /// Factor to add to the solution if gradient is requested (default = \vec{0})
  RealGradient _add_grad;
};

#endif // SOLUTIONFUNCTION_H
