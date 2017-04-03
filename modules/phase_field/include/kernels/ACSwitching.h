/****************************************************************/
/* MOOSE - Multiphysics Object Oriented Simulation Environment  */
/*                                                              */
/*          All contents are licensed under LGPL V2.1           */
/*             See LICENSE for full restrictions                */
/****************************************************************/
#ifndef ACSWITCHING_H
#define ACSWITCHING_H

#include "ACBulk.h"

// Forward Declarations
class ACSwitching;

template <>
InputParameters validParams<ACSwitching>();

/**
 * ACSwitching adds terms of the form
 * \f$ dh_a/d\eta_{ai} F_a + dh_b/d\eta_{ai} F_b + ... \f$
 * where \f$ a,b,.. \f$ are the phases, \f$ h_a, h_b,..\f$ are the switching functions,
 * \f$ \eta_{ai} is the order parameter for the phase/grain that is the nonlinear variable,
 * and \f$ F_a, F_b,.. \f$ are the free energies or grand potentials.
 */
class ACSwitching : public ACBulk<Real>
{
public:
  ACSwitching(const InputParameters & parameters);

  virtual void initialSetup();

protected:
  virtual Real computeDFDOP(PFFunctionType type);
  virtual Real computeQpOffDiagJacobian(unsigned int jvar);

  const unsigned int _nvar;
  /// name of order parameter that derivatives are taken wrt (needed to retrieve the derivative material properties)
  VariableName _etai_name;

  /// Names of free energy functions for each phase \f$ F_j \f$
  std::vector<MaterialPropertyName> _Fj_names;
  unsigned int _num_j;

  /// Values of the free energy functions for each phase \f$ F_j \f$
  std::vector<const MaterialProperty<Real> *> _prop_Fj;

  /// Derivatives of the free energy functions (needed for off-diagonal Jacobians)
  std::vector<std::vector<const MaterialProperty<Real> *>> _prop_dFjdarg;

  /// switching function names
  std::vector<MaterialPropertyName> _hj_names;

  /// Derivatives of the switching functions wrt the order parameter for this kernel
  std::vector<const MaterialProperty<Real> *> _prop_dhjdetai;

  /// Second derivatives of the switching functions wrt the order parameter for this kernel
  std::vector<const MaterialProperty<Real> *> _prop_d2hjdetai2;

  /// Second derivatives of the switching functions (needed for off-diagonal Jacobians)
  std::vector<std::vector<const MaterialProperty<Real> *>> _prop_d2hjdetaidarg;
};

#endif // ACSWITCHING_H
