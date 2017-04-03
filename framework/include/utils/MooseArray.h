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

#ifndef ARRAY_H
#define ARRAY_H

#include <vector>
#include "MooseError.h"

template <typename T>
class MooseArray
{
public:
  /**
   * Default constructor.  Doesn't initialize anything.
   */
  MooseArray() : _data(NULL), _size(0), _allocated_size(0) {}

  /**
   * @param size The initial size of the array.
   */
  explicit MooseArray(const unsigned int size) : _data(NULL), _allocated_size(0) { resize(size); }

  /**
   * @param size The initial size of the array.
   * @param default_value The default value to set.
   */
  explicit MooseArray(const unsigned int size, const T & default_value)
    : _data(NULL), _allocated_size(0)
  {
    resize(size);

    setAllValues(default_value);
  }

  /**
   * Sets all values of the array to the passed in value
   * @param value The value every entry of the array will be set to.
   */
  void setAllValues(const T & value);

  /**
   * Manually deallocates the data pointer
   */
  void release()
  {
    if (_data != NULL)
    {
      delete[] _data;
      _data = NULL;
      _allocated_size = _size = 0;
    }
  }

  /**
   * Change the number of elements the array can store to zero.
   *
   * Will destroy data currently in array!
   *
   * Note that this does _not_ free unused memory.
   * This is done for speed.
   */
  void clear();

  /**
   * Change the number of elements the array can store.
   *
   * Will allocate more memory if necessary.
   *
   * Can destroy data currently in array!
   * Basically, data retention not guaranteed.
   *
   * Note that this does _not_ free unused memory.
   * This is done for speed.
   */
  void resize(const unsigned int size);

  /**
   * Change the number of elements the array can store.
   *
   * Will allocate more memory if necessary.
   *
   * Can destroy data currently in array!
   * Basically, data retention not guaranteed.
   *
   * Note that this does _not_ free unused memory.
   * This is done for speed.
   *
   * Also note that default_value is only applied to NEW entries.
   */
  void resize(const unsigned int size, const T & default_value);

  /**
   * The number of elements that can currently
   * be stored in the array.
   */
  unsigned int size() const;

  /**
   * Get element i out of the array.
   */
  T & operator[](const unsigned int i);

  /**
   * Get element i out of the array.
   */
  const T & operator[](const unsigned int i) const;

  /**
   * Swap memory in this object with the 'rhs' object
   * @param rhs The object we are swapping with
   */
  void swap(MooseArray & rhs);

  /**
   * Doesn't actually make a copy of the data.
   *
   * Just makes _this_ object operate on the same data.
   *
   * Note! You can leak memory with this function if you
   * don't take care to have a copy of _this_ array somewhere
   * else.  This is because the data pointer will get overridden
   * here.
   */
  void shallowCopy(const MooseArray & rhs);

  /**
   * Doesn't actually make a copy of the data.
   *
   * Just makes _this_ object operate on the same data.
   *
   * Note! You can leak memory with this function if you
   * don't take care to have a copy of _this_ array somewhere
   * else.  This is because the data pointer will get overridden
   * here.
   *
   * I repeat!  This is an extremely dangerous function!
   *
   * DO NOT USE UNLESS YOU KNOW WHAT YOU ARE DOING!
   *
   * YOU HAVE BEEN WARNED!
   */
  void shallowCopy(std::vector<T> & rhs);

  /**
   * Actual operator=... really does make a copy of the data
   *
   * If you don't want a copy use shallowCopy()
   */
  MooseArray<T> & operator=(const std::vector<T> & rhs);

  /**
   * Actual operator=... really does make a copy of the data
   *
   * If you don't want a copy use shallowCopy()
   */
  MooseArray<T> & operator=(const MooseArray<T> & rhs);

  /**
   * Extremely inefficient way to produce a std::vector from a MooseArray!
   *
   * @return A _copy_ of the MooseArray contents.
   */
  std::vector<T> stdVector();

private:
  /// Actual data pointer.
  T * _data;

  /// The current number of elements the array can hold.
  unsigned int _size;

  /// Number of allocated memory positions for storage.
  unsigned int _allocated_size;
};

template <typename T>
inline void
MooseArray<T>::setAllValues(const T & value)
{
  for (unsigned int i = 0; i < _size; i++)
    _data[i] = value;
}

template <typename T>
inline void
MooseArray<T>::clear()
{
  _size = 0;
}

template <typename T>
inline void
MooseArray<T>::resize(const unsigned int size)
{
  if (size <= _allocated_size)
    _size = size;
  else
  {
    T * new_pointer = new T[size];
    mooseAssert(new_pointer, "Failed to allocate MooseArray memory!");

    if (_data != NULL)
      delete[] _data;
    _data = new_pointer;
    _allocated_size = size;
    _size = size;
  }
}

template <typename T>
inline void
MooseArray<T>::resize(const unsigned int size, const T & default_value)
{
  if (size > _allocated_size)
  {
    T * new_pointer = new T[size];
    mooseAssert(new_pointer, "Failed to allocate MooseArray memory!");

    if (_data != NULL)
    {
      for (unsigned int i = 0; i < _size; i++)
        new_pointer[i] = _data[i];
      delete[] _data;
    }

    _data = new_pointer;
    _allocated_size = size;
  }

  for (unsigned int i = _size; i < size; i++)
    _data[i] = default_value;

  _size = size;
}

template <typename T>
inline unsigned int
MooseArray<T>::size() const
{
  return _size;
}

template <typename T>
inline T & MooseArray<T>::operator[](const unsigned int i)
{
  mooseAssert(i < _size,
              "Access out of bounds in MooseArray (i: " << i << " size: " << _size << ")");

  return _data[i];
}

template <typename T>
inline const T & MooseArray<T>::operator[](const unsigned int i) const
{
  mooseAssert(i < _size,
              "Access out of bounds in MooseArray (i: " << i << " size: " << _size << ")");

  return _data[i];
}

template <typename T>
inline void
MooseArray<T>::swap(MooseArray & rhs)
{
  std::swap(_data, rhs._data);
  std::swap(_size, rhs._size);
  std::swap(_allocated_size, rhs._allocated_size);
}

template <typename T>
inline void
MooseArray<T>::shallowCopy(const MooseArray & rhs)
{
  _data = rhs._data;
  _size = rhs._size;
  _allocated_size = rhs._allocated_size;
}

template <typename T>
inline void
MooseArray<T>::shallowCopy(std::vector<T> & rhs)
{
  _data = &rhs[0];
  _size = rhs.size();
  _allocated_size = rhs.size();
}

template <typename T>
inline MooseArray<T> &
MooseArray<T>::operator=(const std::vector<T> & rhs)
{
  unsigned int rhs_size = rhs.size();

  resize(rhs_size);

  for (unsigned int i = 0; i < rhs_size; i++)
    _data[i] = rhs[i];

  return *this;
}

template <typename T>
inline MooseArray<T> &
MooseArray<T>::operator=(const MooseArray<T> & rhs)
{
  //  mooseError("Shouldn't be doing this!");
  resize(rhs._size);
  //  memcpy(_data,rhs._data,sizeof(T)*_size);

  for (unsigned int i = 0; i < _size; i++)
    _data[i] = rhs._data[i];

  return *this;
}

template <class T>
std::vector<T>
MooseArray<T>::stdVector()
{
  return std::vector<T>(_data, _data + _size);
}

template <class T>
void
freeDoubleMooseArray(MooseArray<MooseArray<T>> & a)
{
  for (unsigned int i = 0; i < a.size(); i++)
    a[i].release();
  a.release();
}

#endif // ARRAY_H
