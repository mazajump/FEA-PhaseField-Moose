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

#ifndef COLUMNMAJORMATRIX_H
#define COLUMNMAJORMATRIX_H

// MOOSE includes
#include "Moose.h"      // using namespace libMesh
#include "MooseError.h" // mooseAssert

// libMesh includes
#include "libmesh/type_tensor.h"
#include "libmesh/dense_matrix.h"
#include "libmesh/dense_vector.h"

// C++ includes
#include <iomanip>

/**
 * This class defines a Tensor that can change its shape.  This means
 * a 3x3x3x3 Tensor can be represented as a 9x9 or an 81x1.  Further,
 * the values of this tensor are _COLUMN_ major ordered!
 */
class ColumnMajorMatrix
{
public:
  /**
   * Constructor that sets an initial number of entries and shape.
   * Defaults to creating the same size tensor as TensorValue
   */
  explicit ColumnMajorMatrix(const unsigned int rows = LIBMESH_DIM,
                             const unsigned int cols = LIBMESH_DIM);

  /**
   * Copy Constructor defined in terms of operator=()
   */
  ColumnMajorMatrix(const ColumnMajorMatrix & rhs);

  /**
   * Constructor that fills in the ColumnMajorMatrix with values from a libMesh TypeTensor
   */
  explicit ColumnMajorMatrix(const TypeTensor<Real> & tensor);

  explicit ColumnMajorMatrix(const DenseMatrix<Real> & rhs);

  explicit ColumnMajorMatrix(const DenseVector<Real> & rhs);

  /**
   * Constructor that takes in 3 vectors and uses them to create columns
   */
  ColumnMajorMatrix(const TypeVector<Real> & col1,
                    const TypeVector<Real> & col2,
                    const TypeVector<Real> & col3);

  /**
   * The total number of entries in the Tensor.
   * i.e. cols * rows
   */
  unsigned int numEntries() const;

  /**
   * Change the shape of the tensor.
   * Note that cols * rows should be equal to numEntries()!
   */
  void reshape(const unsigned int rows, const unsigned int cols);

  /**
   * Get the i,j entry
   * j defaults to zero so you can use it as a column vector.
   */
  Real & operator()(const unsigned int i, const unsigned int j = 0);

  /**
   * Get the i,j entry
   *
   * j defaults to zero so you can use it as a column vector.
   * This is the version used for a const ColumnMajorMatrix.
   */
  Real operator()(const unsigned int i, const unsigned int j = 0) const;

  /**
   * Print the tensor
   */
  void print();

  /**
   * Prints to file
   */
  void print_scientific(std::ostream & os);

  /**
   * Fills the passed in tensor with the values from this tensor.
   */
  void fill(TypeTensor<Real> & tensor);

  /**
   * Fills the passed in dense matrix with the values from this tensor.
   */
  void fill(DenseMatrix<Real> & rhs);

  /**
   * Fills the passed in dense vector with the values from this tensor.
   */
  void fill(DenseVector<Real> & rhs);

  /**
   * Returns a matrix that is the transpose of the matrix this
   * was called on.
   */
  ColumnMajorMatrix transpose() const;

  /**
   * Returns a matrix that is the deviatoric of the matrix this
   * was called on.
   */
  ColumnMajorMatrix deviatoric();

  /**
   * Returns a matrix that is the absolute value of the matrix this
   * was called on.
   */
  ColumnMajorMatrix abs();

  /**
   * Set the value of each of the diagonals to the passed in value.
   */
  void setDiag(Real value);

  /**
   * Add to each of the diagonals the passsed in value.
   */
  void addDiag(Real value);

  /**
   * The trace of the CMM.
   */
  Real tr() const;

  /**
   * Zero the matrix.
   */
  void zero();

  /**
   * Turn the matrix into an identity matrix.
   */
  void identity();

  /**
   * Double contraction of two matrices ie A : B = Sum(A_ab * B_ba)
   */
  Real doubleContraction(const ColumnMajorMatrix & rhs) const;

  /**
   * The Euclidean norm of the matrix.
   */
  Real norm();

  /**
   * Returns the number of rows
   */
  unsigned int n() const;

  /**
   * Returns the number of columns
   */
  unsigned int m() const;

  /**
   * Returns eigen system solve for a symmetric real matrix
   */
  void eigen(ColumnMajorMatrix & eval, ColumnMajorMatrix & evec) const;

  /**
   * Returns eigen system solve for a non-symmetric real matrix
   */
  void eigenNonsym(ColumnMajorMatrix & eval_real,
                   ColumnMajorMatrix & eval_img,
                   ColumnMajorMatrix & evec_right,
                   ColumnMajorMatrix & eve_left) const;

