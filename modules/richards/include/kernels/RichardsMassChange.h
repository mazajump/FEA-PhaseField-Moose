/****************************************************************/
/* MOOSE - Multiphysics Object Oriented Simulation Environment  */
/*                                                              */
/*          All contents are licensed under LGPL V2.1           */
/*             See LICENSE for full restrictions                */
/****************************************************************/

#ifndef RICHARDSMASSCHANGE
#define RICHARDSMASSCHANGE

#include "TimeDerivative.h"
#include "RichardsVarNames.h"

// Forward Declarations
class RichardsMassChange;

template <>
InputParameters validParams<RichardsMassChange>();

/**
 * Kernel = (mass - mass_old)/dt
 * where mass = porosity*density*saturation
 * This is used for the time derivative in Richards simulations
 * Note that it is not lumped, so usually you want to use RichardsLumpedMassChange instead
 */
class RichardsMassChange : public TimeDerivative
{
public:
  RichardsMassChange(const InputParameters & parameters);

protected:
  virtual Real computeQpResidual();

  virtual Real computeQpJacobian();

  virtual Real computeQpOffDiagJacobian(unsigned int jvar);

  /// holds info on the Richards variables
  const RichardsVarNames & _richards_name_UO;

  /**
   * the Richards variable number
   * eg, if richards name = 'pwater pgas poil', and this
   * kernel is for pgas, then _pvar = 1
   */
  unsigned int _pvar;

  /// whether to use SUPG for this kernel (not recommended)
  bool _use_supg;

  /// fluid mass (or fluid masses in multiphase) at quadpoints
  const MaterialProperty<std::vector<Real>> & _mass;

  /// d(fluid mass_i)/d(var_j)
  const MaterialProperty<std::vector<std::vector<Real>>> & _dmass;

  /// old value of fluid mass (or fluid masses in multiphase) at quadpoints
  const MaterialProperty<std::vector<Real>> & _mass_old;

  /// tau_SUPG
  const MaterialProperty<std::vector<RealVectorValue>> & _tauvel_SUPG;

  /// derivative of tau_SUPG wrt grad(variable)
  const MaterialProperty<std::vector<std::vector<RealTensorValue>>> & _dtauvel_SUPG_dgradv;

  /// deriv of tau_SUPG wrt variable
  const MaterialProperty<std::vector<std::vector<RealVectorValue>>> & _dtauvel_SUPG_dv;

  /**
   * Derivative of residual with respect to wrt_num Richards variable
   * This is used by both computeQpJacobian and computeQpOffDiagJacobian
   * @param wrt_num take the derivative of the residual wrt this Richards variable
   */
  Real computeQpJac(unsigned int wrt_num);
};

#endif // RICHARDSMASSCHANGE
