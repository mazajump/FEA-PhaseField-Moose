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

#ifndef PETSCOUTPUT_H
#define PETSCOUTPUT_H

// MOOSE includes
#include "Output.h"

// Forward declerations
class PetscOutput;

template <>
InputParameters validParams<PetscOutput>();

/**
 * Adds the ability to output on every nonlinear and/or linear residual
 */
class PetscOutput : public Output
{
public:
  /**
   * Class constructor
   * @param parameters Outputter input file parameters
   */
  PetscOutput(const InputParameters & parameters);

  /**
   * Get the output time.
   * This outputter enables the ability to perform output on the nonlinear and linear iterations
   * performed
   * by PETSc. To separate theses outputs within the output a pseudo time is defined, this function
   * provides
   * this time and it should be used in place of _time from Outputter.
   */
  virtual Real time() override;

protected:
  /// Current norm returned from PETSc
  Real _norm;

  /// Current non-linear iteration returned from PETSc
  PetscInt _nonlinear_iter;

  /// Current linear iteration returned from PETSc
  PetscInt _linear_iter;

private:
  /**
   * Internal setup function that executes at the beginning of the time step
   */
  void solveSetup() override;

#ifdef LIBMESH_HAVE_PETSC
  /**
   * Performs the output on non-linear iterations
   *
   * This is the monitor method that PETSc will call on non-linear iterations
   */
  static PetscErrorCode petscNonlinearOutput(SNES, PetscInt its, PetscReal fnorm, void * void_ptr);

  /**
   * Performs the output onlinear iterations
   *
   * This is the monitor method that PETSc will call on linear iterations
   */
  static PetscErrorCode petscLinearOutput(KSP, PetscInt its, PetscReal fnorm, void * void_ptr);
#endif

  /// The psuedo non-linear time
  Real _nonlinear_time;

  /// The pseuedo non-linear time step
  Real _nonlinear_dt;

  /// Psuedo linear time
  Real _linear_time;

  /// Psuedo linear time step
  Real _linear_dt;

  /// True if current output calls is on the linear residual (used by time())
  bool _on_linear_residual;

  /// True if current output call is on the non-linear residual (used by time())
  bool _on_nonlinear_residual;

  /// Pseudo non-linear timestep divisor
  Real _nonlinear_dt_divisor;

  /// Pseudo linear timestep divisor
  Real _linear_dt_divisor;

  /// Non-linear residual output start time
  Real _nonlinear_start_time;

  /// Linear residual output start time
  Real _linear_start_time;

  /// Non-linear residual output end time
  Real _nonlinear_end_time;

  /// Linear residual output end time
  Real _linear_end_time;
};
#endif // PETSCOUTPUT_H
