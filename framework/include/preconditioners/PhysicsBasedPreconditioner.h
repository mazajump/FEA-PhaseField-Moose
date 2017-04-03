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

#ifndef PHYSICSBASEDPRECONDITIONER_H
#define PHYSICSBASEDPRECONDITIONER_H

// MOOSE includes
#include "MoosePreconditioner.h"

// libMesh includes
#include "libmesh/preconditioner.h"
#include "libmesh/linear_implicit_system.h"

// C++ includes
#include <vector>

// Forward declarations
class NonlinearSystemBase;
class PhysicsBasedPreconditioner;

template <>
InputParameters validParams<PhysicsBasedPreconditioner>();

/**
 * Implements a segregated solve preconditioner.
 */
class PhysicsBasedPreconditioner : public MoosePreconditioner, public Preconditioner<Number>
{
public:
  /**
   *  Constructor. Initializes PhysicsBasedPreconditioner data structures
   */
  PhysicsBasedPreconditioner(const InputParameters & params);
  virtual ~PhysicsBasedPreconditioner();

  /**
   * Add a diagonal system + possibly off-diagonals ones as well, also specifying type of
   * preconditioning
   */
  // FIXME: use better name
  void addSystem(unsigned int var,
                 std::vector<unsigned int> off_diag,
                 PreconditionerType type = AMG_PRECOND);

  /**
   * Computes the preconditioned vector "y" based on input "x".
   * Usually by solving Py=x to get the action of P^-1 x.
   */
  virtual void apply(const NumericVector<Number> & x, NumericVector<Number> & y);

  /**
   * Release all memory and clear data structures.
   */
  virtual void clear();

  /**
   * Initialize data structures if not done so already.
   */
  virtual void init();

  /**
   * This is called every time the "operator might have changed".
   *
   * This is essentially where you need to fill in your preconditioning matrix.
   */
  virtual void setup();

protected:
  /// The nonlinear system this PBP is associated with (convenience reference)
  NonlinearSystemBase & _nl;
  /// List of linear system that build up the preconditioner
  std::vector<LinearImplicitSystem *> _systems;
  /// Holds one Preconditioner object per small system to solve.
  std::vector<Preconditioner<Number> *> _preconditioners;
  /// Holds the order the blocks are solved for.
  std::vector<unsigned int> _solve_order;
  /// Which preconditioner to use for each solve.
  std::vector<PreconditionerType> _pre_type;
  /// Holds which off diagonal blocks to compute.
  std::vector<std::vector<unsigned int>> _off_diag;

  /**
   * Holds pointers to the off-diagonal matrices.
   * This is in the same order as _off_diag.
   *
   * This is really just for convenience so we don't have
   * to keep looking this thing up through it's name.
   */
  std::vector<std::vector<SparseMatrix<Number> *>> _off_diag_mats;
};

#endif // PHYSICSBASEDPRECONDITIONER_H
