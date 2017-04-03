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

#ifndef MATERIALPROPERTYSTORAGE_H
#define MATERIALPROPERTYSTORAGE_H

#include "Moose.h"
#include "MaterialProperty.h"
#include "HashMap.h"

// Forward declarations
class Material;
class MaterialData;
class QpMap;

// libMesh forward declarations
namespace libMesh
{
class QBase;
}

/**
 * Stores the stateful material properties computed by materials.
 *
 * Thread-safe
 */
class MaterialPropertyStorage
{
public:
  MaterialPropertyStorage();
  virtual ~MaterialPropertyStorage();

  void releaseProperties();

  /**
   * Creates storage for newly created elements from mesh Adaptivity.  Also, copies values from the
   * parent qps to the new children.
   *
   * Note - call this on the MaterialPropertyStorage object for the _children_ that you want to
   * project to.  ie, if you are trying
   * to project to the sides of the children, then call this on the boundary
   * MaterialPropertyStorage.  Pass in the parent
   * MaterialPropertyStorage you are projecting _from_.  ie the volume one if you are projecting to
   * "internal" child element faces.
   *
   * There are 3 cases here:
   *
   * 1. Volume to volume (parent_side = -1, child = -1, child_side = -1)
   *    Call on volume MaterialPropertyStorage and pass volume MaterialPropertyStorage for
   * parent_material_props
   *
   * 2. Parent side to child side (parent_side = 0+, child = -1, child_side = 0+) where parent_side
   * == child_side
   *    Call on boundary MaterialPropertyStorage and pass boundary MaterialPropertyStorage for
   * parent_material_props
   *
   * 3. Child side to parent volume (parent_side = -1, child = 0+, child_side = 0+)
   *    Call on boundary MaterialPropertyStorage and pass volume MaterialPropertyStorage for
   * parent_material_props
   *
   * @param refinement_map - 2D array of QpMap objects
   * @param qrule The current quadrature rule
   * @param qrule_face The current face qrule
   * @param parent_material_props The place to pull parent material property values from
   * @param child_material_data MaterialData object used for computing the data
   * @param elem The parent element that was just refined
   * @param input_parent_side - the side of the parent for which material properties are prolonged
   * @param input_child - the number of the child
   * @param input_child_side - the side on the child where material properties will be prolonged
   */
  void prolongStatefulProps(const std::vector<std::vector<QpMap>> & refinement_map,
                            QBase & qrule,
                            QBase & qrule_face,
                            MaterialPropertyStorage & parent_material_props,
                            MaterialData & child_material_data,
                            const Elem & elem,
                            const int input_parent_side,
                            const int input_child,
                            const int input_child_side);

  /**
   * Creates storage for newly created elements from mesh Adaptivity.  Also, copies values from the
   * children to the parent.
   *
   * @param coarsening_map - map from unsigned ints to QpMap's
   * @param coarsened_element_children - a pointer to a vector of coarsened element children
   * @param qrule The current quadrature rule
   * @param qrule_face The current face qrule
   * @param material_data MaterialData object used for computing the data
   * @param elem The parent element that was just refined
   * @param input_side Side of the element 'elem' (0 for volumetric material properties)
   */
  void restrictStatefulProps(const std::vector<std::pair<unsigned int, QpMap>> & coarsening_map,
                             const std::vector<const Elem *> & coarsened_element_children,
                             QBase & qrule,
                             QBase & qrule_face,
                             MaterialData & material_data,
                             const Elem & elem,
                             int input_side = -1);

  /**
   * Initialize stateful material properties
   * @param material_data MaterilData object used for computing the data
   * @param mats Materials that will compute the initial values
   * @param n_qpoints Number of quadrature points
   * @param elem Element we are on
   * @param side Side of the element 'elem' (0 for volumetric material properties)
   */
  void initStatefulProps(MaterialData & material_data,
                         const std::vector<std::shared_ptr<Material>> & mats,
                         unsigned int n_qpoints,
                         const Elem & elem,
                         unsigned int side = 0);

  /**
   * Shift the material properties in time.
   *
   * Old material properties become older, current material properties become old. Older material
   * properties are
   * reused for computing current properties. This is called when solve succeeded.
   */
  void shift();

  /**
   * Copy material properties from elem_from to elem_to. Thread safe.
   *
   * WARNING: This is not capable of copying material data to/from elements on other processors.
   *          It only works if both elem_to and elem_from are both on the local processor.
   *          We can't currently check to ensure that they're on processor here because this isn't a
   * ParallelObject.
   *
   * @param material_data MaterialData object to work with
   * @param elem_to Element to copy data to
   * @param elem_from Element to copy data from
   * @param side Side number (elemental material properties have this equal to zero)
   */
  void copy(MaterialData & material_data,
            const Elem & elem_to,
            const Elem & elem_from,
            unsigned int side,
            unsigned int n_qpoints);

  /**
   * Swap (shallow copy) material properties in MaterialData and MaterialPropertyStorage
   * Thread safe
   * @param material_data MaterialData object to work with
   * @param elem Element id
   * @param side Side number (elemental material properties have this equal to zero)
   */
  void swap(MaterialData & material_data, const Elem & elem, unsigned int side);

