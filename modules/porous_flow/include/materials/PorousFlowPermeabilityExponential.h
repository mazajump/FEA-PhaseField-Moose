/****************************************************************/
/* MOOSE - Multiphysics Object Oriented Simulation Environment  */
/*                                                              */
/*          All contents are licensed under LGPL V2.1           */
/*             See LICENSE for full restrictions                */
/****************************************************************/

#ifndef POROUSFLOWPERMEABILITYEXPONENTIAL_H
#define POROUSFLOWPERMEABILITYEXPONENTIAL_H

#include "PorousFlowPermeabilityBase.h"

// Forward Declarations
class PorousFlowPermeabilityExponential;

template <>
InputParameters validParams<PorousFlowPermeabilityExponential>();

/**
 * Material designed to provide the permeability tensor which is calculated
 * from porosity using the equation:
 * permeability = k_ijk * k, with k = BB * exp(AA * phi)
 * where k_ijk is a tensor providing the anisotropy, phi is porosity, and
 * A and B are empirical constants.
 * The user can provide input for the equation expressed in any of the
 * following 3 forms:
 * log k = A * phi + B
 * ln k = A * phi + B
 * k = B * exp(A * phi)
 * A and B are then converted to AA and BB.
 */
class PorousFlowPermeabilityExponential : public PorousFlowPermeabilityBase
{
public:
  PorousFlowPermeabilityExponential(const InputParameters & parameters);

protected:
  void computeQpProperties() override;

  /// Empirical constant A
  const Real _A;

  /// Empirical constant B
  const Real _B;

  /// Tensor multiplier k_ijk in k = k_ijk * A * phi^n / (1 - phi)^m
  const RealTensorValue _k_anisotropy;

  /// quadpoint porosity
  const MaterialProperty<Real> & _porosity_qp;

  /// d(quadpoint porosity)/d(PorousFlow variable)
  const MaterialProperty<std::vector<Real>> & _dporosity_qp_dvar;

  /// d(quadpoint porosity)/d(grad(PorousFlow variable))
  const MaterialProperty<std::vector<RealGradient>> & _dporosity_qp_dgradvar;

  /// Name of porosity-permeability relationship
  const enum PoropermFunction { log_k, ln_k, exp_k } _poroperm_function;

  /// Empirical constant AA in k = k_ijk * BB * exp(AA * phi)
  Real _AA;

  /// Empirical constant BB in k = k_ijk * BB * exp(AA * phi)
  Real _BB;
};

#endif // POROUSFLOWPERMEABILITYEXPONENTIAL_H
