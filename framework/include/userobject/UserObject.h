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

#ifndef USEROBJECT_H
#define USEROBJECT_H

// MOOSE includes
#include "MooseObject.h"
#include "SetupInterface.h"
#include "FunctionInterface.h"
#include "DistributionInterface.h"
#include "Restartable.h"
#include "MeshChangedInterface.h"
#include "ParallelUniqueId.h"
#include "ScalarCoupleable.h"

// libMesh includes
#include "libmesh/parallel.h"

// Forward declarations
class UserObject;
class FEProblemBase;
class SubProblem;
class Assembly;

template <>
InputParameters validParams<UserObject>();

/**
 * Base class for user-specific data
 */
class UserObject : public MooseObject,
                   public SetupInterface,
                   public FunctionInterface,
                   public DistributionInterface,
                   public Restartable,
                   public MeshChangedInterface,
                   public ScalarCoupleable
{
public:
  UserObject(const InputParameters & params);
  virtual ~UserObject();

  /**
   * Execute method.
   */
  virtual void execute() = 0;

  /**
   * Called before execute() is ever called so that data can be cleared.
   */
  virtual void initialize() = 0;

  /**
   * Finalize.  This is called _after_ execute() and _after_ threadJoin()!  This is probably where
   * you want to do MPI communication!
   */
  virtual void finalize() = 0;

  /**
   * Load user data object from a stream
   * @param stream Stream to load from
   */
  virtual void load(std::ifstream & stream);

  /**
   * Store user data object to a stream
   * @param stream Stream to store to
   */
  virtual void store(std::ofstream & stream);

  /**
   * Returns a reference to the subproblem that
   * this postprocessor is tied to
   */
  SubProblem & getSubProblem() const { return _subproblem; }

  /**
   * Optional interface function for "evaluating" a UserObject at a spatial position.
   * If a UserObject overrides this function that UserObject can then be used in a
   * Transfer to transfer information from one domain to another.
   */
  virtual Real spatialValue(const Point & /*p*/) const
  {
    mooseError(name(), " does not satisfy the Spatial UserObject interface!");
  }

  /**
   * Must override.
   *
   * @param uo The UserObject to be joined into _this_ object.  Take the data from the uo object and
   * "add" it into the data for this object.
   */
  virtual void threadJoin(const UserObject & uo) = 0;

  /**
   * Gather the parallel sum of the variable passed in. It takes care of values across all threads
   * and CPUs (we DO hybrid parallelism!)
   *
   * After calling this, the variable that was passed in will hold the gathered value.
   */
  template <typename T>
  void gatherSum(T & value)
  {
    _communicator.sum(value);
  }

  template <typename T>
  void gatherMax(T & value)
  {
    _communicator.max(value);
  }

  template <typename T>
  void gatherMin(T & value)
  {
    _communicator.min(value);
  }

  template <typename T1, typename T2>
  void gatherProxyValueMax(T1 & value, T2 & proxy)
  {
    unsigned int rank;
    _communicator.maxloc(value, rank);
    _communicator.broadcast(proxy, rank);
  }

protected:
  /// Reference to the Subproblem for this user object
  SubProblem & _subproblem;

  /// Reference to the FEProblemBase for this user object
  FEProblemBase & _fe_problem;

  /// Thread ID of this postprocessor
  THREAD_ID _tid;
  Assembly & _assembly;

  /// Coordinate system
  const Moose::CoordinateSystemType & _coord_sys;
};

#endif /* USEROBJECT_H */