  /**
   * Swap (shallow copy) material properties in MaterialPropertyStorage and MaterialDat
   * Thread safe
   * @param material_data MaterialData object to work with
   * @param elem Element id
   * @param side Side number (elemental material properties have this equal to zero)
   */
  void swapBack(MaterialData & material_data, const Elem & elem, unsigned int side);

  /**
   * @return a Boolean indicating whether stateful properties exist on this material
   */
  bool hasStatefulProperties() const { return _has_stateful_props; }

  /**
   * @return a Boolean indicating whether or not this material has older properties declared
   */
  bool hasOlderProperties() const { return _has_older_prop; }

  ///@{
  /**
   * Access methods to the stored material property data
   *
   */
  HashMap<const Elem *, HashMap<unsigned int, MaterialProperties>> & props()
  {
    return *_props_elem;
  }
  HashMap<const Elem *, HashMap<unsigned int, MaterialProperties>> & propsOld()
  {
    return *_props_elem_old;
  }
  HashMap<const Elem *, HashMap<unsigned int, MaterialProperties>> & propsOlder()
  {
    return *_props_elem_older;
  }
  const HashMap<const Elem *, HashMap<unsigned int, MaterialProperties>> & props() const
  {
    return *_props_elem;
  }
  const HashMap<const Elem *, HashMap<unsigned int, MaterialProperties>> & propsOld() const
  {
    return *_props_elem_old;
  }
  const HashMap<const Elem *, HashMap<unsigned int, MaterialProperties>> & propsOlder() const
  {
    return *_props_elem_older;
  }
  MaterialProperties & props(const Elem * elem, unsigned int side)
  {
    return (*_props_elem)[elem][side];
  }
  MaterialProperties & propsOld(const Elem * elem, unsigned int side)
  {
    return (*_props_elem_old)[elem][side];
  }
  MaterialProperties & propsOlder(const Elem * elem, unsigned int side)
  {
    return (*_props_elem_older)[elem][side];
  }
  ///@}

  bool hasProperty(const std::string & prop_name) const;

  /// The addProperty functions are idempotent - calling multiple times with
  /// the same name will provide the same id and works fine.
  unsigned int addProperty(const std::string & prop_name);
  unsigned int addPropertyOld(const std::string & prop_name);
  unsigned int addPropertyOlder(const std::string & prop_name);

  std::vector<unsigned int> & statefulProps() { return _stateful_prop_id_to_prop_id; }
  const std::map<unsigned int, std::string> statefulPropNames() const { return _prop_names; }

  /// Returns the property ID for the given prop_name, adding the property and
  /// creating a new ID if it hasn't already been created.
  unsigned int getPropertyId(const std::string & prop_name);

  unsigned int retrievePropertyId(const std::string & prop_name) const;

  bool isStatefulProp(const std::string & prop_name) const
  {
    return _prop_names.count(retrievePropertyId(prop_name)) > 0;
  }

protected:
  // indexing: [element][side]->material_properties
  HashMap<const Elem *, HashMap<unsigned int, MaterialProperties>> * _props_elem;
  HashMap<const Elem *, HashMap<unsigned int, MaterialProperties>> * _props_elem_old;
  HashMap<const Elem *, HashMap<unsigned int, MaterialProperties>> * _props_elem_older;

  /// mapping from property name to property ID
  /// NOTE: this is static so the property numbering is global within the simulation (not just FEProblemBase - should be useful when we will use material properties from
  /// one FEPRoblem in another one - if we will ever do it)
  static std::map<std::string, unsigned int> _prop_ids;

  /**
   * Whether or not we have stateful properties.  This will get automatically
   * set to true if a stateful property is declared.
   */
  bool _has_stateful_props;

  /**
   * True if any material requires older properties to be computed.  This will get automatically
   * set to true if a older stateful property is declared.
   */
  bool _has_older_prop;

  /// mapping from property ID to property name
  std::map<unsigned int, std::string> _prop_names;
  /// the vector of stateful property ids (the vector index is the map to stateful prop_id)
  std::vector<unsigned int> _stateful_prop_id_to_prop_id;

  void sizeProps(MaterialProperties & mp, unsigned int size);

private:
  /// Initializes hashmap entries for element and side to proper qpoint and
  /// property count sizes.
  void initProps(MaterialData & material_data,
                 const Elem & elem,
                 unsigned int side,
                 unsigned int n_qpoints);
};

template <>
inline void
dataStore(std::ostream & stream, MaterialPropertyStorage & storage, void * context)
{
  dataStore(stream, storage.props(), context);
  dataStore(stream, storage.propsOld(), context);

  if (storage.hasOlderProperties())
    dataStore(stream, storage.propsOlder(), context);
}

template <>
inline void
dataLoad(std::istream & stream, MaterialPropertyStorage & storage, void * context)
{
  dataLoad(stream, storage.props(), context);
  dataLoad(stream, storage.propsOld(), context);

  if (storage.hasOlderProperties())
    dataLoad(stream, storage.propsOlder(), context);
}

#endif /* MATERIALPROPERTYSTORAGE_H */
