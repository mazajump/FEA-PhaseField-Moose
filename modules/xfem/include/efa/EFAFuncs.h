/****************************************************************/
/* MOOSE - Multiphysics Object Oriented Simulation Environment  */
/*                                                              */
/*          All contents are licensed under LGPL V2.1           */
/*             See LICENSE for full restrictions                */
/****************************************************************/

#ifndef EFAFUNCS_H
#define EFAFUNCS_H

#include <map>
#include <set>
#include <vector>
#include <algorithm>

namespace Efa
{

template <typename T>
bool
deleteFromMap(std::map<unsigned int, T *> & theMap, T * elemToDelete)
{
  bool didIt = false;
  typename std::map<unsigned int, T *>::iterator i = theMap.find(elemToDelete->id());
  if (i != theMap.end())
  {
    delete i->second;
    theMap.erase(i);
    didIt = true;
  }
  return didIt;
}

template <typename T>
unsigned int
getNewID(std::map<unsigned int, T *> & theMap)
{
  typename std::map<unsigned int, T *>::reverse_iterator last_elem = theMap.rbegin();
  unsigned int new_elem_id = 0;
  if (last_elem != theMap.rend())
    new_elem_id = last_elem->first + 1;
  return new_elem_id;
}

template <class T>
unsigned int
numCommonElems(std::set<T> & v1, std::set<T> & v2)
{
  std::vector<T> common_elems;
  std::set_intersection(
      v1.begin(), v1.end(), v2.begin(), v2.end(), std::inserter(common_elems, common_elems.end()));
  return common_elems.size();
}

template <class T>
unsigned int
numCommonElems(std::set<T> & v1, std::vector<T> & v2)
{
  std::vector<T> common_elems;
  std::set_intersection(
      v1.begin(), v1.end(), v2.begin(), v2.end(), std::inserter(common_elems, common_elems.end()));
  return common_elems.size();
}

template <class T>
std::vector<T>
getCommonElems(std::set<T> & v1, std::set<T> & v2)
{
  std::vector<T> common_elems;
  std::set_intersection(
      v1.begin(), v1.end(), v2.begin(), v2.end(), std::inserter(common_elems, common_elems.end()));
  return common_elems;
}

double linearQuadShape2D(unsigned int node_id, std::vector<double> & xi_2d);

double linearTriShape2D(unsigned int node_id, std::vector<double> & xi_2d);

double linearHexShape3D(unsigned int node_id, std::vector<double> & xi_3d);

double linearTetShape3D(unsigned int node_id, std::vector<double> & xi_3d);

} // namespace Efa

#endif
