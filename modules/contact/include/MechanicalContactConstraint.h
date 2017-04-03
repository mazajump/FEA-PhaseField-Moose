/****************************************************************/
/* MOOSE - Multiphysics Object Oriented Simulation Environment  */
/*                                                              */
/*          All contents are licensed under LGPL V2.1           */
/*             See LICENSE for full restrictions                */
/****************************************************************/

#ifndef MECHANICALCONTACTCONSTRAINT_H
#define MECHANICALCONTACTCONSTRAINT_H

// MOOSE includes
#include "NodeFaceConstraint.h"
#include "ContactMaster.h"

// Forward Declarations
class MechanicalContactConstraint;

template <>
InputParameters validParams<MechanicalContactConstraint>();

/**
 * A MechanicalContactConstraint forces the value of a variable to be the same on both sides of an
 * interface.
 */
class MechanicalContactConstraint : public NodeFaceConstraint
{
public:
  MechanicalContactConstraint(const InputParameters & parameters);
  virtual ~MechanicalContactConstraint() {}

  virtual void timestepSetup();
  virtual void jacobianSetup();

  virtual void updateContactSet(bool beginning_of_step = false);

  virtual Real computeQpSlaveValue();

  virtual Real computeQpResidual(Moose::ConstraintType type);

  /**
   * Computes the jacobian for the current element.
   */
  virtual void computeJacobian();

  /**
   * Compute off-diagonal Jacobian entries
   * @param jvar The index of the coupled variable
   */
  virtual void computeOffDiagJacobian(unsigned int jvar);

  virtual Real computeQpJacobian(Moose::ConstraintJacobianType type);

  /**
   * Compute off-diagonal Jacobian entries
   * @param type The type of coupling
   * @param jvar The index of the coupled variable
   */
  virtual Real computeQpOffDiagJacobian(Moose::ConstraintJacobianType type, unsigned int jvar);

  /**
   * Get the dof indices of the nodes connected to the slave node for a specific variable
   * @param var_num The number of the variable for which dof indices are gathered
   * @return bool indicating whether the coupled variable is one of the displacement variables
   */
  virtual void getConnectedDofIndices(unsigned int var_num);

  /**
   * Determine whether the coupled variable is one of the displacement variables,
   * and find its component
   * @param var_num The number of the variable to be checked
   * @param component The component index computed in this routine
   * @return bool indicating whether the coupled variable is one of the displacement variables
   */
  bool getCoupledVarComponent(unsigned int var_num, unsigned int & component);

  virtual bool addCouplingEntriesToJacobian() { return _master_slave_jacobian; }

  bool shouldApply();
  void computeContactForce(PenetrationInfo * pinfo);

protected:
  Real nodalArea(PenetrationInfo & pinfo);
  Real getPenalty(PenetrationInfo & pinfo);

  const unsigned int _component;
  ContactModel _model;
  const ContactFormulation _formulation;
  const bool _normalize_penalty;

  const Real _penalty;
  const Real _friction_coefficient;
  const Real _tension_release;
  const Real _capture_tolerance;
  const unsigned int _stick_lock_iterations;
  const Real _stick_unlock_factor;
  bool _update_contact_set;

  NumericVector<Number> & _residual_copy;
  //  std::map<Point, PenetrationInfo *> _point_to_info;

  const unsigned int _mesh_dimension;

  std::vector<unsigned int> _vars;

  MooseVariable * _nodal_area_var;
  SystemBase & _aux_system;
  const NumericVector<Number> * _aux_solution;

  /// Whether to include coupling between the master and slave nodes in the Jacobian
  const bool _master_slave_jacobian;
  /// Whether to include coupling terms with the nodes connected to the slave nodes in the Jacobian
  const bool _connected_slave_nodes_jacobian;
  /// Whether to include coupling terms with non-displacement variables in the Jacobian
  const bool _non_displacement_vars_jacobian;
};

#endif
