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

#ifndef TRACKDIRACFRONT_H
#define TRACKDIRACFRONT_H

#include "NodalUserObject.h"
#include "libmesh/id_types.h"

// Forward Declarations
class TrackDiracFront;

template <>
InputParameters validParams<TrackDiracFront>();

/**
 * This is an example NodalUserObject that will record nodal positions where the
 * variable is near 0.5 in value.  This information will then be used by
 * a DiracKernel to apply point sources at these positions.
 *
 * Note: There is some subtelty here regarding how this works in parallel.
 * If you simply recorded the XYZ positions of the nodes it is possible
 * that the Dirac system might find that positiion within an adjoining
 * element that is not owned by this processor.  That's ok - but you would
 * need to communicate all of these positions to every processor to make
 * sure that this works ok.
 *
 * A better idea is that since we are iterating over local nodes it must
 * be connected to a local element.  So record both the node AND a connected
 * local element for the position.  The DiracKernel can then use both
 * of these pieces of information to make sure that _local_ positions
 * contribute to _local_ elements... therefore no parallel communciation
 * is necessary!
 *
 * To do this we're going to use the node_to_elem_map and always find a local
 * element connected to the current node.
 */
class TrackDiracFront : public NodalUserObject
{
public:
  TrackDiracFront(const InputParameters & parameters);

  virtual void initialize();
  virtual void execute();
  virtual void threadJoin(const UserObject & y);
  virtual void finalize();

  const std::vector<std::pair<Elem *, Point>> & getDiracPoints() const { return _dirac_points; }

protected:
  /**
   * Returns an element local to this processor that is connected to
   * the current node.
   */
  Elem * localElementConnectedToCurrentNode();

  std::vector<std::pair<Elem *, Point>> _dirac_points;

  const VariableValue & _var_value;
};

#endif // TRACKDIRACFRONT_H
