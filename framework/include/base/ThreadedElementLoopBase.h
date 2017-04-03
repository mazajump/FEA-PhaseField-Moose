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

#ifndef THREADEDELEMENTLOOPBASE_H
#define THREADEDELEMENTLOOPBASE_H

#include "ParallelUniqueId.h"
#include "MooseMesh.h"
#include "MooseTypes.h"
#include "MooseException.h"

/**
 * Base class for assembly-like calculations.
 */
template <typename RangeType>
class ThreadedElementLoopBase
{
public:
  ThreadedElementLoopBase(MooseMesh & mesh);

  ThreadedElementLoopBase(ThreadedElementLoopBase & x, Threads::split split);

  virtual ~ThreadedElementLoopBase();

  void operator()(const RangeType & range, bool bypass_threading = false);

  /**
   * Called before the element range loop
   */
  virtual void pre();

  /**
   * Called after the element range loop
   */
  virtual void post();

  /**
   * Assembly of the element (not including surface assembly)
   *
   * @param elem - active element
   */
  virtual void onElement(const Elem * elem);

  /**
   * Called after the element assembly is done (including surface assembling)
   *
   * @param elem - active element
   */
  virtual void postElement(const Elem * elem);

  /**
   * Called when doing boundary assembling
   *
   * @param elem - The element we are checking is on the boundary.
   * @param side - The side of the element in question.
   * @param bnd_id - ID of the boundary we are at
   */
  virtual void onBoundary(const Elem * elem, unsigned int side, BoundaryID bnd_id);

  /**
   * Called when doing internal edge assembling
   *
   * @param elem - Element we are on
   * @param side - local side number of the element 'elem'
   */
  virtual void onInternalSide(const Elem * elem, unsigned int side);

  /**
   * Called when doing interface assembling
   *
   * @param elem - Element we are on
   * @param side - local side number of the element 'elem'
   * @param bnd_id - ID of the interface we are at
   */
  virtual void onInterface(const Elem * elem, unsigned int side, BoundaryID bnd_id);

  /**
   * Called every time the current subdomain changes (i.e. the subdomain of _this_ element
   * is not the same as the subdomain of the last element).  Beware of over-using this!
   * You might think that you can do some expensive stuff in here and get away with it...
   * but there are applications that have TONS of subdomains....
   */
  virtual void subdomainChanged();

  /**
   * Called if a MooseException is caught anywhere during the computation.
   * The single input parameter taken is a MooseException object.
   */
  virtual void caughtMooseException(MooseException &){};

  /**
   * Whether or not the loop should continue.
   *
   * @return true to keep going, false to stop.
   */
  virtual bool keepGoing() { return true; }

protected:
  MooseMesh & _mesh;
  THREAD_ID _tid;

  /// The subdomain for the current element
  SubdomainID _subdomain;

  /// The subdomain for the last element
  SubdomainID _old_subdomain;
};

template <typename RangeType>
ThreadedElementLoopBase<RangeType>::ThreadedElementLoopBase(MooseMesh & mesh) : _mesh(mesh)
{
}

template <typename RangeType>
ThreadedElementLoopBase<RangeType>::ThreadedElementLoopBase(ThreadedElementLoopBase & x,
                                                            Threads::split /*split*/)
  : _mesh(x._mesh)
{
}

template <typename RangeType>
ThreadedElementLoopBase<RangeType>::~ThreadedElementLoopBase()
{
}

template <typename RangeType>
void
ThreadedElementLoopBase<RangeType>::operator()(const RangeType & range, bool bypass_threading)
{
  try
  {
    ParallelUniqueId puid;
    _tid = bypass_threading ? 0 : puid.id;

    pre();

    _subdomain = std::numeric_limits<SubdomainID>::max();
    typename RangeType::const_iterator el = range.begin();
    for (el = range.begin(); el != range.end(); ++el)
    {
      if (!keepGoing())
        break;

      const Elem * elem = *el;
      unsigned int cur_subdomain = elem->subdomain_id();

      _old_subdomain = _subdomain;
      _subdomain = cur_subdomain;

      if (_subdomain != _old_subdomain)
        subdomainChanged();

      onElement(elem);

      for (unsigned int side = 0; side < elem->n_sides(); side++)
      {
        std::vector<BoundaryID> boundary_ids = _mesh.getBoundaryIDs(elem, side);

        if (boundary_ids.size() > 0)
          for (std::vector<BoundaryID>::iterator it = boundary_ids.begin();
               it != boundary_ids.end();
               ++it)
            onBoundary(elem, side, *it);

        if (elem->neighbor(side) != NULL)
        {
          onInternalSide(elem, side);
          if (boundary_ids.size() > 0)
            for (std::vector<BoundaryID>::iterator it = boundary_ids.begin();
                 it != boundary_ids.end();
                 ++it)
              onInterface(elem, side, *it);
        }
      } // sides
      postElement(elem);

    } // range

    post();
  }
  catch (MooseException & e)
  {
    caughtMooseException(e);
  }
}

template <typename RangeType>
void
ThreadedElementLoopBase<RangeType>::pre()
{
}

template <typename RangeType>
void
ThreadedElementLoopBase<RangeType>::post()
{
}

template <typename RangeType>
void
ThreadedElementLoopBase<RangeType>::onElement(const Elem * /*elem*/)
{
}

template <typename RangeType>
void
ThreadedElementLoopBase<RangeType>::postElement(const Elem * /*elem*/)
{
}

template <typename RangeType>
void
ThreadedElementLoopBase<RangeType>::onBoundary(const Elem * /*elem*/,
                                               unsigned int /*side*/,
                                               BoundaryID /*bnd_id*/)
{
}

template <typename RangeType>
void
ThreadedElementLoopBase<RangeType>::onInternalSide(const Elem * /*elem*/, unsigned int /*side*/)
{
}

template <typename RangeType>
void
ThreadedElementLoopBase<RangeType>::onInterface(const Elem * /*elem*/,
                                                unsigned int /*side*/,
                                                BoundaryID /*bnd_id*/)
{
}

template <typename RangeType>
void
ThreadedElementLoopBase<RangeType>::subdomainChanged()
{
}

#endif // THREADEDELEMENTLOOPBASE_H
