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

#ifndef MATERIALPROPERTY_H
#define MATERIALPROPERTY_H

#include <vector>

#include "MooseArray.h"
#include "ColumnMajorMatrix.h"
#include "DataIO.h"

#include "libmesh/libmesh_common.h"
#include "libmesh/tensor_value.h"
#include "libmesh/vector_value.h"

class PropertyValue;

/**
 * Scalar Init helper routine so that specialization isn't needed for basic scalar MaterialProperty
 * types
 */
template <typename P>
PropertyValue * _init_helper(int size, PropertyValue * prop, const P * the_type);

/**
 * Vector Init helper routine so that specialization isn't needed for basic vector MaterialProperty
 * types
 */
template <typename P>
PropertyValue * _init_helper(int size, PropertyValue * prop, const std::vector<P> * the_type);

/**
 * Abstract definition of a property value.
 */
class PropertyValue
{
public:
  virtual ~PropertyValue(){};

  /**
   * String identifying the type of parameter stored.
   */
  virtual std::string type() = 0;

  /**
   * Clone this value.  Useful in copy-construction.
   */
  virtual PropertyValue * init(int size) = 0;

  virtual unsigned int size() const = 0;

  /**
   * Resizes the property to the size n
   */
  virtual void resize(int n) = 0;

  virtual void swap(PropertyValue * rhs) = 0;

  /**
   * Copy the value of a Property from one specific to a specific qp in this Property.
   *
   * @param to_qp The quadrature point in _this_ Property that you want to copy to.
   * @param rhs The Property you want to copy _from_.
   * @param from_qp The quadrature point in rhs you want to copy _from_.
   */
  virtual void
  qpCopy(const unsigned int to_qp, PropertyValue * rhs, const unsigned int from_qp) = 0;

  // save/restore in a file
  virtual void store(std::ostream & stream) = 0;
  virtual void load(std::istream & stream) = 0;
};

template <>
inline void
dataStore(std::ostream & stream, PropertyValue *& p, void * /*context*/)
{
  p->store(stream);
}

template <>
inline void
dataLoad(std::istream & stream, PropertyValue *& p, void * /*context*/)
{
  p->load(stream);
}

/**
 * Concrete definition of a parameter value
 * for a specified type.
 */
template <typename T>
class MaterialProperty : public PropertyValue
{
public:
  /// Explicitly declare a public constructor because we made the copy constructor private
  MaterialProperty() : PropertyValue() { /* */}

  virtual ~MaterialProperty() { _value.release(); }

  /**
   * @returns a read-only reference to the parameter value.
   */
  MooseArray<T> & get() { return _value; }

  /**
   * @returns a writable reference to the parameter value.
   */
  MooseArray<T> & set() { return _value; }

  /**
   * String identifying the type of parameter stored.
   */
  virtual std::string type();

  /**
   * Clone this value.  Useful in copy-construction.
   */
  virtual PropertyValue * init(int size);

  /**
   * Resizes the property to the size n
   */
  virtual void resize(int n);

  /**
   * Get element i out of the array.
   */
  T & operator[](const unsigned int i) { return _value[i]; }

  unsigned int size() const { return _value.size(); }

  /**
   * Get element i out of the array.
   */
  const T & operator[](const unsigned int i) const { return _value[i]; }

  /**
   *
   */
  virtual void swap(PropertyValue * rhs);

  /**
   * Copy the value of a Property from one specific to a specific qp in this Property.
   *
   * @param to_qp The quadrature point in _this_ Property that you want to copy to.
   * @param rhs The Property you want to copy _from_.
   * @param from_qp The quadrature point in rhs you want to copy _from_.
   */
  virtual void qpCopy(const unsigned int to_qp, PropertyValue * rhs, const unsigned int from_qp);

  /**
   * Store the property into a binary stream
   */
  virtual void store(std::ostream & stream);

  /**
   * Load the property from a binary stream
   */
  virtual void load(std::istream & stream);

  /**
   * Friend helper function to handle scalar material property initializations
   * @param size - the size corresponding to the quadrature rule
   * @param prop - The Material property that we will resize since this is not a member
   * @param the_type - This is just a template parameter used to identify the
   *                   difference between the scalar and vector template functions
   */
  template <typename P>
  friend PropertyValue * _init_helper(int size, PropertyValue * prop, const P * the_type);