  /**
   * Returns matrix that is the exponential of the matrix this was called on
   */
  void exp(ColumnMajorMatrix & z) const;

  /**
   * Returns inverse of a general matrix
   */
  void inverse(ColumnMajorMatrix & invA) const;

  /**
   * Returns a reference to the raw data pointer
   */
  Real * rawData();
  const Real * rawData() const;

  /**
   * Kronecker Product
   */
  ColumnMajorMatrix kronecker(const ColumnMajorMatrix & rhs) const;

  /**
   * Sets the values in _this_ tensor to the values on the RHS.
   * Will also reshape this tensor if necessary.
   */
  ColumnMajorMatrix & operator=(const TypeTensor<Real> & rhs);

  /**
 * Sets the values in _this_ dense matrix to the values on the RHS.
 * Will also reshape this tensor if necessary.
 */
  ColumnMajorMatrix & operator=(const DenseMatrix<Real> & rhs);

  /**
 * Sets the values in _this_ dense vector to the values on the RHS.
 * Will also reshape this tensor if necessary.
 */
  ColumnMajorMatrix & operator=(const DenseVector<Real> & rhs);

  /**
   * Sets the values in _this_ tensor to the values on the RHS
   * Will also reshape this tensor if necessary.
   */
  ColumnMajorMatrix & operator=(const ColumnMajorMatrix & rhs);

  /**
   * Scalar multiplication of the ColumnMajorMatrix
   */
  ColumnMajorMatrix operator*(Real scalar) const;

  /**
   * Matrix Vector Multiplication of the libMesh TypeVector Type
   */
  ColumnMajorMatrix operator*(const TypeVector<Real> & rhs) const;

  //   /**
  //    * Matrix Vector Multiplication of the TypeTensor Product.  Note that the
  //    * Tensor type is treated as a single dimension Vector for this operation
  //    */
  //   ColumnMajorMatrix operator*(const TypeTensor<Real> & rhs) const;

  /**
   * Matrix Matrix Multiplication
   */
  ColumnMajorMatrix operator*(const ColumnMajorMatrix & rhs) const;

  /**
   * Matrix Matrix Addition
   */
  ColumnMajorMatrix operator+(const ColumnMajorMatrix & rhs) const;

  /**
   * Matrix Matrix Subtraction
   */
  ColumnMajorMatrix operator-(const ColumnMajorMatrix & rhs) const;

  /**
   * Matrix Matrix Addition plus assignment
   *
   * Note that this is faster than regular addition
   * because the result doesn't have to get copied out
   */
  ColumnMajorMatrix & operator+=(const ColumnMajorMatrix & rhs);

  /**
   * Matrix Tensor Addition Plus Assignment
   */
  ColumnMajorMatrix & operator+=(const TypeTensor<Real> & rhs);

  /**
   * Matrix Matrix Subtraction plus assignment
   *
   * Note that this is faster than regular subtraction
   * because the result doesn't have to get copied out
   */
  ColumnMajorMatrix & operator-=(const ColumnMajorMatrix & rhs);

  /**
   * Scalar addition
   */
  ColumnMajorMatrix operator+(Real scalar) const;

  /**
   * Scalar Multiplication plus assignment
   */
  ColumnMajorMatrix & operator*=(Real scalar);

  /**
   * Scalar Division plus assignment
   */
  ColumnMajorMatrix & operator/=(Real scalar);

  /**
   * Scalar Addition plus assignment
   */
  ColumnMajorMatrix & operator+=(Real scalar);

  /**
   * Equality operators
   */
  bool operator==(const ColumnMajorMatrix & rhs) const;
  bool operator!=(const ColumnMajorMatrix & rhs) const;

protected:
  unsigned int _n_rows, _n_cols, _n_entries;
  std::vector<Real> _values;
};

inline unsigned int
ColumnMajorMatrix::numEntries() const
{
  return _n_entries;
}

inline void
ColumnMajorMatrix::reshape(unsigned int rows, unsigned int cols)
{
  if (cols * rows == _n_entries)
  {
    _n_rows = rows;
    _n_cols = cols;
  }
  else
  {
    _n_rows = rows;
    _n_cols = cols;
    _n_entries = _n_rows * _n_cols;
    _values.resize(_n_entries);
  }
}

inline Real &
ColumnMajorMatrix::operator()(const unsigned int i, const unsigned int j)
{
  mooseAssert((i * j) < _n_entries, "Reference outside of ColumnMajorMatrix bounds!");

  // Row major indexing!
  return _values[(j * _n_rows) + i];
}

