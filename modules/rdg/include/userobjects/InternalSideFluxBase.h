/****************************************************************/
/* MOOSE - Multiphysics Object Oriented Simulation Environment  */
/*                                                              */
/*          All contents are licensed under LGPL V2.1           */
/*             See LICENSE for full restrictions                */
/****************************************************************/

#ifndef INTERNALSIDEFLUXBASE_H
#define INTERNALSIDEFLUXBASE_H

#include "GeneralUserObject.h"

// Forward Declarations
class InternalSideFluxBase;

template <>
InputParameters validParams<InternalSideFluxBase>();

/**
 * A base class for computing and caching internal side flux
 *
 * Notes:
 *
 *   1. When solving a system of equations, fluxes are threated as vectors of all variables.
 *      To avoid recomputing the flux for each equation, we compute it once and store it.
 *      Then, when the flux is needed by another equation,
 *      this class just returns the cached value.
 *
 *   2. Derived classes need to provide computing of the fluxes and their jacobians,
 *      i.e., they need to implement `calcFlux` and `calcJacobian`.
 */
class InternalSideFluxBase : public GeneralUserObject
{
public:
  InternalSideFluxBase(const InputParameters & parameters);

  virtual void execute();
  virtual void initialize();
  virtual void finalize();

  /**
   * Get the flux vector
   * @param[in]   iside     local  index of current side
   * @param[in]   ielem     global index of the current element
   * @param[in]   ineig     global index of the neighbor element
   * @param[in]   uvec1     vector of variables on the "left"
   * @param[in]   uvec2     vector of variables on the "right"
   * @param[in]   dwave     vector of unit normal
   */
  virtual const std::vector<Real> & getFlux(unsigned int iside,
                                            dof_id_type ielem,
                                            dof_id_type ineig,
                                            const std::vector<Real> & uvec1,
                                            const std::vector<Real> & uvec2,
                                            const RealVectorValue & dwave,
                                            THREAD_ID tid) const;

  /**
   * Solve the Riemann problem
   * @param[in]   iside     local  index of current side
   * @param[in]   ielem     global index of the current element
   * @param[in]   ineig     global index of the neighbor element
   * @param[in]   uvec1     vector of variables on the "left"
   * @param[in]   uvec2     vector of variables on the "right"
   * @param[in]   dwave     vector of unit normal
   * @param[out]  flux      flux vector across the side
   */
  virtual void calcFlux(unsigned int iside,
                        dof_id_type ielem,
                        dof_id_type ineig,
                        const std::vector<Real> & uvec1,
                        const std::vector<Real> & uvec2,
                        const RealVectorValue & dwave,
                        std::vector<Real> & flux) const = 0;

  /**
   * Get the Jacobian matrix
   * @param[in]   iside     local  index of current side
   * @param[in]   ielem     global index of the current element
   * @param[in]   ineig     global index of the neighbor element
   * @param[in]   uvec1     vector of variables on the "left"
   * @param[in]   uvec2     vector of variables on the "right"
   * @param[in]   dwave     vector of unit normal
   */
  virtual const DenseMatrix<Real> & getJacobian(Moose::DGResidualType type,
                                                unsigned int iside,
                                                dof_id_type ielem,
                                                dof_id_type ineig,
                                                const std::vector<Real> & uvec1,
                                                const std::vector<Real> & uvec2,
                                                const RealVectorValue & dwave,
                                                THREAD_ID tid) const;

  /**
   * Compute the Jacobian matrix
   * @param[in]   iside     local  index of current side
   * @param[in]   ielem     global index of the current element
   * @param[in]   ineig     global index of the neighbor element
   * @param[in]   uvec1     vector of variables on the "left"
   * @param[in]   uvec2     vector of variables on the "right"
   * @param[in]   dwave     vector of unit normal
   * @param[out]  jac1      Jacobian matrix contribution to the "left" cell
   * @param[out]  jac2      Jacobian matrix contribution to the "right" cell
   */
  virtual void calcJacobian(unsigned int iside,
                            dof_id_type ielem,
                            dof_id_type ineig,
                            const std::vector<Real> & uvec1,
                            const std::vector<Real> & uvec2,
                            const RealVectorValue & dwave,
                            DenseMatrix<Real> & jac1,
                            DenseMatrix<Real> & jac2) const = 0;

protected:
  mutable unsigned int _cached_elem_id;
  mutable unsigned int _cached_neig_id;

  /// flux vector of this side
  mutable std::vector<std::vector<Real>> _flux;
  /// Jacobian matrix contribution to the "left" cell
  mutable std::vector<DenseMatrix<Real>> _jac1;
  /// Jacobian matrix contribution to the "right" cell
  mutable std::vector<DenseMatrix<Real>> _jac2;

private:
  static Threads::spin_mutex _mutex;
};

#endif // INTERNALSIDEFLUXBASE_H