  /**
   * Friend helper function to handle vector material property initializations
   * This function is an overload for the vector version
   */
  template <typename P>
  friend PropertyValue *
  _init_helper(int size, PropertyValue * prop, const std::vector<P> * the_type);

private:
  /// private copy constructor to avoid shallow copying of material properties
  MaterialProperty(const MaterialProperty<T> & /*src*/)
  {
    mooseError("Material properties must be assigned to references (missing '&')");
  }

  /// private assignment operator to avoid shallow copying of material properties
  MaterialProperty<T> & operator=(const MaterialProperty<T> & /*rhs*/)
  {
    mooseError("Material properties must be assigned to references (missing '&')");
  }

  /// Stored parameter value.
  MooseArray<T> _value;
};

// ------------------------------------------------------------
// Material::Property<> class inline methods
template <typename T>
inline std::string
MaterialProperty<T>::type()
{
  return typeid(T).name();
}

template <typename T>
inline PropertyValue *
MaterialProperty<T>::init(int size)
{
  return _init_helper(size, this, static_cast<T *>(0));
}

template <typename T>
inline void
MaterialProperty<T>::resize(int n)
{
  _value.resize(n);
}

template <typename T>
inline void
MaterialProperty<T>::swap(PropertyValue * rhs)
{
  mooseAssert(rhs != NULL, "Assigning NULL?");
  _value.swap(cast_ptr<MaterialProperty<T> *>(rhs)->_value);
}

template <typename T>
inline void
MaterialProperty<T>::qpCopy(const unsigned int to_qp,
                            PropertyValue * rhs,
                            const unsigned int from_qp)
{
  mooseAssert(rhs != NULL, "Assigning NULL?");
  _value[to_qp] = cast_ptr<const MaterialProperty<T> *>(rhs)->_value[from_qp];
}

template <typename T>
inline void
MaterialProperty<T>::store(std::ostream & stream)
{
  for (unsigned int i = 0; i < _value.size(); i++)
    storeHelper(stream, _value[i], NULL);
}

template <typename T>
inline void
MaterialProperty<T>::load(std::istream & stream)
{
  for (unsigned int i = 0; i < _value.size(); i++)
    loadHelper(stream, _value[i], NULL);
}

/**
 * Container for storing material properties
 */
class MaterialProperties : public std::vector<PropertyValue *>
{
public:
  MaterialProperties() {}

  virtual ~MaterialProperties() {}

  /**
   * Parameter map iterator.
   */
  typedef std::vector<PropertyValue *>::iterator iterator;

  /**
   * Constant parameter map iterator.
   */
  typedef std::vector<PropertyValue *>::const_iterator const_iterator;

  /**
   * Deallocates the memory
   */
  void destroy()
  {
    for (iterator k = begin(); k != end(); ++k)
      delete *k;
  }

  /**
   * Resize items in this array, i.e. the number of values needed in PropertyValue array
   * @param n_qpoints The number of values needed to store (equals the the number of quadrature
   * points per mesh element)
   */
  void resizeItems(unsigned int n_qpoints)
  {
    for (iterator k = begin(); k != end(); ++k)
      if (*k != NULL)
        (*k)->resize(n_qpoints);
  }
};

template <>
inline void
dataStore(std::ostream & stream, MaterialProperties & v, void * context)
{
  // Cast this to a vector so we can just piggy back on the vector store capability
  std::vector<PropertyValue *> & mat_props = static_cast<std::vector<PropertyValue *> &>(v);

  storeHelper(stream, mat_props, context);
}

template <>
inline void
dataLoad(std::istream & stream, MaterialProperties & v, void * context)
{
  // Cast this to a vector so we can just piggy back on the vector store capability
  std::vector<PropertyValue *> & mat_props = static_cast<std::vector<PropertyValue *> &>(v);

  loadHelper(stream, mat_props, context);
}

// Scalar Init Helper Function
template <typename P>
PropertyValue *
_init_helper(int size, PropertyValue * /*prop*/, const P *)
{
  MaterialProperty<P> * copy = new MaterialProperty<P>;
  copy->_value.resize(size, P{});
  return copy;
}

// Vector Init Helper Function
template <typename P>
PropertyValue *
_init_helper(int size, PropertyValue * /*prop*/, const std::vector<P> *)
{
  typedef MaterialProperty<std::vector<P>> PropType;
  PropType * copy = new PropType;
  copy->_value.resize(size, std::vector<P>{});

  // We don't know the size of the underlying vector at each
  // quadrature point, the user will be responsible for resizing it
  // and filling in the entries...

  // Return the copy we allocated
  return copy;
}

#endif