inline Real
ColumnMajorMatrix::operator()(const unsigned int i, const unsigned int j) const
{
  mooseAssert((i * j) < _n_entries, "Reference outside of ColumnMajorMatrix bounds!");

  // Row major indexing!
  return _values[(j * _n_rows) + i];
}

inline void
ColumnMajorMatrix::print()
{
  ColumnMajorMatrix & s = (*this);

  for (unsigned int i = 0; i < _n_rows; i++)
  {
    for (unsigned int j = 0; j < _n_cols; j++)
      Moose::out << std::setw(15) << s(i, j) << " ";

    Moose::out << std::endl;
  }
}

inline void
ColumnMajorMatrix::print_scientific(std::ostream & os)
{
  ColumnMajorMatrix & s = (*this);

  for (unsigned int i = 0; i < _n_rows; i++)
  {
    for (unsigned int j = 0; j < _n_cols; j++)
      os << std::setw(15) << std::scientific << std::setprecision(8) << s(i, j) << " ";

    os << std::endl;
  }
}

inline void
ColumnMajorMatrix::fill(TypeTensor<Real> & tensor)
{
  mooseAssert(
      LIBMESH_DIM * LIBMESH_DIM == _n_entries,
      "Cannot fill tensor!  The ColumnMajorMatrix doesn't have the same number of entries!");

  for (unsigned int j = 0, index = 0; j < LIBMESH_DIM; ++j)
    for (unsigned int i = 0; i < LIBMESH_DIM; ++i, ++index)
      tensor(i, j) = _values[index];
}

inline void
ColumnMajorMatrix::fill(DenseMatrix<Real> & rhs)
{
  mooseAssert(
      rhs.n() * rhs.m() == _n_entries,
      "Cannot fill dense matrix!  The ColumnMajorMatrix doesn't have the same number of entries!");

  for (unsigned int j = 0, index = 0; j < rhs.m(); ++j)
    for (unsigned int i = 0; i < rhs.n(); ++i, ++index)
      rhs(i, j) = _values[index];
}

inline void
ColumnMajorMatrix::fill(DenseVector<Real> & rhs)
{
  mooseAssert(_n_rows == rhs.size(), "Vectors must be the same shape for a fill!");

  for (unsigned int i = 0; i < _n_rows; ++i)
    rhs(i) = (*this)(i);
}

inline ColumnMajorMatrix
ColumnMajorMatrix::transpose() const
{
  const ColumnMajorMatrix & s = (*this);

  ColumnMajorMatrix ret_matrix(_n_cols, _n_rows);

  for (unsigned int i = 0; i < _n_rows; i++)
    for (unsigned int j = 0; j < _n_cols; j++)
      ret_matrix(j, i) = s(i, j);

  return ret_matrix;
}

inline ColumnMajorMatrix
ColumnMajorMatrix::deviatoric()
{
  ColumnMajorMatrix & s = (*this);

  ColumnMajorMatrix ret_matrix(_n_rows, _n_cols), I(_n_rows, _n_cols);

  I.identity();

  for (unsigned int i = 0; i < _n_rows; i++)
    for (unsigned int j = 0; j < _n_cols; j++)
      ret_matrix(i, j) = s(i, j) - I(i, j) * (s.tr() / 3.0);

  return ret_matrix;
}

inline ColumnMajorMatrix
ColumnMajorMatrix::abs()
{
  ColumnMajorMatrix & s = (*this);

  ColumnMajorMatrix ret_matrix(_n_rows, _n_cols);

  for (unsigned int j = 0; j < _n_cols; j++)
    for (unsigned int i = 0; i < _n_rows; i++)
      ret_matrix(i, j) = std::abs(s(i, j));

  return ret_matrix;
}

inline void
ColumnMajorMatrix::setDiag(Real value)
{
  mooseAssert(_n_rows == _n_cols, "Cannot set the diagonal of a non-square matrix!");

  for (unsigned int i = 0; i < _n_rows; i++)
    (*this)(i, i) = value;
}

inline void
ColumnMajorMatrix::addDiag(Real value)
{
  mooseAssert(_n_rows == _n_cols, "Cannot add to the diagonal of a non-square matrix!");

  for (unsigned int i = 0; i < _n_rows; i++)
    (*this)(i, i) += value;
}

inline Real
ColumnMajorMatrix::tr() const
{
  mooseAssert(_n_rows == _n_cols, "Cannot find the trace of a non-square matrix!");

  Real trace = 0;

  for (unsigned int i = 0; i < _n_rows; i++)
    trace += (*this)(i, i);

  return trace;
}

