/****************************************************************/
/* MOOSE - Multiphysics Object Oriented Simulation Environment  */
/*                                                              */
/*          All contents are licensed under LGPL V2.1           */
/*             See LICENSE for full restrictions                */
/****************************************************************/
#ifndef MATREACTION_H
#define MATREACTION_H

#include "Kernel.h"
#include "JvarMapInterface.h"
#include "DerivativeMaterialInterface.h"

// Forward Declaration
class MatReaction;

template <>
InputParameters validParams<MatReaction>();

/**
 * This kernel adds to the residual a contribution of \f$ -L*v \f$ where \f$ L \f$ is a material
 * property and \f$ v \f$ is a variable (nonlinear or coupled).
 */
class MatReaction : public DerivativeMaterialInterface<JvarMapKernelInterface<Kernel>>
{
public:
  MatReaction(const InputParameters & parameters);
  virtual void initialSetup();

protected:
  virtual Real computeQpResidual();
  virtual Real computeQpJacobian();
  virtual Real computeQpOffDiagJacobian(unsigned int jvar);

  /// is the kernel used in a coupled form?
  const bool _is_coupled;

  /**
   * Kernel variable (can be nonlinear or coupled variable)
   * (For constrained Allen-Cahn problems, v = lambda
   * where lambda is the Lagrange multiplier)
   */

  std::string _v_name;
  const VariableValue & _v;
  unsigned int _v_var;

  /// Reaction rate
  const MaterialProperty<Real> & _L;

  /// name of the order parameter (needed to retrieve the derivative material properties)
  VariableName _eta_name;

  ///  Reaction rate derivative w.r.t. order parameter
  const MaterialProperty<Real> & _dLdop;

  ///  Reaction rate derivative w.r.t. the variable being added by this kernel
  const MaterialProperty<Real> & _dLdv;

  /// number of coupled variables
  const unsigned int _nvar;

  ///  Reaction rate derivatives w.r.t. other coupled variables
  std::vector<const MaterialProperty<Real> *> _dLdarg;
};

#endif // MATREACTION_H
