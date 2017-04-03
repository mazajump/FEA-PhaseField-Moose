/****************************************************************/
/* MOOSE - Multiphysics Object Oriented Simulation Environment  */
/*                                                              */
/*          All contents are licensed under LGPL V2.1           */
/*             See LICENSE for full restrictions                */
/****************************************************************/
#ifndef COMPUTECAPPEDWEAKPLANESTRESS_H
#define COMPUTECAPPEDWEAKPLANESTRESS_H

#include "PQPlasticModel.h"
#include "TensorMechanicsHardeningModel.h"

#include <array>

class ComputeCappedWeakPlaneStress;

template <>
InputParameters validParams<ComputeCappedWeakPlaneStress>();

/**
 * ComputeCappedWeakPlaneStress performs the return-map
 * algorithm and associated stress updates for plastic
 * models that describe capped weak-plane plasticity
 *
 * It assumes various things about the elasticity tensor, viz
 * E(i,i,j,k) = 0 except if k=j
 * E(0,0,i,j) = E(1,1,i,j)
 */
class ComputeCappedWeakPlaneStress : public PQPlasticModel
{
public:
  ComputeCappedWeakPlaneStress(const InputParameters & parameters);

protected:
  /// Hardening model for cohesion
  const TensorMechanicsHardeningModel & _cohesion;

  /// Hardening model for tan(phi)
  const TensorMechanicsHardeningModel & _tan_phi;

  /// Hardening model for tan(psi)
  const TensorMechanicsHardeningModel & _tan_psi;

  /// Hardening model for tensile strength
  const TensorMechanicsHardeningModel & _tstrength;

  /// Hardening model for compressive strength
  const TensorMechanicsHardeningModel & _cstrength;

  /// The cone vertex is smoothed by this amount
  const Real _small_smoother2;

  /// Initialise the NR proceedure from a guess coming from perfect plasticity
  const bool _perfect_guess;

  /**
   * This allows some simplification in the return-map process.
   * If the tensile yield function yf[1] >= 0 at the trial stress then
   * clearly the quadpoint is not going to fail in compression, so
   * _stress_return_type is set to no_compression, and every time
   * the compressive yield function is evaluated it is set -(very large).
   * If the compressive yield function yf[2] >= 0 at the trial stress
   * then clearly the quadpoint is not going to fail in tension, so
   * _stress_return_type is set to no_tension, and every time the
   * tensile yield function is evaluated it is set -(very large).
   * Otherwise (and at the very end after return-map) _stress_return_type
   * is set to nothing_special.
   */
  enum class StressReturnType
  {
    nothing_special,
    no_compression,
    no_tension
  } _stress_return_type;

  /// trial value of stress(0, 2)
  Real _in_trial02;

  /// trial value of stress(1, 2)
  Real _in_trial12;

  /// trial value of q
  Real _in_q_trial;

  virtual void yieldFunctionValues(Real p,
                                   Real q,
                                   const std::vector<Real> & intnl,
                                   std::vector<Real> & yf) const override;

  virtual void computeAllQ(Real p,
                           Real q,
                           const std::vector<Real> & intnl,
                           std::vector<f_and_derivs> & all_q) const override;

  virtual void consistentTangentOperator(const RankTwoTensor & stress_trial,
                                         Real p_trial,
                                         Real q_trial,
                                         const RankTwoTensor & stress,
                                         Real p,
                                         Real q,
                                         Real gaE,
                                         const f_and_derivs & smoothed_q,
                                         RankFourTensor & cto) const override;

  virtual void setStressAfterReturn(const RankTwoTensor & stress_trial,
                                    Real p_ok,
                                    Real q_ok,
                                    Real gaE,
                                    const std::vector<Real> & intnl,
                                    const f_and_derivs & smoothed_q,
                                    RankTwoTensor & stress) const override;

  virtual void preReturnMap(Real p_trial,
                            Real q_trial,
                            const RankTwoTensor & stress_trial,
                            const std::vector<Real> & intnl_old,
                            const std::vector<Real> & yf) override;

  virtual void initialiseVars(Real p_trial,
                              Real q_trial,
                              const std::vector<Real> & intnl_old,
                              Real & p,
                              Real & q,
                              Real & gaE,
                              std::vector<Real> & intnl) const override;

  virtual void setIntnlValues(Real p_trial,
                              Real q_trial,
                              Real p,
                              Real q,
                              const std::vector<Real> & intnl_old,
                              std::vector<Real> & intnl) const override;

  virtual void setIntnlDerivatives(Real p_trial,
                                   Real q_trial,
                                   Real p,
                                   Real q,
                                   const std::vector<Real> & intnl,
                                   std::vector<std::vector<Real>> & dintnl) const override;

  virtual void computePQ(const RankTwoTensor & stress, Real & p, Real & q) const override;

  virtual void initialiseReturnProcess() override;

  virtual void finaliseReturnProcess() override;

  virtual void setEppEqq(const RankFourTensor & Eijkl, Real & Epp, Real & Eqq) const override;

  virtual RankTwoTensor dpdstress(const RankTwoTensor & stress) const override;

  virtual RankFourTensor d2pdstress2(const RankTwoTensor & stress) const override;

  virtual RankTwoTensor dqdstress(const RankTwoTensor & stress) const override;

  virtual RankFourTensor d2qdstress2(const RankTwoTensor & stress) const override;
};

#endif // COMPUTECAPPEDWEAKPLANESTRESS_H