inline void
ColumnMajorMatrix::zero()
{
  for (unsigned int i = 0; i < _n_entries; i++)
    _values[i] = 0;
}

inline void
ColumnMajorMatrix::identity()
{
  mooseAssert(_n_rows == _n_cols, "Cannot set the diagonal of a non-square matrix!");

  zero();

  for (unsigned int i = 0; i < _n_rows; i++)
    (*this)(i, i) = 1;
}

inline Real
ColumnMajorMatrix::doubleContraction(const ColumnMajorMatrix & rhs) const
{
  mooseAssert(_n_rows == rhs._n_cols && _n_cols == rhs._n_rows,
              "Matrices must be the same shape for a double contraction!");

  Real value = 0;

  for (unsigned int j = 0; j < _n_cols; j++)
    for (unsigned int i = 0; i < _n_rows; i++)
      value += (*this)(i, j) * rhs(i, j);

  return value;
}

inline Real
ColumnMajorMatrix::norm()
{
  return std::sqrt(doubleContraction(*this));
}

inline unsigned int
ColumnMajorMatrix::n() const
{
  return _n_rows;
}

inline unsigned int
ColumnMajorMatrix::m() const
{
  return _n_cols;
}

inline Real *
ColumnMajorMatrix::rawData()
{
  return &_values[0];
}

inline const Real *
ColumnMajorMatrix::rawData() const
{
  return &_values[0];
}

inline ColumnMajorMatrix &
ColumnMajorMatrix::operator=(const TypeTensor<Real> & rhs)
{
  // Resize the tensor if necessary
  if ((LIBMESH_DIM * LIBMESH_DIM) != _n_entries)
  {
    _n_entries = LIBMESH_DIM * LIBMESH_DIM;
    _values.resize(_n_entries);
  }

  // Make sure the shape is correct
  reshape(LIBMESH_DIM, LIBMESH_DIM);

  ColumnMajorMatrix & s = (*this);

  // Copy the values
  for (unsigned int j = 0; j < _n_cols; j++)
    for (unsigned int i = 0; i < _n_cols; i++)
      s(i, j) = rhs(i, j);

  return *this;
}

inline ColumnMajorMatrix &
ColumnMajorMatrix::operator=(const ColumnMajorMatrix & rhs)
{
  _n_rows = rhs._n_rows;
  _n_cols = rhs._n_cols;
  _n_entries = rhs._n_entries;

  _values.resize(_n_entries);

  for (unsigned int i = 0; i < _n_entries; i++)
    _values[i] = rhs._values[i];

  return *this;
}

inline ColumnMajorMatrix ColumnMajorMatrix::operator*(Real scalar) const
{
  ColumnMajorMatrix ret_matrix(_n_rows, _n_cols);

  for (unsigned int i = 0; i < _n_entries; i++)
    ret_matrix._values[i] = _values[i] * scalar;

  return ret_matrix;
}

inline ColumnMajorMatrix ColumnMajorMatrix::operator*(const TypeVector<Real> & rhs) const
{
  mooseAssert(_n_cols == LIBMESH_DIM,
              "Cannot perform matvec operation! The column dimension of "
              "the ColumnMajorMatrix does not match the TypeVector!");

  ColumnMajorMatrix ret_matrix(_n_rows, 1);

  for (unsigned int i = 0; i < _n_rows; ++i)
    for (unsigned int j = 0; j < _n_cols; ++j)
      ret_matrix._values[i] += (*this)(i, j) * rhs(j);

  return ret_matrix;
}

// inline ColumnMajorMatrix
// ColumnMajorMatrix::operator*(const TypeTensor<Real> & rhs) const
// {
//   mooseAssert(_n_cols == LIBMESH_DIM*LIBMESH_DIM, "Cannot perform matvec operation!  The
//   ColumnMajorMatrix doesn't have the correct shape!");

//   ColumnMajorMatrix ret_matrix(_n_rows, 1);

//   for (unsigned int i=0; i<_n_rows; ++i)
//     for (unsigned int j=0; j<_n_cols; ++j)
//       // Treat the Tensor as a column major column vector
//       ret_matrix._values[i] += (*this)(i, j) * rhs(j%3, j/3);

//   return ret_matrix;
// }

