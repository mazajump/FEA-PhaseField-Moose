/****************************************************************/
/* MOOSE - Multiphysics Object Oriented Simulation Environment  */
/*                                                              */
/*          All contents are licensed under LGPL V2.1           */
/*             See LICENSE for full restrictions                */
/****************************************************************/
#ifndef CHINTERFACEBASE_H
#define CHINTERFACEBASE_H

#include "Kernel.h"
#include "Material.h"
#include "JvarMapInterface.h"
#include "DerivativeKernelInterface.h"

/**
 * This is the Cahn-Hilliard equation base class that implements the interfacial or gradient energy
 * term of the equation.
 * See M.R. Tonks et al. / Computational Materials Science 51 (2012) 20-29 for more information.
 */
template <typename T>
class CHInterfaceBase : public DerivativeMaterialInterface<JvarMapKernelInterface<Kernel>>
{
public:
  CHInterfaceBase(const InputParameters & parameters);

  static InputParameters validParams();

protected:
  virtual Real computeQpResidual();
  virtual Real computeQpJacobian();
  virtual Real computeQpOffDiagJacobian(unsigned int jvar);

  const MaterialProperty<Real> & _kappa;

  ///@{
  /// Mobility material property value and concentration derivatives
  const MaterialProperty<T> & _M;
  const MaterialProperty<T> & _dMdc;
  const MaterialProperty<T> & _d2Mdc2;
  ///@}

  ///@{
  /// Variables for second order derivatives
  const VariableSecond & _second_u;
  const VariableTestSecond & _second_test;
  const VariablePhiSecond & _second_phi;
  ///@}

  ///Number of variables
  unsigned int _nvar;

  ///@{
  /// Mobility derivatives w.r.t. its dependent variables
  std::vector<const MaterialProperty<T> *> _dMdarg;
  std::vector<const MaterialProperty<T> *> _d2Mdcdarg;
  std::vector<std::vector<const MaterialProperty<T> *>> _d2Mdargdarg;
  ///@}

  /// Coupled variables used in mobility
  std::vector<const VariableGradient *> _coupled_grad_vars;
};

template <typename T>
CHInterfaceBase<T>::CHInterfaceBase(const InputParameters & parameters)
  : DerivativeMaterialInterface<JvarMapKernelInterface<Kernel>>(parameters),
    _kappa(getMaterialProperty<Real>("kappa_name")),
    _M(getMaterialProperty<T>("mob_name")),
    _dMdc(getMaterialPropertyDerivative<T>("mob_name", _var.name())),
    _d2Mdc2(getMaterialPropertyDerivative<T>("mob_name", _var.name(), _var.name())),
    _second_u(second()),
    _second_test(secondTest()),
    _second_phi(secondPhi()),
    _nvar(_coupled_moose_vars.size()),
    _dMdarg(_nvar),
    _d2Mdcdarg(_nvar),
    _d2Mdargdarg(_nvar),
    _coupled_grad_vars(_nvar)
{
  // Iterate over all coupled variables
  for (unsigned int i = 0; i < _nvar; ++i)
  {
    // Set material property values
    _dMdarg[i] = &getMaterialPropertyDerivative<T>("mob_name", _coupled_moose_vars[i]->name());
    _d2Mdcdarg[i] =
        &getMaterialPropertyDerivative<T>("mob_name", _var.name(), _coupled_moose_vars[i]->name());
    _d2Mdargdarg[i].resize(_nvar);
    for (unsigned int j = 0; j < _nvar; ++j)
      _d2Mdargdarg[i][j] = &getMaterialPropertyDerivative<T>(
          "mob_name", _coupled_moose_vars[i]->name(), _coupled_moose_vars[j]->name());

    // Set coupled variable gradients
    _coupled_grad_vars[i] = &coupledGradient("args", i);
  }
}

template <typename T>
InputParameters
CHInterfaceBase<T>::validParams()
{
  InputParameters params = ::validParams<Kernel>();
  params.addClassDescription("Gradient energy Cahn-Hilliard base Kernel");
  params.addRequiredParam<MaterialPropertyName>("kappa_name", "The kappa used with the kernel");
  params.addRequiredParam<MaterialPropertyName>("mob_name", "The mobility used with the kernel");
  params.addCoupledVar("args", "Vector of arguments of the mobility");
  return params;
}

template <typename T>
Real
CHInterfaceBase<T>::computeQpResidual()
{
  RealGradient grad_M = _dMdc[_qp] * _grad_u[_qp];
  for (unsigned int i = 0; i < _nvar; ++i)
    grad_M += (*_dMdarg[i])[_qp] * (*_coupled_grad_vars[i])[_qp];

  return _kappa[_qp] * _second_u[_qp].tr() *
         ((_M[_qp] * _second_test[_i][_qp]).tr() + grad_M * _grad_test[_i][_qp]);
}

template <typename T>
Real
CHInterfaceBase<T>::computeQpJacobian()
{
  // Set the gradient and gradient derivative values
  RealGradient grad_M = _dMdc[_qp] * _grad_u[_qp];

  RealGradient dgrad_Mdc =
      _d2Mdc2[_qp] * _phi[_j][_qp] * _grad_u[_qp] + _dMdc[_qp] * _grad_phi[_j][_qp];

  for (unsigned int i = 0; i < _nvar; ++i)
  {
    grad_M += (*_dMdarg[i])[_qp] * (*_coupled_grad_vars[i])[_qp];
    dgrad_Mdc += (*_d2Mdcdarg[i])[_qp] * _phi[_j][_qp] * (*_coupled_grad_vars[i])[_qp];
  }

  // Jacobian value using product rule
  Real value = _kappa[_qp] * _second_phi[_j][_qp].tr() *
                   ((_M[_qp] * _second_test[_i][_qp]).tr() + grad_M * _grad_test[_i][_qp]) +
               _kappa[_qp] * _second_u[_qp].tr() *
                   ((_dMdc[_qp] * _second_test[_i][_qp]).tr() * _phi[_j][_qp] +
                    dgrad_Mdc * _grad_test[_i][_qp]);

  return value;
}

template <typename T>
Real
CHInterfaceBase<T>::computeQpOffDiagJacobian(unsigned int jvar)
{
  // get the coupled variable jvar is referring to
  const unsigned int cvar = mapJvarToCvar(jvar);

  // Set the gradient derivative
  RealGradient dgrad_Mdarg = (*_d2Mdcdarg[cvar])[_qp] * _phi[_j][_qp] * _grad_u[_qp] +
                             (*_dMdarg[cvar])[_qp] * _grad_phi[_j][_qp];

  for (unsigned int i = 0; i < _nvar; ++i)
    dgrad_Mdarg += (*_d2Mdargdarg[cvar][i])[_qp] * _phi[_j][_qp] * (*_coupled_grad_vars[cvar])[_qp];

  // Jacobian value using product rule
  Real value = _kappa[_qp] * _second_u[_qp].tr() *
               (((*_dMdarg[cvar])[_qp] * _second_test[_i][_qp]).tr() * _phi[_j][_qp] +
                dgrad_Mdarg * _grad_test[_i][_qp]);

  return value;
}

#endif // CHINTERFACE_H
