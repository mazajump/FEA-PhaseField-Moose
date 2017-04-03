/****************************************************************/
/* MOOSE - Multiphysics Object Oriented Simulation Environment  */
/*                                                              */
/*          All contents are licensed under LGPL V2.1           */
/*             See LICENSE for full restrictions                */
/****************************************************************/

#ifndef EFAFRAGMENT2D_H
#define EFAFRAGMENT2D_H

#include "EFAFragment.h"

#include <limits>

class EFAEdge;
class EFAFace;
class EFAElement2D;

class EFAFragment2D : public EFAFragment
{
public:
  EFAFragment2D(EFAElement2D * host,
                bool create_boundary_edges,
                const EFAElement2D * from_host,
                unsigned int frag_id = std::numeric_limits<unsigned int>::max());
  EFAFragment2D(EFAElement2D * host, const EFAFace * from_face);
  ~EFAFragment2D();

private:
  EFAElement2D * _host_elem;
  std::vector<EFAEdge *> _boundary_edges;

public:
  // override pure virtual methods
  virtual void switchNode(EFANode * new_node, EFANode * old_node);
  virtual bool containsNode(EFANode * node) const;
  virtual unsigned int getNumCuts() const;
  virtual std::set<EFANode *> getAllNodes() const;
  virtual bool isConnected(EFAFragment * other_fragment) const;
  virtual void removeInvalidEmbeddedNodes(std::map<unsigned int, EFANode *> & EmbeddedNodes);

  // EFAfragment2D specific methods
  void combineTipEdges();
  bool isEdgeInterior(unsigned int edge_id) const;
  std::vector<unsigned int> getInteriorEdgeID() const;
  bool isSecondaryInteriorEdge(unsigned int edge_id) const;
  unsigned int numEdges() const;
  EFAEdge * getEdge(unsigned int edge_id) const;
  void addEdge(EFAEdge * new_edge);
  std::set<EFANode *> getEdgeNodes(unsigned int edge_id) const;
  EFAElement2D * getHostElement() const;
  std::vector<EFAFragment2D *> split();
};

#endif
