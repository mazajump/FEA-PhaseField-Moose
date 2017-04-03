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

#ifndef PENETRATIONINFO_H
#define PENETRATIONINFO_H

// MOOSE includes
#include "Moose.h"
#include "DataIO.h"

// libmesh includes
#include "libmesh/vector_value.h"
#include "libmesh/point.h"

// libMesh forward declarations
namespace libMesh
{
class Node;
class Elem;
}

/**
 * Data structure used to hold penetration information
 */
class PenetrationInfo
{
public:
  PenetrationInfo(const Node * node,
                  const Elem * elem,
                  Elem * side,
                  unsigned int side_num,
                  RealVectorValue norm,
                  Real norm_distance,
                  Real tangential_distance,
                  const Point & closest_point,
                  const Point & closest_point_ref,
                  const Point & closest_point_on_face_ref,
                  std::vector<const Node *> off_edge_nodes,
                  const std::vector<std::vector<Real>> & side_phi,
                  const std::vector<std::vector<RealGradient>> & side_grad_phi,
                  const std::vector<RealGradient> & dxyzdxi,
                  const std::vector<RealGradient> & dxyzdeta,
                  const std::vector<RealGradient> & d2xyzdxideta);

  PenetrationInfo(const PenetrationInfo & p);

  PenetrationInfo();

  ~PenetrationInfo();

  enum MECH_STATUS_ENUM
  {
    MS_NO_CONTACT = 0,    // out of contact
    MS_STICKING,          // sticking (glued or frictional)
    MS_SLIPPING,          // slipping with zero frictional resistance
    MS_SLIPPING_FRICTION, // slipping with nonzero frictional resistance
    MS_CONTACT            // In contact, but unknown yet whether slipping or sticking.
  };

  bool isCaptured() const { return _mech_status != MS_NO_CONTACT; }
  void capture()
  {
    if (_mech_status == MS_NO_CONTACT)
      _mech_status = MS_CONTACT;
  }
  void release() { _mech_status = MS_NO_CONTACT; }

  const Node * _node;
  const Elem * _elem;
  Elem * _side;
  unsigned int _side_num;
  RealVectorValue _normal;
  Real _distance; // Positive distance means the node has penetrated
  Real _tangential_distance;
  Point _closest_point;
  Point _closest_point_ref;
  Point _closest_point_on_face_ref;
  std::vector<const Node *> _off_edge_nodes;
  std::vector<std::vector<Real>> _side_phi;
  std::vector<std::vector<RealGradient>> _side_grad_phi;
  std::vector<RealGradient> _dxyzdxi;
  std::vector<RealGradient> _dxyzdeta;
  std::vector<RealGradient> _d2xyzdxideta;
  const Elem * _starting_elem;
  unsigned int _starting_side_num;
  Point _starting_closest_point_ref;
  Point _incremental_slip;
  Real _accumulated_slip;
  Real _accumulated_slip_old;
  Real _frictional_energy;
  Real _frictional_energy_old;
  RealVectorValue _contact_force;
  RealVectorValue _contact_force_old;
  Real _lagrange_multiplier;
  unsigned int _locked_this_step;
  unsigned int _stick_locked_this_step;
  MECH_STATUS_ENUM _mech_status;
  MECH_STATUS_ENUM _mech_status_old;
  Point _incremental_slip_prev_iter;
  bool _slip_reversed;
  Real _slip_tol;
};

// Used for Restart
template <>
void dataStore(std::ostream & stream, PenetrationInfo *& pinfo, void * context);
template <>
void dataLoad(std::istream & stream, PenetrationInfo *& pinfo, void * context);

#endif // PENETRATIONINFO_H
