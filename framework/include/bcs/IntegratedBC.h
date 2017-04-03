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

#ifndef INTEGRATEDBC_H
#define INTEGRATEDBC_H

#include "BoundaryCondition.h"
#include "RandomInterface.h"
#include "CoupleableMooseVariableDependencyIntermediateInterface.h"
#include "MaterialPropertyInterface.h"

// Forward declarations
class IntegratedBC;
class MooseVariable;

template <>
InputParameters validParams<IntegratedBC>();

/**
 * Base class for deriving any boundary condition of a integrated type
 */
class IntegratedBC : public BoundaryCondition,
                     public RandomInterface,
                     public CoupleableMooseVariableDependencyIntermediateInterface,
                     public MaterialPropertyInterface
{
public:
  IntegratedBC(const InputParameters & parameters);

  virtual ~IntegratedBC();

  virtual void computeResidual();
  virtual void computeJacobian();
  /**
   * Computes d-ivar-residual / d-jvar...
   */
  virtual void computeJacobianBlock(unsigned int jvar);
  /**
   * Computes jacobian block with respect to a scalar variable
   * @param jvar The number of the scalar variable
   */
  void computeJacobianBlockScalar(unsigned int jvar);

  /**
   * Compute this IntegratedBC's contribution to the diagonal Jacobian entries
   * corresponding to nonlocal dofs of the variable
   */
  virtual void computeNonlocalJacobian() {}

  /**
   * Computes d-residual / d-jvar... corresponding to nonlocal dofs of the jvar
   * and stores the result in nonlocal ke
   */
  virtual void computeNonlocalOffDiagJacobian(unsigned int /* jvar */) {}

protected:
  /// current element
  const Elem *& _current_elem;
  /// Volume of the current element
  const Real & _current_elem_volume;
  /// current side of the current element
  unsigned int & _current_side;
  /// current side element
  const Elem *& _current_side_elem;
  /// Volume of the current side
  const Real & _current_side_volume;

  /// normals at quadrature points
  const MooseArray<Point> & _normals;

  /// quadrature point index
  unsigned int _qp;
  /// active quadrature rule
  QBase *& _qrule;
  /// active quadrature points
  const MooseArray<Point> & _q_point;
  /// transformed Jacobian weights
  const MooseArray<Real> & _JxW;
  /// coordinate transformation
  const MooseArray<Real> & _coord;
  /// i-th, j-th index for enumerating test and shape functions
  unsigned int _i, _j;

  // shape functions

  /// shape function values (in QPs)
  const VariablePhiValue & _phi;
  /// gradients of shape functions (in QPs)
  const VariablePhiGradient & _grad_phi;

  // test functions

  /// test function values (in QPs)
  const VariableTestValue & _test;
  /// gradients of test functions  (in QPs)
  const VariableTestGradient & _grad_test;

  // unknown

  /// the values of the unknown variable this BC is acting on
  const VariableValue & _u;
  /// the gradient of the unknown variable this BC is acting on
  const VariableGradient & _grad_u;

  /// Holds residual entries as their accumulated by this Kernel
  DenseVector<Number> _local_re;

  /// Holds residual entries as they are accumulated by this Kernel
  DenseMatrix<Number> _local_ke;

  /// The aux variables to save the residual contributions to
  bool _has_save_in;
  std::vector<MooseVariable *> _save_in;
  std::vector<AuxVariableName> _save_in_strings;

  /// The aux variables to save the diagonal Jacobian contributions to
  bool _has_diag_save_in;
  std::vector<MooseVariable *> _diag_save_in;
  std::vector<AuxVariableName> _diag_save_in_strings;

  virtual Real computeQpResidual() = 0;
  virtual Real computeQpJacobian();
  /**
   * This is the virtual that derived classes should override for computing an off-diagonal jacobian
   * component.
   */
  virtual Real computeQpOffDiagJacobian(unsigned int jvar);
};

#endif /* INTEGRATEDBC_H */