inline ColumnMajorMatrix ColumnMajorMatrix::operator*(const ColumnMajorMatrix & rhs) const
{
  mooseAssert(
      _n_cols == rhs._n_rows,
      "Cannot perform matrix multiply!  The shapes of the two operands are not compatible!");

  ColumnMajorMatrix ret_matrix(_n_rows, rhs._n_cols);

  for (unsigned int i = 0; i < ret_matrix._n_rows; ++i)
    for (unsigned int j = 0; j < ret_matrix._n_cols; ++j)
      for (unsigned int k = 0; k < _n_cols; ++k)
        ret_matrix(i, j) += (*this)(i, k) * rhs(k, j);

  return ret_matrix;
}

inline ColumnMajorMatrix
ColumnMajorMatrix::operator+(const ColumnMajorMatrix & rhs) const
{
  mooseAssert(
      (_n_rows == rhs._n_rows) && (_n_cols == rhs._n_cols),
      "Cannot perform matrix addition!  The shapes of the two operands are not compatible!");

  ColumnMajorMatrix ret_matrix(_n_rows, _n_cols);

  for (unsigned int i = 0; i < _n_entries; i++)
    ret_matrix._values[i] = _values[i] + rhs._values[i];

  return ret_matrix;
}

inline ColumnMajorMatrix
ColumnMajorMatrix::operator-(const ColumnMajorMatrix & rhs) const
{
  mooseAssert(
      (_n_rows == rhs._n_rows) && (_n_cols == rhs._n_cols),
      "Cannot perform matrix addition!  The shapes of the two operands are not compatible!");

  ColumnMajorMatrix ret_matrix(_n_rows, _n_cols);

  for (unsigned int i = 0; i < _n_entries; i++)
    ret_matrix._values[i] = _values[i] - rhs._values[i];

  return ret_matrix;
}

inline ColumnMajorMatrix &
ColumnMajorMatrix::operator+=(const ColumnMajorMatrix & rhs)
{
  mooseAssert((_n_rows == rhs._n_rows) && (_n_cols == rhs._n_cols),
              "Cannot perform matrix addition and assignment!  The shapes of the two operands are "
              "not compatible!");

  for (unsigned int i = 0; i < _n_entries; i++)
    _values[i] += rhs._values[i];

  return *this;
}

inline ColumnMajorMatrix &
ColumnMajorMatrix::operator+=(const TypeTensor<Real> & rhs)
{
  mooseAssert((_n_rows == LIBMESH_DIM) && (_n_cols == LIBMESH_DIM),
              "Cannot perform matrix addition and assignment!  The shapes of the two operands are "
              "not compatible!");

  for (unsigned int j = 0; j < LIBMESH_DIM; ++j)
    for (unsigned int i = 0; i < LIBMESH_DIM; ++i)
      (*this)(i, j) += rhs(i, j);

  return *this;
}

inline ColumnMajorMatrix &
ColumnMajorMatrix::operator-=(const ColumnMajorMatrix & rhs)
{
  mooseAssert((_n_rows == rhs._n_rows) && (_n_cols == rhs._n_cols),
              "Cannot perform matrix subtraction and assignment!  The shapes of the two operands "
              "are not compatible!");

  for (unsigned int i = 0; i < _n_entries; i++)
    _values[i] -= rhs._values[i];

  return *this;
}

inline ColumnMajorMatrix
ColumnMajorMatrix::operator+(Real scalar) const
{
  ColumnMajorMatrix ret_matrix(_n_rows, _n_cols);

  for (unsigned int i = 0; i < _n_entries; i++)
    ret_matrix._values[i] = _values[i] + scalar;

  return ret_matrix;
}

inline ColumnMajorMatrix &
ColumnMajorMatrix::operator*=(Real scalar)
{
  for (unsigned int i = 0; i < _n_entries; i++)
    _values[i] *= scalar;
  return *this;
}

inline ColumnMajorMatrix &
ColumnMajorMatrix::operator/=(Real scalar)
{
  for (unsigned int i = 0; i < _n_entries; i++)
    _values[i] /= scalar;
  return *this;
}

inline ColumnMajorMatrix &
ColumnMajorMatrix::operator+=(Real scalar)
{
  for (unsigned int i = 0; i < _n_entries; i++)
    _values[i] += scalar;
  return *this;
}

inline bool
ColumnMajorMatrix::operator==(const ColumnMajorMatrix & rhs) const
{
  if (_n_entries != rhs._n_entries || _n_rows != rhs._n_rows || _n_cols != rhs._n_cols)
    return false;
  return std::equal(_values.begin(), _values.end(), rhs._values.begin());
}

inline bool
ColumnMajorMatrix::operator!=(const ColumnMajorMatrix & rhs) const
{
  return !(*this == rhs);
}

#endif // COLUMNMAJORMATRIX_H
