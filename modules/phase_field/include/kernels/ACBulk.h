/****************************************************************/
/* MOOSE - Multiphysics Object Oriented Simulation Environment  */
/*                                                              */
/*          All contents are licensed under LGPL V2.1           */
/*             See LICENSE for full restrictions                */
/****************************************************************/
#ifndef ACBULK_H
#define ACBULK_H

#include "KernelValue.h"
#include "JvarMapInterface.h"
#include "DerivativeMaterialInterface.h"

/**
 * This is the Allen-Cahn equation base class that implements the bulk or
 * local energy term of the equation. It is templated on the type of the mobility,
 * which can be either a number (Real) or a tensor (RealValueTensor).
 * Note that the function computeDFDOP MUST be overridden in any kernel that inherits from
 * ACBulk.
 */
template <typename T>
class ACBulk : public DerivativeMaterialInterface<JvarMapKernelInterface<KernelValue>>
{
public:
  ACBulk(const InputParameters & parameters);

  static InputParameters validParams();
  virtual void initialSetup();

protected:
  virtual Real precomputeQpResidual();
  virtual Real precomputeQpJacobian();
  virtual Real computeQpOffDiagJacobian(unsigned int jvar);

  enum PFFunctionType
  {
    Jacobian,
    Residual
  };

  virtual Real computeDFDOP(PFFunctionType type) = 0;

  /// Mobility
  const MaterialProperty<T> & _L;

  /// Mobility derivative w.r.t. order parameter
  const MaterialProperty<T> & _dLdop;

  /// Mobility derivative w.r.t coupled variables
  std::vector<const MaterialProperty<T> *> _dLdarg;
};

template <typename T>
ACBulk<T>::ACBulk(const InputParameters & parameters)
  : DerivativeMaterialInterface<JvarMapKernelInterface<KernelValue>>(parameters),
    _L(getMaterialProperty<T>("mob_name")),
    _dLdop(getMaterialPropertyDerivative<T>("mob_name", _var.name()))
{
  // Get number of coupled variables
  unsigned int nvar = _coupled_moose_vars.size();

  // reserve space for derivatives
  _dLdarg.resize(nvar);

  // Iterate over all coupled variables
  for (unsigned int i = 0; i < nvar; ++i)
    _dLdarg[i] = &getMaterialPropertyDerivative<T>("mob_name", _coupled_moose_vars[i]->name());
}

template <typename T>
InputParameters
ACBulk<T>::validParams()
{
  InputParameters params = ::validParams<KernelValue>();
  params.addClassDescription("Allen-Cahn base Kernel");
  params.addParam<MaterialPropertyName>("mob_name", "L", "The mobility used with the kernel");
  params.addCoupledVar("args", "Vector of arguments of the mobility");
  return params;
}

template <typename T>
void
ACBulk<T>::initialSetup()
{
  validateNonlinearCoupling<Real>("mob_name");
}

template <typename T>
Real
ACBulk<T>::precomputeQpResidual()
{
  // Get free energy derivative from function
  Real dFdop = computeDFDOP(Residual);

  // Set residual
  return _L[_qp] * dFdop;
}

template <typename T>
Real
ACBulk<T>::precomputeQpJacobian()
{
  // Get free energy derivative and Jacobian
  Real dFdop = computeDFDOP(Residual);

  Real JdFdop = computeDFDOP(Jacobian);

  // Set Jacobian value using product rule
  return _L[_qp] * JdFdop + _dLdop[_qp] * _phi[_j][_qp] * dFdop;
}

template <typename T>
Real
ACBulk<T>::computeQpOffDiagJacobian(unsigned int jvar)
{
  // Get the coupled variable jvar is referring to
  const unsigned int cvar = mapJvarToCvar(jvar);

  // Set off-diagonal Jacobian term from mobility derivatives
  return (*_dLdarg[cvar])[_qp] * _phi[_j][_qp] * computeDFDOP(Residual) * _test[_i][_qp];
}

#endif // ACBULK_H
