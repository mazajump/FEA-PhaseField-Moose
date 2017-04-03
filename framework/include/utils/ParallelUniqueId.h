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

#ifndef PARALLELUNIQUEID_H
#define PARALLELUNIQUEID_H

#include "MooseTypes.h" // included for namespace usage and THREAD_ID

#include "libmesh/libmesh_common.h"
#include "libmesh/threads.h"

#ifdef LIBMESH_HAVE_TBB_API
#include "tbb/concurrent_queue.h"
#include "tbb/tbb_thread.h"
#elif LIBMESH_HAVE_OPENMP
#include <omp.h>
#elif LIBMESH_HAVE_PTHREAD
#include <queue>
#include "MooseException.h"
#endif

using namespace libMesh;

class ParallelUniqueId
{
public:
  ParallelUniqueId()
  {
#ifdef LIBMESH_HAVE_TBB_API
    _ids.pop(id);
#elif LIBMESH_HAVE_OPENMP
    id = omp_get_thread_num();
#elif LIBMESH_HAVE_PTHREAD
    Threads::spin_mutex::scoped_lock lock(_pthread_id_mutex);

    if (_ids.empty())
      throw MooseException(
          "No Thread IDs available in ParallelUniqueID. Did you forget to initialize()?");

    id = _ids.front();
    _ids.pop();
#else
    // There is no thread model active, so we're always on thread 0.
    id = 0;
#endif
  }

  ~ParallelUniqueId()
  {
#ifdef LIBMESH_HAVE_TBB_API
    _ids.push(id);
#elif !defined(LIBMESH_HAVE_OPENMP) && defined(LIBMESH_HAVE_PTHREAD)
    Threads::spin_mutex::scoped_lock lock(_pthread_id_mutex);

    _ids.push(id);
#endif
  }

  /**
   * Must be called by main thread _before_ any threaded computation!
   * Do NOT call _in_ a worker thread!
   */
  static void initialize()
  {
    if (!_initialized)
    {
      _initialized = true;

#if defined(LIBMESH_HAVE_TBB_API) ||                                                               \
    (!defined(LIBMESH_HAVE_OPENMP) && defined(LIBMESH_HAVE_PTHREAD))
      for (unsigned int i = 0; i < libMesh::n_threads(); ++i)
        _ids.push(i);
#endif
    }
  }

  THREAD_ID id;

private:
#ifdef LIBMESH_HAVE_TBB_API
  static tbb::concurrent_bounded_queue<unsigned int> _ids;
#elif !defined(LIBMESH_HAVE_OPENMP) && defined(LIBMESH_HAVE_PTHREAD)
  static std::queue<unsigned int> _ids;
  static Threads::spin_mutex _pthread_id_mutex;
#endif

  static bool _initialized;
};

#endif // PARALLELUNIQUEID_H
