/****************************************************************/
/* MOOSE - Multiphysics Object Oriented Simulation Environment  */
/*                                                              */
/*          All contents are licensed under LGPL V2.1           */
/*             See LICENSE for full restrictions                */
/****************************************************************/

#ifndef WATER97FLUIDPROPERTIES_H
#define WATER97FLUIDPROPERTIES_H

#include "SinglePhaseFluidPropertiesPT.h"

class Water97FluidProperties;

template <>
InputParameters validParams<Water97FluidProperties>();

/**
 * Water (H2O) fluid properties as a function of pressure (Pa)
 * and temperature (K) from IAPWS-IF97:
 * Revised Release on the IAPWS Industrial Formulation 1997 for
 * the Thermodynamic Properties of Water and Steam.
 *
 * To avoid iteration in Region 3, the backwards equations from:
 * Revised Supplementary Release on Backward Equations for Specific Volume
 * as a Function of Pressure and Temperature v(p,T) for Region 3 of the
 * IAPWS Industrial Formulation 1997 for the Thermodynamic Properties of Water
 * and Steam are implemented.
 *
 * Water viscosity as a function of density (kg/m^3) and temperature (K) from:
 * Release on the IAPWS Formulation 2008 for the Viscosity of Ordinary Water Substance.
 *
 * Thermal conductivity as a function of density (kg/m^3) and temperature (K) from:
 * Revised Release on the IAPS Formulation 1985 for the Thermal Conductivity of
 * Ordinary Water Substance
 */
class Water97FluidProperties : public SinglePhaseFluidPropertiesPT
{
public:
  Water97FluidProperties(const InputParameters & parameters);
  virtual ~Water97FluidProperties();

  /**
   * Water molar mass
   * @return molar mass (kg/mol)
   */
  virtual Real molarMass() const override;

  /**
   * Water critical pressure
   * @return critical pressure (Pa)
   */
  virtual Real criticalPressure() const;

  /**
   * Water critical temperature
   * @return critical temperature (K)
   */
  virtual Real criticalTemperature() const;

  /**
   * Water critical density
   * @return critical density (kg/m^3)
   */
  virtual Real criticalDensity() const;

  /**
   * Water triple point pressure
   * @return triple point pressure (Pa)
   */
  virtual Real triplePointPressure() const;

  /**
   * Water triple point temperature
   * @return triple point temperature (K)
   */
  virtual Real triplePointTemperature() const;

  /**
   * Density as a function of pressure and temperature
   *
   * @param pressure fluid pressure (Pa)
   * @param temperature fluid temperature (K)
   * @return density (kg/m^3)
   */
  virtual Real rho(Real pressure, Real temperature) const override;

  /**
   * Density as a function of pressure and temperature, and
   * derivatives wrt pressure and temperature
   *
   * @param pressure fluid pressure (Pa)
   * @param temperature fluid temperature (K)
   * @param[out] rho density (kg/m^3)
   * @param[out] drho_dp derivative of density wrt pressure
   * @param[out] drho_dT derivative of density wrt temperature
   */
  virtual void rho_dpT(
      Real pressure, Real temperature, Real & rho, Real & drho_dp, Real & drho_dT) const override;

  /**
   * Internal energy from pressure and temperature
   *
   * @param pressure fluid pressure (Pa)
   * @param temperature fluid temperature (K)
   * @return internal enerygy (J/kg)
   */
  virtual Real e(Real pressure, Real temperature) const override;

  /**
   * Internal energy and its derivatives wrt pressure and temperature
   *
   * @param pressure fluid pressure (Pa)
   * @param temperature fluid temperature (K)
   * @param[out] e internal energy (J/kg)
   * @param[out] de_dp derivative of internal energy wrt pressure
   * @param[out] de_dT derivative of internal energy wrt temperature
   */
  virtual void
  e_dpT(Real pressure, Real temperature, Real & e, Real & de_dp, Real & de_dT) const override;

  /**
   * Density and internal energy and their derivatives wrt pressure and temperature
   *
   * @param pressure fluid pressure (Pa)
   * @param temperature fluid temperature (K)
   * @param[out] rho density (kg/m^3)
   * @param[out] drho_dp derivative of density wrt pressure
   * @param[out] drho_dT derivative of density wrt temperature
   * @param[out] e internal energy (J/kg)
   * @param[out] de_dp derivative of internal energy wrt pressure
   * @param[out] de_dT derivative of internal energy wrt temperature
   */
  virtual void rho_e_dpT(Real pressure,
                         Real temperature,
                         Real & rho,
                         Real & drho_dp,
                         Real & drho_dT,
                         Real & e,
                         Real & de_dp,
                         Real & de_dT) const override;

  /**
   * Speed of sound
   *
   * @param pressure fluid pressure (Pa)
   * @param temperature fluid temperature (K)
   * @return speed of sound (m/s)
   */
  virtual Real c(Real pressure, Real temperature) const override;

  /**
   * Isobaric specific heat capacity as a function of pressure and temperature
   *
   * @param pressure fluid pressure (Pa)
   * @param temperature fluid temperature (K)
   * @return cp (J/kg/K)
   */
  virtual Real cp(Real pressure, Real temperature) const override;

  /**
   * Isochoric specific heat
   *
   * @param pressure fluid pressure (Pa)
   * @param temperature fluid temperature (K)
   * @return cv (J/kg/K)
   */
  virtual Real cv(Real pressure, Real temperature) const override;

  /**
   * Water viscosity as a function of density and temperature.
   * Eq. (10) from Release on the IAPWS Formulation 2008 for the
   * Viscosity of Ordinary Water Substance.
   * Note: critical enhancement is NOT implemented
   *
   * @param density fluid density (kg/m^3)
   * @param temperature fluid temperature (K)
   * @return viscosity (Pa.s)
   */
  virtual Real mu(Real density, Real temperature) const override;

  /**
   * Water viscosity and derivatives wrt density and temperature
   *
   * @param density fluid density (kg/m^3)
   * @param temperature fluid temperature (K)
   * @param[out] mu viscosity (Pa.s)
   * @param[out] dmu_drho derivative of viscosity wrt density
   * @param[out] dmu_dT derivative of viscosity wrt temperature
   */
  virtual void mu_drhoT(
      Real density, Real temperature, Real & mu, Real & dmu_drho, Real & dmu_dT) const override;

  /**
   * Thermal conductivity as a function of density and temperature
   * From: Release on the IAPWS formulation 2011 for the Thermal Conductivity of Ordinary
   *
   * @param density fluid density (kg/m^3)
   * @param temperature fluid temperature (K)
   * @return k (W/m/K)
   */
  virtual Real k(Real density, Real temperature) const override;

  /**
   * Specific entropy as a function of pressure and temperature
   *
   * @param pressure fluid pressure (Pa)
   * @param temperature fluid temperature (K)
   * @return s (J/kg/K)
   */
  virtual Real s(Real pressure, Real temperature) const override;

  /**
   * Enthalpy as a function of pressure and temperature
   *
   * @param pressure fluid pressure (Pa)
   * @param temperature fluid temperature (K)
   * @return h (J/kg)
   */
  virtual Real h(Real pressure, Real temperature) const override;

  /**
   * Enthalpy and its derivatives wrt pressure and temperature
   *
   * @param pressure fluid pressure (Pa)
   * @param temperature fluid temperature (K)
   * @param[out] h (J/kg)
   * @param[out] dh_dp derivative of enthalpy wrt pressure
   * @param[out] dh_dT derivative of enthalpy wrt temperature
   */
  virtual void
  h_dpT(Real pressure, Real temperature, Real & h, Real & dh_dp, Real & dh_dT) const override;

  /**
   * Thermal expansion coefficient
   *
   * @param pressure fluid pressure (Pa)
   * @param temperature fluid temperature (K)
   * @return beta (1/K)
   */
  virtual Real beta(Real pressure, Real temperature) const override;

  /**
   * Saturation pressure as a function of temperature.
   *
   * Eq. (30) from Revised Release on the IAPWS Industrial
   * Formulation 1997 for the Thermodynamic Properties of Water
   * and Steam
   *
   * Valid for 273.15 K <= t <= 647.096 K
   *
   * @param temperature water temperature (K)
   * @return saturation pressure (Pa)
   */
  Real pSat(Real temperature) const;

  /**
   * Saturation pressure as a function of temperature and derivative
   * wrt temperature.
   *
   * Eq. (30) from Revised Release on the IAPWS Industrial
   * Formulation 1997 for the Thermodynamic Properties of Water
   * and Steam
   *
   * Valid for 273.15 K <= t <= 647.096 K
   *
   * @param temperature water temperature (K)
   * @param[out] saturation pressure (Pa)
   * @param[out] derivative of saturation pressure wrt temperature (Pa/K)
   */
  void pSat_dT(Real temperature, Real & psat, Real & dpsat_dT) const;

  /**
   * Saturation temperature as a function of pressure.
   *
   * Eq. (31) from Revised Release on the IAPWS Industrial
   * Formulation 1997 for the Thermodynamic Properties of Water
   * and Steam
   *
   * Valid for 611.213 Pa <= p <= 22.064 MPa
   *
   * @param pressure water pressure (Pa)
   * @return saturation temperature (K)
   */
  Real TSat(Real pressure) const;

  /**
   * Auxillary equation for the boundary between regions 2 and 3.
   *
   * Eq. (5) from Revised Release on the IAPWS Industrial
   * Formulation 1997 for the Thermodynamic Properties of Water
   * and Steam
   *
   * @param temperature water temperature (K)
   * @return pressure (Pa) on the boundary between region 2 and 3
   */
  Real b23p(Real temperature) const;

  /**
   * Auxillary equation for the boundary between regions 2 and 3.
   *
   * Eq. (6) from Revised Release on the IAPWS Industrial
   * Formulation 1997 for the Thermodynamic Properties of Water
   * and Steam
   *
   * @param pressure water pressure (Pa)
   * @return temperature (K) on the boundary between regions 2 and 3
   */
  Real b23T(Real pressure) const;

  /**
   * Determines the phase region that the given pressure and temperature values
   * lie in.
   *
   * @param pressure water pressure (Pa)
   * @param temperature water temperature (K)
   * @return region phase region index
   */
  unsigned int inRegion(Real pressure, Real temperature) const;

  /**
   * Gibbs free energy in Region 1 - single phase liquid region
   *
   * From Eq. (7) From Revised Release on the IAPWS Industrial
   * Formulation 1997 for the Thermodynamic Properties of Water
   * and Steam, IAPWS 2007.
   *
   * @param pi reduced pressure (-)
   * @param tau reduced temperature (-)
   * @return Gibbs free energy (-)
   */
  Real gamma1(Real pi, Real tau) const;

  /**
   * Derivative of Gibbs free energy in Region 1 wrt pi
   *
   * @param pi reduced pressure (-)
   * @param tau reduced temperature (-)
   * @return derivative of Gibbs free energy wrt pi (-)
   */
  Real dgamma1_dpi(Real pi, Real tau) const;

  /**
   * Second derivative of Gibbs free energy in Region 1 wrt pi
   *
   * @param pi reduced pressure (-)
   * @param tau reduced temperature (-)
   * @return second derivative of Gibbs free energy wrt pi (-)
   */
  Real d2gamma1_dpi2(Real pi, Real tau) const;

  /**
   * Derivative of Gibbs free energy in Region 1 wrt tau
   *
   * @param pi reduced pressure (-)
   * @param tau reduced temperature (-)
   * @return derivative of Gibbs free energy wrt tau (-)
   */
  Real dgamma1_dtau(Real pi, Real tau) const;

  /**
   * Second derivative of Gibbs free energy in Region 1 wrt tau
   *
   * @param pi reduced pressure (-)
   * @param tau reduced temperature (-)
   * @return second derivative of Gibbs free energy wrt tau (-)
   */
  Real d2gamma1_dtau2(Real pi, Real tau) const;

  /**
   * Second derivative of Gibbs free energy in Region 1 wrt pi and tau
   *
   * @param pi reduced pressure (-)
   * @param tau reduced temperature (-)
   * @return second derivative of Gibbs free energy wrt pi and tau (-)
   */
  Real d2gamma1_dpitau(Real pi, Real tau) const;

  /**
   * Gibbs free energy in Region 2 - superheated steam
   *
   * From Eq. (15) From Revised Release on the IAPWS Industrial
   * Formulation 1997 for the Thermodynamic Properties of Water
   * and Steam, IAPWS 2007.
   *
   * @param pi reduced pressure (-)
   * @param tau reduced temperature (-)
   * @return Gibbs free energy (-)
   */
  Real gamma2(Real pi, Real tau) const;

  /**
   * Derivative of Gibbs free energy in Region 2 wrt pi
   *
   * @param pi reduced pressure (-)
   * @param tau reduced temperature (-)
   * @return derivative of Gibbs free energy wrt pi (-)
   */
  Real dgamma2_dpi(Real pi, Real tau) const;

  /**
   * Second derivative of Gibbs free energy in Region 2 wrt pi
   *
   * @param pi reduced pressure (-)
   * @param tau reduced temperature (-)
   * @return second derivative of Gibbs free energy wrt pi (-)
   */
  Real d2gamma2_dpi2(Real pi, Real tau) const;

  /**
   * Derivative of Gibbs free energy in Region 2 wrt tau
   *
   * @param pi reduced pressure (-)
   * @param tau reduced temperature (-)
   * @return derivative of Gibbs free energy wrt tau (-)
   */
  Real dgamma2_dtau(Real pi, Real tau) const;

  /**
   * Second derivative of Gibbs free energy in Region 2 wrt tau
   *
   * @param pi reduced pressure (-)
   * @param tau reduced temperature (-)
   * @return second derivative of Gibbs free energy wrt tau (-)
   */
  Real d2gamma2_dtau2(Real pi, Real tau) const;

  /**
   * Second derivative of Gibbs free energy in Region 2 wrt pi and tau
   *
   * @param pi reduced pressure (-)
   * @param tau reduced temperature (-)
   * @return second derivative of Gibbs free energy wrt pi and tau (-)
   */
  Real d2gamma2_dpitau(Real pi, Real tau) const;

  /**
   * Helmholtz free energy in Region 3
   *
   * From Eq. (28) From Revised Release on the IAPWS Industrial
   * Formulation 1997 for the Thermodynamic Properties of Water
   * and Steam, IAPWS 2007.
   *
   * @param delta reduced density (-)
   * @param tau reduced temperature (-)
   * @return Helmholtz free energy (-)
   */
  Real phi3(Real delta, Real tau) const;

  /**
   * Derivative of Helmholtz free energy in Region 3 wrt delta
   *
   * @param delta reduced density (-)
   * @param tau reduced temperature (-)
   * @return derivative of Helmholtz free energy wrt delta (-)
   */
  Real dphi3_ddelta(Real delta, Real tau) const;

  /**
   * Second derivative of Helmholtz free energy in Region 3 wrt delta
   *
   * @param delta reduced density (-)
   * @param tau reduced temperature (-)
   * @return second derivative of Helmholtz free energy wrt delta (-)
   */
  Real d2phi3_ddelta2(Real delta, Real tau) const;

  /**
   * Derivative of Helmholtz free energy in Region 3 wrt tau
   *
   * @param delta reduced density (-)
   * @param tau reduced temperature (-)
   * @return derivative of Helmholtz free energy wrt tau (-)
   */
  Real dphi3_dtau(Real delta, Real tau) const;

  /**
   * Second derivative of Helmholtz free energy in Region 3 wrt tau
   *
   * @param delta reduced density (-)
   * @param tau reduced temperature (-)
   * @return second derivative of Helmholtz free energy wrt tau (-)
   */
  Real d2phi3_dtau2(Real delta, Real tau) const;

  /**
   * Second derivative of Helmholtz free energy in Region 3 wrt delta and tau
   *
   * @param delta reduced density (-)
   * @param tau reduced temperature (-)
   * @return second derivative of Helmholtz free energy wrt delta and tau (-)
   */
  Real d2phi3_ddeltatau(Real delta, Real tau) const;

  /**
   * Gibbs free energy in Region 5
   *
   * From Eq. (32) From Revised Release on the IAPWS Industrial
   * Formulation 1997 for the Thermodynamic Properties of Water
   * and Steam, IAPWS 2007.
   *
   * @param pi reduced pressure (-)
   * @param tau reduced temperature (-)
   * @return Gibbs free energy (-)
   */
  Real gamma5(Real pi, Real tau) const;

  /**
   * Derivative of Gibbs free energy in Region 5 wrt pi
   *
   * @param pi reduced pressure (-)
   * @param tau reduced temperature (-)
   * @return derivative of Gibbs free energy wrt pi (-)
   */
  Real dgamma5_dpi(Real pi, Real tau) const;

  /**
   * Second derivative of Gibbs free energy in Region 5 wrt pi
   *
   * @param pi reduced pressure (-)
   * @param tau reduced temperature (-)
   * @return second derivative of Gibbs free energy wrt pi (-)
   */
  Real d2gamma5_dpi2(Real pi, Real tau) const;

  /**
   * Derivative of Gibbs free energy in Region 5 wrt tau
   *
   * @param pi reduced pressure (-)
   * @param tau reduced temperature (-)
   * @return derivative of Gibbs free energy wrt tau (-)
   */
  Real dgamma5_dtau(Real pi, Real tau) const;

  /**
   * Second derivative of Gibbs free energy in Region 5 wrt tau
   *
   * @param pi reduced pressure (-)
   * @param tau reduced temperature (-)
   * @return second derivative of Gibbs free energy wrt tau (-)
   */
  Real d2gamma5_dtau2(Real pi, Real tau) const;

  /**
   * Second derivative of Gibbs free energy in Region 5 wrt pi and tau
   *
   * @param pi reduced pressure (-)
   * @param tau reduced temperature (-)
   * @return second derivative of Gibbs free energy wrt pi and tau (-)
   */
  Real d2gamma5_dpitau(Real pi, Real tau) const;

  /**
   * Provides the correct subregion index for a (P,T) point in
   * region 3. From Revised Supplementary Release on Backward Equations for
   * Specific Volume as a Function of Pressure and Temperature v(p,T)
   * for Region 3 of the IAPWS Industrial Formulation 1997 for the
   * Thermodynamic Properties of Water and Steam
   *
   * @param pressure water pressure (Pa)
   * @param temperature water temperature (K)
   * @return subregion index
   */
  unsigned int subregion3(Real pressure, Real temperature) const;

  /**
   * Specific volume in all subregions of region 3 EXCEPT subregion n (13).
   *
   * @param pi scaled water pressure
   * @param theta scaled water temperature
   * @param a to e constants
   * @param sid subregion ID of the subregion
   * @return volume water specific volume (m^3/kg)
   */
  Real subregionVolume(
      Real pi, Real theta, Real a, Real b, Real c, Real d, Real e, unsigned int sid) const;

  /**
   * Density function for Region 3 - supercritical water and steam
   *
   * To avoid iteration, use the backwards equations for region 3
   * from Revised Supplementary Release on Backward Equations for
   * Specific Volume as a Function of Pressure and Temperature v(p,T)
   * for Region 3 of the IAPWS Industrial Formulation 1997 for the
   * Thermodynamic Properties of Water and Steam.
   *
   * @param pressure water pressure (Pa)
   * @param temperature water temperature (K)
   * @return density (kg/m^3) in region 3
   */
  Real densityRegion3(Real pressure, Real temperature) const;

  /**
   * Henry's law constant
   * Note: not implemented in this fluid property
   */
  virtual Real henryConstant(Real temperature) const override;

  /**
   * Henry's law constant and derivative wrt temperature
   * Note: not implemented in this fluid property
   */
  virtual void henryConstant_dT(Real temperature, Real & Kh, Real & dKh_dT) const override;

protected:
  /// Water molar mass (kg/mol)
  const Real _Mh2o;
  /// Specific gas constant for H2O (universal gas constant / molar mass of water - J/kg/K)
  const Real _Rw;
  /// Critical pressure (Pa)
  const Real _p_critical;
  /// Critical temperature (K)
  const Real _T_critical;
  /// Critical density (kg/m^3)
  const Real _rho_critical;
  /// Triple point pressure (Pa)
  const Real _p_triple;
  /// Triple point temperature (K)
  const Real _T_triple;
  /// Enum of subregion ids for region 3
  enum subregionEnum
  {
    AB,
    CD,
    GH,
    IJ,
    JK,
    MN,
    OP,
    QU,
    RX,
    UV,
    WX,
    EF
  };

  /**
   * Boundaries between subregions in region 3.
   * From Revised Supplementary Release on Backward Equations for
   * Specific Volume as a Function of Pressure and Temperature v(p,T)
   * for Region 3 of the IAPWS Industrial Formulation 1997 for the
   * Thermodynamic Properties of Water and Steam
   *
   * @param pressure water pressure (Pa)
   * @param xy string to select the boundary between two subregions
   * @return temperature (K) along the boundary
   */
  Real tempXY(Real pressure, subregionEnum xy) const;

  /**
   * Reference constants used in to calculate thermophysical properties of water.
   * Taken from Revised Release on the IAPWS Industrial Formulation 1997 for the Thermodynamic
   * Properties of Water and Steam and from Revised Supplementary Release on Backward Equations for
   * Specific Volume as a Function of Pressure and Temperature v(p,T) for Region 3 of the IAPWS
   * Industrial Formulation 1997 for the Thermodynamic Properties of Water and Steam
   */

  /// Constants for region 1
  const std::vector<Real> _n1{
      0.14632971213167e0,    -0.84548187169114e0,  -0.37563603672040e1,   0.33855169168385e1,
      -0.95791963387872e0,   0.15772038513228e0,   -0.16616417199501e-1,  0.81214629983568e-3,
      0.28319080123804e-3,   -0.60706301565874e-3, -0.18990068218419e-1,  -0.32529748770505e-1,
      -0.21841717175414e-1,  -0.52838357969930e-4, -0.47184321073267e-3,  -0.30001780793026e-3,
      0.47661393906987e-4,   -0.44141845330846e-5, -0.72694996297594e-15, -0.31679644845054e-4,
      -0.28270797985312e-5,  -0.85205128120103e-9, -0.22425281908000e-5,  -0.65171222895601e-6,
      -0.14341729937924e-12, -0.40516996860117e-6, -0.12734301741641e-8,  -0.17424871230634e-9,
      -0.68762131295531e-18, 0.14478307828521e-19, 0.26335781662795e-22,  -0.11947622640071e-22,
      0.18228094581404e-23,  -0.93537087292458e-25};

  const std::vector<int> _I1{0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1,  1,  1,  2,  2,  2,
                             2, 2, 3, 3, 3, 4, 4, 4, 5, 8, 8, 21, 23, 29, 30, 31, 32};

  const std::vector<int> _J1{-2, -1, 0,   1,  2,   3,   4,   5,   -9,  -7, -1, 0,
                             1,  3,  -3,  0,  1,   3,   17,  -4,  0,   6,  -5, -2,
                             10, -8, -11, -6, -29, -31, -38, -39, -40, -41};

  /// Constants for region 2
  const std::vector<Real> _n02{-0.96927686500217e1,
                               0.10086655968018e2,
                               -0.56087911283020e-2,
                               0.71452738081455e-1,
                               -0.40710498223928e0,
                               0.14240819171444e1,
                               -0.43839511319450e1,
                               -0.28408632460772e0,
                               0.21268463753307e-1};

  const std::vector<Real> _n2{
      -0.17731742473213e-2, -0.17834862292358e-1,  -0.45996013696365e-1,  -0.57581259083432e-1,
      -0.50325278727930e-1, -0.33032641670203e-4,  -0.18948987516315e-3,  -0.39392777243355e-2,
      -0.43797295650573e-1, -0.26674547914087e-4,  0.20481737692309e-7,   0.43870667284435e-6,
      -0.32277677238570e-4, -0.15033924542148e-2,  -0.40668253562649e-1,  -0.78847309559367e-9,
      0.12790717852285e-7,  0.48225372718507e-6,   0.22922076337661e-5,   -0.16714766451061e-10,
      -0.21171472321355e-2, -0.23895741934104e2,   -0.59059564324270e-17, -0.12621808899101e-5,
      -0.38946842435739e-1, 0.11256211360459e-10,  -0.82311340897998e1,   0.19809712802088e-7,
      0.10406965210174e-18, -0.10234747095929e-12, -0.10018179379511e-8,  -0.80882908646985e-10,
      0.10693031879409e0,   -0.33662250574171e0,   0.89185845355421e-24,  0.30629316876232e-12,
      -0.42002467698208e-5, -0.59056029685639e-25, 0.37826947613457e-5,   -0.12768608934681e-14,
      0.73087610595061e-28, 0.55414715350778e-16,  -0.94369707241210e-6};

  const std::vector<int> _J02{0, 1, -5, -4, -3, -2, -1, 2, 3};

  const std::vector<int> _I2{1,  1,  1,  1,  1,  2,  2,  2,  2,  2,  3,  3,  3, 3,  3,
                             4,  4,  4,  5,  6,  6,  6,  7,  7,  7,  8,  8,  9, 10, 10,
                             10, 16, 16, 18, 20, 20, 20, 21, 22, 23, 24, 24, 24};

  const std::vector<int> _J2{0,  1,  2,  3,  6,  1,  2,  4,  7,  36, 0,  1,  3,  6, 35,
                             1,  2,  3,  7,  3,  16, 35, 0,  11, 25, 8,  36, 13, 4, 10,
                             14, 29, 50, 57, 20, 35, 48, 21, 53, 39, 26, 40, 58};

  /// Constants for region 3
  const std::vector<Real> _n3{
      0.10658070028513e1,  -0.15732845290239e2,  0.20944396974307e2,   -0.76867707878716e1,
      0.26185947787954e1,  -0.28080781148620e1,  0.12053369696517e1,   -0.84566812812502e-2,
      -0.12654315477714e1, -0.11524407806681e1,  0.88521043984318e0,   -0.64207765181607e0,
      0.38493460186671e0,  -0.85214708824206e0,  0.48972281541877e1,   -0.30502617256965e1,
      0.39420536879154e-1, 0.12558408424308e0,   -0.27999329698710e0,  0.13899799569460e1,
      -0.20189915023570e1, -0.82147637173963e-2, -0.47596035734923e0,  0.43984074473500e-1,
      -0.44476435428739e0, 0.90572070719733e0,   0.70522450087967e0,   0.10770512626332e0,
      -0.32913623258954e0, -0.50871062041158e0,  -0.22175400873096e-1, 0.94260751665092e-1,
      0.16436278447961e0,  -0.13503372241348e-1, -0.14834345352472e-1, 0.57922953628084e-3,
      0.32308904703711e-2, 0.80964802996215e-4,  -0.16557679795037e-3, -0.44923899061815e-4};

  const std::vector<int> _I3{0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2,  3,  3,
                             3, 3, 3, 4, 4, 4, 4, 5, 5, 5, 6, 6, 6, 7, 8, 9, 9, 10, 10, 11};

  const std::vector<int> _J3{0, 0,  1,  2,  7,  10, 12, 23, 2,  6, 15, 17, 0,  2,
                             6, 7,  22, 26, 0,  2,  4,  16, 26, 0, 2,  4,  26, 1,
                             3, 26, 0,  2,  26, 2,  26, 2,  26, 0, 1,  26};

  const std::vector<std::vector<Real>> _par3{{0.0024, 100.0, 760.0, 0.085, 0.817, 1.0, 1.0, 1.0},
                                             {0.0041, 100.0, 860.0, 0.280, 0.779, 1.0, 1.0, 1.0},
                                             {0.0022, 40.0, 690.0, 0.259, 0.903, 1.0, 1.0, 1.0},
                                             {0.0029, 40.0, 690.0, 0.559, 0.939, 1.0, 1.0, 4.0},
                                             {0.0032, 40.0, 710.0, 0.587, 0.918, 1.0, 1.0, 1.0},
                                             {0.0064, 40.0, 730.0, 0.587, 0.891, 0.5, 1.0, 4.0},
                                             {0.0027, 25.0, 660.0, 0.872, 0.971, 1.0, 1.0, 4.0},
                                             {0.0032, 25.0, 660.0, 0.898, 0.983, 1.0, 1.0, 4.0},
                                             {0.0041, 25.0, 660.0, 0.910, 0.984, 0.5, 1.0, 4.0},
                                             {0.0054, 25.0, 670.0, 0.875, 0.964, 0.5, 1.0, 4.0},
                                             {0.0077, 25.0, 680.0, 0.802, 0.935, 1.0, 1.0, 1.0},
                                             {0.0026, 24.0, 650.0, 0.908, 0.989, 1.0, 1.0, 4.0},
                                             {0.0028, 23.0, 650.0, 1.000, 0.997, 1.0, 0.25, 1.0},
                                             {0.0031, 23.0, 650.0, 0.976, 0.997, 0.0, 0.0, 0.0},
                                             {0.0034, 23.0, 650.0, 0.974, 0.996, 0.5, 1.0, 1.0},
                                             {0.0041, 23.0, 650.0, 0.972, 0.997, 0.5, 1.0, 1.0},
                                             {0.0022, 23.0, 650.0, 0.848, 0.983, 1.0, 1.0, 4.0},
                                             {0.0054, 23.0, 650.0, 0.874, 0.982, 1.0, 1.0, 1.0},
                                             {0.0022, 21.0, 640.0, 0.886, 0.990, 1.0, 1.0, 4.0},
                                             {0.0088, 20.0, 650.0, 0.803, 1.020, 1.0, 1.0, 1.0},
                                             {0.0026, 23.0, 650.0, 0.902, 0.988, 1.0, 1.0, 1.0},
                                             {0.0031, 23.0, 650.0, 0.960, 0.995, 1.0, 1.0, 1.0},
                                             {0.0039, 23.0, 650.0, 0.959, 0.995, 1.0, 1.0, 4.0},
                                             {0.0049, 23.0, 650.0, 0.910, 0.988, 1.0, 1.0, 1.0},
                                             {0.0031, 22.0, 650.0, 0.996, 0.994, 1.0, 1.0, 4.0},
                                             {0.0038, 22.0, 650.0, 0.993, 0.994, 1.0, 1.0, 4.0}};

  const std::vector<unsigned int> _par3N{30, 32, 35, 38, 29, 42, 38, 29, 42, 29, 34, 43, 40,
                                         39, 24, 27, 24, 27, 29, 33, 38, 39, 35, 36, 20, 23};

  /// Constants for all 26 subregions in region 3
  const std::vector<std::vector<Real>> _n3s{
      {0.110879558823853e-2, 0.572616740810616e3,   -0.767051948380852e5,  -0.253321069529674e-1,
       0.628008049345689e4,  0.234105654131876e6,   0.216867826045856,     -0.156237904341963e3,
       -0.269893956176613e5, -0.180407100085505e-3, 0.116732227668261e-2,  0.266987040856040e2,
       0.282776617243286e5,  -0.242431520029523e4,  0.435217323022733e-3,  -0.122494831387441e-1,
       0.179357604019989e1,  0.442729521058314e2,   -0.593223489018342e-2, 0.453186261685774,
       0.135825703129140e1,  0.408748415856745e-1,  0.474686397863312,     0.118646814997915e1,
       0.546987265727549,    0.195266770452643,     -0.502268790869663e-1, -0.369645308193377,
       0.633828037528420e-2, 0.797441793901017e-1},
      {-0.827670470003621e-1, 0.416887126010565e2,   0.483651982197059e-1,  -0.291032084950276e5,
       -0.111422582236948e3,  -0.202300083904014e-1, 0.294002509338515e3,   0.140244997609658e3,
       -0.344384158811459e3,  0.361182452612149e3,   -0.140699677420738e4,  -0.202023902676481e-2,
       0.171346792457471e3,   -0.425597804058632e1,  0.691346085000334e-5,  0.151140509678925e-2,
       -0.416375290166236e-1, -0.413754957011042e2,  -0.506673295721637e2,  -0.572212965569023e-3,
       0.608817368401785e1,   0.239600660256161e2,   0.122261479925384e-1,  0.216356057692938e1,
       0.398198903368642,     -0.116892827834085,    -0.102845919373532,    -0.492676637589284,
       0.655540456406790e-1,  -0.240462535078530,    -0.269798180310075e-1, 0.128369435967012},
      {0.311967788763030e1,   0.276713458847564e5,   0.322583103403269e8,  -0.342416065095363e3,
       -0.899732529907377e6,  -0.793892049821251e8,  0.953193003217388e2,  0.229784742345072e4,
       0.175336675322499e6,   0.791214365222792e7,   0.319933345844209e-4, -0.659508863555767e2,
       -0.833426563212851e6,  0.645734680583292e-1,  -0.382031020570813e7, 0.406398848470079e-4,
       0.310327498492008e2,   -0.892996718483724e-3, 0.234604891591616e3,  0.377515668966951e4,
       0.158646812591361e-1,  0.707906336241843,     0.126016225146570e2,  0.736143655772152,
       0.676544268999101,     -0.178100588189137e2,  -0.156531975531713,   0.117707430048158e2,
       0.840143653860447e-1,  -0.186442467471949,    -0.440170203949645e2, 0.123290423502494e7,
       -0.240650039730845e-1, -0.107077716660869e7,  0.438319858566475e-1},
      {-0.452484847171645e-9, 0.315210389538801e-4,  -0.214991352047545e-2,  0.508058874808345e3,
       -0.127123036845932e8,  0.115371133120497e13,  -0.197805728776273e-15, 0.241554806033972e-10,
       -0.156481703640525e-5, 0.277211346836625e-2,  -0.203578994462286e2,   0.144369489909053e7,
       -0.411254217946539e11, 0.623449786243773e-5,  -0.221774281146038e2,   -0.689315087933158e5,
       -0.195419525060713e8,  0.316373510564015e4,   0.224040754426988e7,    -0.436701347922356e-5,
       -0.404213852833996e-3, -0.348153203414663e3,  -0.385294213555289e6,   0.135203700099403e-6,
       0.134648383271089e-3,  0.125031835351736e6,   0.968123678455841e-1,   0.225660517512438e3,
       -0.190102435341872e-3, -0.299628410819229e-1, 0.500833915372121e-2,   0.387842482998411,
       -0.138535367777182e4,  0.870745245971773,     0.171946252068742e1,    -0.326650121426383e-1,
       0.498044171727877e4,   0.551478022765087e-2},
      {0.715815808404721e9,  -0.114328360753449e12, 0.376531002015720e-11, -0.903983668691157e-4,
       0.665695908836252e6,  0.535364174960127e10,  0.794977402335603e11,  0.922230563421437e2,
       -0.142586073991215e6, -0.111796381424162e7,  0.896121629640760e4,   -0.669989239070491e4,
       0.451242538486834e-2, -0.339731325977713e2,  -0.120523111552278e1,  0.475992667717124e5,
       -0.266627750390341e6, -0.153314954386524e-3, 0.305638404828265,     0.123654999499486e3,
       -0.104390794213011e4, -0.157496516174308e-1, 0.685331118940253,     0.178373462873903e1,
       -0.544674124878910,   0.204529931318843e4,   -0.228342359328752e5,  0.413197481515899,
       -0.341931835910405e2},
      {-0.251756547792325e-7, 0.601307193668763e-5,   -0.100615977450049e-2,
       0.999969140252192,     0.214107759236486e1,    -0.165175571959086e2,
       -0.141987303638727e-2, 0.269251915156554e1,    0.349741815858722e2,
       -0.300208695771783e2,  -0.131546288252539e1,   -0.839091277286169e1,
       0.181545608337015e-9,  -0.591099206478909e-3,  0.152115067087106e1,
       0.252956470663225e-4,  0.100726265203786e-14,  -0.14977453386065e1,
       -0.793940970562969e-9, -0.150290891264717e-3,  0.151205531275133e1,
       0.470942606221652e-5,  0.195049710391712e-12,  -0.911627886266077e-8,
       0.604374640201265e-3,  -0.225132933900136e-15, 0.610916973582981e-11,
       -0.303063908043404e-6, -0.137796070798409e-4,  -0.919296736666106e-3,
       0.639288223132545e-9,  0.753259479898699e-6,   -0.400321478682929e-12,
       0.756140294351614e-8,  -0.912082054034891e-11, -0.237612381140539e-7,
       0.269586010591874e-4,  -0.732828135157839e-10, 0.241995578306660e-9,
       -0.405735532730322e-3, 0.189424143498011e-9,   -0.486632965074563e-9},
      {0.412209020652996e-4, -0.114987238280587e7,  0.948180885032080e10,  -0.195788865718971e18,
       0.4962507048713e25,   -0.105549884548496e29, -0.758642165988278e12, -0.922172769596101e23,
       0.725379072059348e30, -0.617718249205859e2,  0.107555033344858e5,   -0.379545802336487e8,
       0.228646846221831e12, -0.499741093010619e7,  -0.280214310054101e31, 0.104915406769586e7,
       0.613754229168619e28, 0.802056715528378e32,  -0.298617819828065e8,  -0.910782540134681e2,
       0.135033227281565e6,  -0.712949383408211e19, -0.104578785289542e37, 0.304331584444093e2,
       0.593250797959445e10, -0.364174062110798e28, 0.921791403532461,     -0.337693609657471,
       -0.724644143758508e2, -0.110480239272601,    0.536516031875059e1,   -0.291441872156205e4,
       0.616338176535305e40, -0.120889175861180e39, 0.818396024524612e23,  0.940781944835829e9,
       -0.367279669545448e5, -0.837513931798655e16},
      {0.561379678887577e-1, 0.774135421587083e10,   0.111482975877938e-8, -0.143987128208183e-2,
       0.193696558764920e4,  -0.605971823585005e9,   0.171951568124337e14, -0.185461154985145e17,
       0.38785116807801e-16, -0.395464327846105e-13, -0.170875935679023e3, -0.21201062070122e4,
       0.177683337348191e8,  0.110177443629575e2,    -0.234396091693313e6, -0.656174421999594e7,
       0.156362212977396e-4, -0.212946257021400e1,   0.135249306374858e2,  0.177189164145813,
       0.139499167345464e4,  -0.703670932036388e-2,  -0.152011044389648,   0.981916922991113e-4,
       0.147199658618076e-2, 0.202618487025578e2,    0.899345518944240,    -0.211346402240858,
       0.249971752957491e2},
      {0.106905684359136e1,    -0.148620857922333e1,   0.259862256980408e15,
       -0.446352055678749e-11, -0.566620757170032e-6,  -0.235302885736849e-2,
       -0.269226321968839,     0.922024992944392e1,    0.357633505503772e-11,
       -0.173942565562222e2,   0.700681785556229e-5,   -0.267050351075768e-3,
       -0.231779669675624e1,   -0.753533046979752e-12, 0.481337131452891e1,
       -0.223286270422356e22,  -0.118746004987383e-4,  0.646412934136496e-2,
       -0.410588536330937e-9,  0.422739537057241e20,   0.313698180473812e-12,
       0.16439533434504e-23,   -0.339823323754373e-5,  -0.135268639905021e-1,
       -0.723252514211625e-14, 0.184386437538366e-8,   -0.463959533752385e-1,
       -0.99226310037675e14,   0.688169154439335e-16,  -0.222620998452197e-10,
       -0.540843018624083e-7,  0.345570606200257e-2,   0.422275800304086e11,
       -0.126974478770487e-14, 0.927237985153679e-9,   0.612670812016489e-13,
       -0.722693924063497e-11, -0.383669502636822e-3,  0.374684572410204e-3,
       -0.931976897511086e5,   -0.247690616026922e-1,  0.658110546759474e2},
      {-0.111371317395540e-3, 0.100342892423685e1,    0.530615581928979e1,
       0.179058760078792e-5,  -0.728541958464774e-3,  -0.187576133371704e2,
       0.199060874071849e-2,  0.243574755377290e2,    -0.177040785499444e-3,
       -0.25968038522713e-2,  -0.198704578406823e3,   0.738627790224287e-4,
       -0.236264692844138e-2, -0.161023121314333e1,   0.622322971786473e4,
       -0.960754116701669e-8, -0.510572269720488e-10, 0.767373781404211e-2,
       0.663855469485254e-14, -0.717590735526745e-9,  0.146564542926508e-4,
       0.309029474277013e-11, -0.464216300971708e-15, -0.390499637961161e-13,
       -0.236716126781431e-9, 0.454652854268717e-11,  -0.422271787482497e-2,
       0.283911742354706e-10, 0.270929002720228e1},
      {-0.401215699576099e9,   0.484501478318406e11,   0.394721471363678e-14,
       0.372629967374147e5,    -0.369794374168666e-29, -0.380436407012452e-14,
       0.475361629970233e-6,   -0.879148916140706e-3,  0.844317863844331,
       0.122433162656600e2,    -0.104529634830279e3,   0.589702771277429e3,
       -0.291026851164444e14,  0.170343072841850e-5,   -0.277617606975748e-3,
       -0.344709605486686e1,   0.221333862447095e2,    -0.194646110037079e3,
       0.808354639772825e-15,  -0.18084520914547e-10,  -0.696664158132412e-5,
       -0.181057560300994e-2,  0.255830298579027e1,    0.328913873658481e4,
       -0.173270241249904e-18, -0.661876792558034e-6,  -0.39568892342125e-2,
       0.604203299819132e-17,  -0.400879935920517e-13, 0.160751107464958e-8,
       0.383719409025556e-4,   -0.649565446702457e-14, -0.149095328506e-11,
       0.541449377329581e-8},
      {0.260702058647537e10,  -0.188277213604704e15, 0.554923870289667e19,  -0.758966946387758e23,
       0.413865186848908e27,  -0.81503800073806e12,  -0.381458260489955e33, -0.123239564600519e-1,
       0.226095631437174e8,   -0.49501780950672e12,  0.529482996422863e16,  -0.444359478746295e23,
       0.521635864527315e35,  -0.487095672740742e55, -0.714430209937547e6,  0.127868634615495,
       -0.100752127917598e2,  0.777451437960990e7,   -0.108105480796471e25, -0.357578581169659e-5,
       -0.212857169423484e1,  0.270706111085238e30,  -0.695953622348829e33, 0.110609027472280,
       0.721559163361354e2,   -0.306367307532219e15, 0.265839618885530e-4,  0.253392392889754e-1,
       -0.214443041836579e3,  0.937846601489667,     0.223184043101700e1,   0.338401222509191e2,
       0.494237237179718e21,  -0.198068404154428,    -0.141415349881140e31, -0.993862421613651e2,
       0.125070534142731e3,   -0.996473529004439e3,  0.473137909872765e5,   0.116662121219322e33,
       -0.315874976271533e16, -0.445703369196945e33, 0.642794932373694e33},
      {0.811384363481847,     -0.568199310990094e4,  -0.178657198172556e11, 0.795537657613427e32,
       -0.814568209346872e5,  -0.659774567602874e8,  -0.152861148659302e11, -0.560165667510446e12,
       0.458384828593949e6,   -0.385754000383848e14, 0.453735800004273e8,   0.939454935735563e12,
       0.266572856432938e28,  -0.547578313899097e10, 0.200725701112386e15,  0.185007245563239e13,
       0.185135446828337e9,   -0.170451090076385e12, 0.157890366037614e15,  -0.202530509748774e16,
       0.36819392618357e60,   0.170215539458936e18,  0.639234909918741e42,  -0.821698160721956e15,
       -0.795260241872306e24, 0.23341586947851e18,   -0.600079934586803e23, 0.594584382273384e25,
       0.189461279349492e40,  -0.810093428842645e46, 0.188813911076809e22,  0.111052244098768e36,
       0.291133958602503e46,  -0.329421923951460e22, -0.137570282536696e26, 0.181508996303902e28,
       -0.346865122768353e30, -0.21196114877426e38,  -0.128617899887675e49, 0.479817895699239e65},
      {0.280967799943151e-38,  0.614869006573609e-30,  0.582238667048942e-27,
       0.390628369238462e-22,  0.821445758255119e-20,  0.402137961842776e-14,
       0.651718171878301e-12,  -0.211773355803058e-7,  0.264953354380072e-2,
       -0.135031446451331e-31, -0.607246643970893e-23, -0.402352115234494e-18,
       -0.744938506925544e-16, 0.189917206526237e-12,  0.364975183508473e-5,
       0.177274872361946e-25,  -0.334952758812999e-18, -0.421537726098389e-8,
       -0.391048167929649e-1,  0.541276911564176e-13,  0.705412100773699e-11,
       0.258585887897486e-8,   -0.493111362030162e-10, -0.158649699894543e-5,
       -0.525037427886100,     0.220019901729615e-2,   -0.643064132636925e-2,
       0.629154149015048e2,    0.135147318617061e3,    0.240560808321713e-6,
       -0.890763306701305e-3,  -0.440209599407714e4,   -0.302807107747776e3,
       0.159158748314599e4,    0.232534272709876e6,    -0.792681207132600e6,
       -0.869871364662769e11,  0.354542769185671e12,   0.400849240129329e15},
      {0.128746023979718e-34,  -0.735234770382342e-11, 0.28907869214915e-2,
       0.244482731907223,      0.141733492030985e-23,  -0.354533853059476e-28,
       -0.594539202901431e-17, -.585188401782779e-8,   .201377325411803e-5,
       0.138647388209306e1,    -0.173959365084772e-4,  0.137680878349369e-2,
       0.814897605805513e-14,  0.425596631351839e-25,  -0.387449113787755e-17,
       0.13981474793024e-12,   -0.171849638951521e-2,  0.641890529513296e-21,
       0.118960578072018e-10,  -0.155282762571611e-17, 0.233907907347507e-7,
       -0.174093247766213e-12, 0.377682649089149e-8,   -0.516720236575302e-10},
      {-0.982825342010366e-4,  0.105145700850612e1,   0.116033094095084e3,   0.324664750281543e4,
       -0.123592348610137e4,   -0.561403450013495e-1, 0.856677401640869e-7,  0.236313425393924e3,
       0.972503292350109e-2,   -0.103001994531927e1,  -0.149653706199162e-8, -0.215743778861592e-4,
       -0.834452198291445e1,   0.586602660564988,     0.343480022104968e-25, 0.816256095947021e-5,
       0.294985697916798e-2,   0.711730466276584e-16, 0.400954763806941e-9,  0.107766027032853e2,
       -0.409449599138182e-6,  -0.729121307758902e-5, 0.677107970938909e-8,  0.602745973022975e-7,
       -0.382323011855257e-10, 0.179946628317437e-2,  -0.345042834640005e-3},
      {-0.820433843259950e5, 0.473271518461586e11,  -0.805950021005413e-1, 0.328600025435980e2,
       -0.35661702998249e4,  -0.172985781433335e10, 0.351769232729192e8,   -0.775489259985144e6,
       0.710346691966018e-4, 0.993499883820274e5,   -0.642094171904570,    -0.612842816820083e4,
       0.232808472983776e3,  -0.142808220416837e-4, -0.643596060678456e-2, -0.428577227475614e1,
       0.225689939161918e4,  0.100355651721510e-2,  0.333491455143516,     0.109697576888873e1,
       0.961917379376452,    -0.838165632204598e-1, 0.247795908411492e1,   -0.319114969006533e4},
      {0.144165955660863e-2,  -0.701438599628258e13,  -0.830946716459219e-16, 0.261975135368109,
       0.393097214706245e3,   -0.104334030654021e5,   0.490112654154211e9,    -0.147104222772069e-3,
       0.103602748043408e1,   0.305308890065089e1,    -0.399745276971264e7,   0.569233719593750e-11,
       -0.464923504407778e-1, -0.535400396512906e-17, 0.399988795693162e-12,  -0.536479560201811e-6,
       0.159536722411202e-1,  0.270303248860217e-14,  0.244247453858506e-7,   -0.983430636716454e-5,
       0.663513144224454e-1,  -0.993456957845006e1,   0.546491323528491e3,    -0.143365406393758e5,
       0.150764974125511e6,   -0.337209709340105e-9,  0.377501980025469e-8},
      {-0.532466612140254e23, 0.100415480000824e32,  -0.191540001821367e30, 0.105618377808847e17,
       0.202281884477061e59,  0.884585472596134e8,   0.166540181638363e23,  -0.313563197669111e6,
       -0.185662327545324e54, -0.624942093918942e-1, -0.50416072413259e10,  0.187514491833092e5,
       0.121399979993217e-2,  0.188317043049455e1,   -0.167073503962060e4,  0.965961650599775,
       0.294885696802488e1,   -0.653915627346115e5,  0.604012200163444e50,  -0.198339358557937,
       -0.175984090163501e58, 0.356314881403987e1,   -0.575991255144384e3,  0.456213415338071e5,
       -0.109174044987829e8,  0.437796099975134e34,  -0.616552611135792e46, 0.193568768917797e10,
       0.950898170425042e54},
      {0.155287249586268e1,   0.664235115009031e1,   -0.289366236727210e4,  -0.385923202309848e13,
       -0.291002915783761e1,  -0.829088246858083e12, 0.176814899675218e1,   -0.534686695713469e9,
       0.160464608687834e18,  0.196435366560186e6,   0.156637427541729e13,  -0.178154560260006e1,
       -0.229746237623692e16, 0.385659001648006e8,   0.110554446790543e10,  -0.677073830687349e14,
       -0.327910592086523e31, -0.341552040860644e51, -0.527251339709047e21, 0.245375640937055e24,
       -0.168776617209269e27, 0.358958955867578e29,  -0.656475280339411e36, 0.355286045512301e39,
       0.569021454413270e58,  -0.700584546433113e48, -0.705772623326374e65, 0.166861176200148e53,
       -0.300475129680486e61, -0.668481295196808e51, 0.428432338620678e69,  -0.444227367758304e72,
       -0.281396013562745e77},
      {0.122088349258355e18,  0.104216468608488e10,  -.882666931564652e16,  0.259929510849499e20,
       0.222612779142211e15,  -0.878473585050085e18, -0.314432577551552e22, -0.216934916996285e13,
       0.159079648196849e21,  -0.339567617303423e3,  0.884387651337836e13,  -0.843405926846418e21,
       0.114178193518022e2,   -0.122708229235641e-3, -0.106201671767107e3,  0.903443213959313e25,
       -0.693996270370852e28, 0.648916718965575e-8,  0.718957567127851e4,   0.105581745346187e-2,
       -0.651903203602581e15, -0.160116813274676e25, -0.510254294237837e-8, -0.152355388953402,
       0.677143292290144e12,  0.276378438378930e15,  0.116862983141686e-1,  -0.301426947980171e14,
       0.169719813884840e-7,  0.104674840020929e27,  -0.10801690456014e5,   -0.990623601934295e-12,
       0.536116483602738e7,   0.226145963747881e22,  -0.488731565776210e-9, 0.151001548880670e-4,
       -0.227700464643920e5,  -0.781754507698846e28},
      {-0.415652812061591e-54, 0.177441742924043e-60,  -0.357078668203377e-54,
       0.359252213604114e-25,  -0.259123736380269e2,   0.594619766193460e5,
       -0.624184007103158e11,  0.313080299915944e17,   0.105006446192036e-8,
       -0.192824336984852e-5,  0.654144373749937e6,    0.513117462865044e13,
       -0.697595750347391e19,  -0.103977184454767e29,  0.119563135540666e-47,
       -0.436677034051655e-41, 0.926990036530639e-29,  0.587793105620748e21,
       0.280375725094731e-17,  -0.192359972440634e23,  0.742705723302738e27,
       -0.517429682450605e2,   0.820612048645469e7,    -0.188214882341448e-8,
       0.184587261114837e-1,   -0.135830407782663e-5,  -0.723681885626348e17,
       -0.223449194054124e27,  -0.111526741826431e-34, 0.276032601145151e-28,
       0.134856491567853e15,   0.652440293345860e-9,   0.510655119774360e17,
       -0.468138358908732e32,  -0.760667491183279e16,  -0.417247986986821e-18,
       0.312545677756104e14,   -0.100375333864186e15,  0.247761392329058e27},
      {-0.586219133817016e-7,  -0.894460355005526e11, 0.531168037519774e-30,
       0.109892402329239,      -0.575368389425212e-1, 0.228276853990249e5,
       -0.158548609655002e19,  0.329865748576503e-27, -0.634987981190669e-24,
       0.615762068640611e-8,   -0.961109240985747e8,  -0.406274286652625e-44,
       -0.471103725498077e-12, 0.725937724828145,     0.187768525763682e-38,
       -0.103308436323771e4,   -0.662552816342168e-1, 0.579514041765710e3,
       0.237416732616644e-26,  0.271700235739893e-14, -0.9078862134836e2,
       -0.171242509570207e-36, 0.156792067854621e3,   0.923261357901470,
       -0.597865988422577e1,   0.321988767636389e7,   -0.399441390042203e-29,
       0.493429086046981e-7,   0.812036983370565e-19, -0.207610284654137e-11,
       -0.340821291419719e-6,  0.542000573372233e-17, -0.856711586510214e-12,
       0.266170454405981e-13,  0.858133791857099e-5},
      {0.377373741298151e19,  -0.507100883722913e13, -0.10336322559886e16,   0.184790814320773e-5,
       -0.924729378390945e-3, -0.425999562292738e24, -0.462307771873973e-12, 0.107319065855767e22,
       0.648662492280682e11,  0.244200600688281e1,   -0.851535733484258e10,  0.169894481433592e22,
       0.215780222509020e-26, -0.320850551367334,    -0.382642448458610e17,  -0.275386077674421e-28,
       -0.563199253391666e6,  -0.326068646279314e21, 0.397949001553184e14,   0.100824008584757e-6,
       0.162234569738433e5,   -0.432355225319745e11, -0.59287424559861e12,   0.133061647281106e1,
       0.157338197797544e7,   0.258189614270853e14,  0.262413209706358e25,   -0.920011937431142e-1,
       0.220213765905426e-2,  -0.110433759109547e2,  0.847004870612087e7,    -0.592910695762536e9,
       -0.183027173269660e-4, 0.181339603516302,     -0.119228759669889e4,   0.430867658061468e7},
      {-0.525597995024633e-9, 0.583441305228407e4,   -0.134778968457925e17, 0.118973500934212e26,
       -0.159096490904708e27, -0.315839902302021e-6, 0.496212197158239e3,   0.327777227273171e19,
       -0.527114657850696e22, 0.210017506281863e-16, 0.705106224399834e21,  -0.266713136106469e31,
       -0.145370512554562e-7, 0.149333917053130e28,  -0.149795620287641e8,  -0.3818819062711e16,
       0.724660165585797e-4,  -0.937808169550193e14, 0.514411468376383e10,  -0.828198594040141e5},
      {0.24400789229065e-10,  -0.463057430331242e7,  0.728803274777712e10, 0.327776302858856e16,
       -0.110598170118409e10, -0.323899915729957e13, 0.923814007023245e16, 0.842250080413712e-12,
       0.663221436245506e12,  -0.167170186672139e15, 0.253749358701391e4,  -0.819731559610523e-20,
       0.328380587890663e12,  -0.625004791171543e8,  0.803197957462023e21, -0.204397011338353e-10,
       -0.378391047055938e4,  0.97287654593862e-2,   0.154355721681459e2,  -0.373962862928643e4,
       -0.682859011374572e11, -0.248488015614543e-3, 0.394536049497068e7}};

  const std::vector<std::vector<int>> _I3s{
      {-12, -12, -12, -10, -10, -10, -8, -8, -8, -6, -5, -5, -5, -4, -3,
       -3,  -3,  -3,  -2,  -2,  -2,  -1, -1, -1, 0,  0,  1,  1,  2,  2},
      {-12, -12, -10, -10, -8, -6, -6, -6, -5, -5, -5, -4, -4, -4, -3, -3,
       -3,  -3,  -3,  -2,  -2, -2, -1, -1, 0,  0,  1,  1,  2,  3,  4,  4},
      {-12, -12, -12, -10, -10, -10, -8, -8, -8, -6, -5, -5, -5, -4, -4, -3, -3, -2,
       -2,  -2,  -1,  -1,  -1,  0,   0,  0,  1,  1,  2,  2,  2,  2,  3,  3,  8},
      {-12, -12, -12, -12, -12, -12, -10, -10, -10, -10, -10, -10, -10, -8, -8, -8, -8, -6, -6,
       -5,  -5,  -5,  -5,  -4,  -4,  -4,  -3,  -3,  -2,  -2,  -1,  -1,  -1, 0,  0,  1,  1,  3},
      {-12, -12, -10, -10, -10, -10, -10, -8, -8, -8, -6, -5, -4, -4, -3,
       -3,  -3,  -2,  -2,  -2,  -2,  -1,  0,  0,  1,  1,  1,  2,  2},
      {0,  0,  0,  0,  0,  0,  1,  1,  1,  1,  2,  2,  3,  3,  3,  4,  5,  5,  6,  7,  7,
       10, 12, 12, 12, 14, 14, 14, 14, 14, 16, 16, 18, 18, 20, 20, 20, 22, 24, 24, 28, 32},
      {-12, -12, -12, -12, -12, -12, -10, -10, -10, -8, -8, -8, -8, -6, -6, -5, -5, -4, -3,
       -2,  -2,  -2,  -2,  -1,  -1,  -1,  0,   0,   0,  1,  1,  1,  3,  5,  6,  8,  10, 10},
      {-12, -12, -10, -10, -10, -10, -10, -10, -8, -8, -8, -8, -8, -6, -6,
       -6,  -5,  -5,  -5,  -4,  -4,  -3,  -3,  -2, -1, -1, 0,  1,  1},
      {0,  0,  0,  1,  1,  1,  1,  2,  3,  3,  4,  4,  4,  5,  5,  5,  7,  7,  8,  8,  10,
       12, 12, 12, 14, 14, 14, 14, 18, 18, 18, 18, 18, 20, 20, 22, 24, 24, 32, 32, 36, 36},
      {0,  0,  0,  1,  1,  1,  2,  2,  3,  4,  4,  5,  5,  5, 6,
       10, 12, 12, 14, 14, 14, 16, 18, 20, 20, 24, 24, 28, 28},
      {-2, -2, -1, -1, 0, -0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1,  1,
       1,  2,  2,  2,  2, 2,  2, 5, 5, 5, 6, 6, 6, 6, 8, 10, 12},
      {-12, -12, -12, -12, -12, -10, -10, -8, -8, -8, -8, -8, -8, -8, -6,
       -5,  -5,  -4,  -4,  -3,  -3,  -3,  -3, -2, -2, -2, -1, -1, -1, 0,
       0,   0,   0,   1,   1,   2,   4,   5,  5,  6,  10, 10, 14},
      {0,  3, 8,  20, 1, 3, 4, 5, 1,  6,  2, 4, 14, 2, 5, 3, 0, 1, 1,  1,
       28, 2, 16, 0,  5, 0, 3, 4, 12, 16, 1, 8, 14, 0, 2, 3, 4, 8, 14, 24},
      {0, 3, 4, 6, 7, 10, 12, 14, 18, 0, 3, 5, 6, 8, 12, 0, 3, 7, 12, 2,
       3, 4, 2, 4, 7, 4,  3,  5,  6,  0, 0, 3, 1, 0, 1,  0, 1, 0, 1},
      {0, 0, 0, 2, 3, 4, 4, 4, 4, 4, 5, 5, 6, 7, 8, 8, 8, 10, 10, 14, 14, 20, 20, 24},
      {0,  0,  0,  0,  1,  2,  3,  3,  4,  6,  7,  7,  8, 10,
       12, 12, 12, 14, 14, 14, 16, 18, 20, 22, 24, 24, 36},
      {-12, -12, -10, -10, -10, -10, -8, -6, -5, -5, -4, -4,
       -3,  -2,  -2,  -2,  -2,  -1,  -1, -1, 0,  1,  1,  1},
      {-8, -8, -3, -3, -3, -3, -3, 0,  0,  0,  0,  3,  3, 8,
       8,  8,  8,  10, 10, 10, 10, 10, 10, 10, 10, 12, 14},
      {-12, -12, -10, -8, -6, -5, -5, -4, -4, -3, -3, -2, -1, -1, -1,
       0,   0,   0,   0,  1,  1,  3,  3,  3,  4,  4,  4,  5,  14},
      {0, 0,  0,  0,  1,  1,  2,  2,  2,  3,  3,  4,  4,  7,  7,  7, 7,
       7, 10, 10, 10, 10, 10, 18, 20, 22, 22, 24, 28, 32, 32, 32, 36},
      {-12, -10, -10, -10, -8, -8, -8, -6, -6, -5, -5, -5, -3, -1, -1, -1, -1, 0,  0,
       1,   2,   2,   3,   5,  5,  5,  6,  6,  8,  8,  10, 12, 12, 12, 14, 14, 14, 14},
      {-10, -8, -6, -6, -6, -6, -6, -6, -5, -5, -5, -5, -5, -5, -4, -4, -4, -4, -3, -3,
       -3,  -2, -2, -1, -1, 0,  0,  0,  1,  1,  3,  4,  4,  4,  5,  8,  10, 12, 14},
      {-12, -12, -10, -10, -8, -8, -8, -6, -6, -6, -6, -5, -4, -4, -3, -3, -2, -2,
       -1,  -1,  -1,  0,   0,  1,  2,  2,  3,  3,  5,  5,  5,  8,  8,  10, 10},
      {-8, -6, -5, -4, -4, -4, -3, -3, -1, 0,  0,  0,  1,  1,  2,  3,  3,  3,
       4,  5,  5,  5,  6,  8,  8,  8,  8,  10, 12, 12, 12, 12, 14, 14, 14, 14},
      {0, 0, 0, 0, 1, 2, 2, 2, 2, 3, 3, 3, 4, 4, 5, 5, 8, 8, 10, 12},
      {-8, -6, -5, -5, -4, -4, -4, -3, -3, -3, -2, -1, 0, 1, 2, 3, 3, 6, 6, 6, 6, 8, 8}};

  const std::vector<std::vector<int>> _J3s{
      {5, 10, 12, 5, 10, 12, 5, 8, 10, 1, 1, 5, 10, 8, 0,
       1, 3,  6,  0, 2,  3,  0, 1, 2,  0, 1, 0, 2,  0, 2},
      {10, 12, 8, 14, 8, 5, 6, 8, 5, 8, 10, 2, 4, 5, 0, 1,
       2,  3,  5, 0,  2, 5, 0, 2, 0, 1, 0,  2, 0, 2, 0, 1},
      {6, 8, 10, 6, 8, 10, 5, 6, 7, 8, 1, 4, 7, 2, 8, 0, 3, 0,
       4, 5, 0,  1, 2, 0,  1, 2, 0, 2, 0, 1, 3, 7, 0, 7, 1},
      {4, 6, 7, 10, 12, 16, 0, 2, 4, 6, 8, 10, 14, 3, 7, 8, 10, 6, 8,
       1, 2, 5, 7,  0,  1,  7, 2, 4, 0, 1, 0,  1,  5, 0, 2, 0,  6, 0},
      {14, 16, 3, 6, 10, 14, 16, 7, 8, 10, 6, 6, 2, 4, 2, 6, 7, 0, 1, 3, 4, 0, 0, 1, 0, 4, 6, 0, 2},
      {-3, -2, -1,  0,  1,   2,   -1,  1,   2,   3,   0,   1,   -5,  -2,
       0,  -3, -8,  1,  -6,  -4,  1,   -6,  -10, -8,  -4,  -12, -10, -8,
       -6, -4, -10, -8, -12, -10, -12, -10, -6,  -12, -12, -4,  -12, -12},
      {7, 12, 14, 18, 22, 24, 14, 20, 24, 7, 8, 10, 12, 8,  22, 7,  20, 22, 7,
       3, 5,  14, 24, 2,  8,  18, 0,  1,  2, 0, 1,  3,  24, 22, 12, 3,  0,  6},
      {8, 12, 4, 6, 8, 10, 14, 16, 0, 1, 6, 7, 8, 4, 6, 8, 2, 3, 4, 2, 4, 1, 2, 0, 0, 2, 0, 0, 2},
      {0,   1,  10, -4,  -2, -1, 0, 0,   -5,  0,  -3, -2, -1,  -6,  -1,  12,  -4, -3,  -6, 10,  -8,
       -12, -6, -4, -10, -8, -4, 5, -12, -10, -8, -6, 2,  -12, -10, -12, -12, -8, -10, -5, -10, -8},
      {-1, 0,  1,  -2,  -1, 1,  -1,  1,   -2,  -2,  2,   -3, -2,  0, 3,
       -6, -8, -3, -10, -8, -5, -10, -12, -12, -10, -12, -6, -12, -5},
      {10, 12, -5, 6,  -12, -6, -2, -1,  0,  1,  2,   3,   14, -3, -2,  0,   1,
       2,  -8, -6, -3, -2,  0,  4,  -12, -6, -3, -12, -10, -8, -5, -12, -12, -10},
      {14, 16, 18, 20, 22, 14, 24, 6, 10, 12, 14, 18, 24, 36, 8, 4, 5, 7,  16, 1,  3, 18,
       20, 2,  3,  10, 0,  1,  3,  0, 1,  2,  12, 0,  16, 1,  0, 0, 1, 14, 4,  12, 10},
      {0,  0,  0,  2,  5,  5,  5,  5,  6,  6,  7,  8,  8,  10, 10, 12, 14, 14, 18, 20,
       20, 22, 22, 24, 24, 28, 28, 28, 28, 28, 32, 32, 32, 36, 36, 36, 36, 36, 36, 36},
      {-12, -12, -12, -12, -12, -12, -12, -12, -12, -10, -10, -10, -10,
       -10, -10, -8,  -8,  -8,  -8,  -6,  -6,  -6,  -5,  -5,  -5,  -4,
       -3,  -3,  -3,  -2,  -1,  -1,  0,   1,   1,   2,   4,   5,   6},
      {-12, -4,  -1,  -1, -10, -12, -8, -5,  -4, -1,  -4,  -3,
       -8,  -12, -10, -8, -4,  -12, -8, -12, -8, -12, -10, -12},
      {-1,  0,  1,  2,   1,  -1, -3, 0,  -2,  -2,  -5,  -4, -2, -3,
       -12, -6, -5, -10, -8, -3, -8, -8, -10, -10, -12, -8, -12},
      {10, 12, 6, 7, 8, 10, 8, 6, 2, 5, 3, 4, 3, 0, 1, 2, 4, 0, 1, 2, 0, 0, 1, 3},
      {6,   14, -3, 3,   4,   5,  8,  -1, 0,  1,  5,  -6,  -2, -12,
       -10, -8, -5, -12, -10, -8, -6, -5, -4, -3, -2, -12, -12},
      {20, 24, 22, 14, 36, 8,  16, 6, 32, 3, 8,  4,  1, 2, 3,
       0,  1,  4,  28, 0,  32, 0,  1, 2,  3, 18, 24, 4, 24},
      {0,  1,  4,  12, 0,  10, 0,  6,  14, 3,  8,  0,  10, 3,  4,  7, 20,
       36, 10, 12, 14, 16, 22, 18, 32, 22, 36, 24, 28, 22, 32, 36, 36},
      {14, 10, 12, 14, 10, 12, 14, 8,  12, 4,  8, 12, 2,   -1, 1, 12,  14,  -3, 1,
       -2, 5,  10, -5, -4, 2,  3,  -5, 2,  -8, 8, -4, -12, -4, 4, -12, -10, -6, 6},
      {-8, -12, -12, -3, 5, 6,  8, 10, 1,   2,   6, 8,  10, 14, -12, -10, -6, 10, -3, 10,
       12, 2,   4,   -2, 0, -2, 6, 10, -12, -10, 3, -6, 3,  10, 2,   -12, -2, -3, 1},
      {8,  14, -1, 8,   6, 8,  14, -4, -3,  2,  8,   -10, -1, 3,   -10, 3,   1, 2,
       -8, -4, 1,  -12, 1, -1, -1, 2,  -12, -5, -10, -8,  -6, -12, -10, -12, -8},
      {14, 10, 10, 1, 2, 14, -2, 12, 5, 0,  4,   10, -10, -1, 6,   -12, 0,  8,
       3,  -6, -2, 1, 1, -6, -3, 1,  8, -8, -10, -8, -5,  -4, -12, -10, -8, -6},
      {-3, 1, 5, 8, 8, -4, -1, 4, 5, -8, 4, 8, -6, 6, -2, 1, -8, -2, -5, -8},
      {3, 6, 6, 8, 5, 6, 8, -2, 5, 6, 2, -6, 3, 1, 6, -6, -2, -6, -5, -4, -1, -8, -4}};

  /// Constants for region 5
  const std::vector<int> _J05{0, 1, -3, -2, -1, 2};
  const std::vector<Real> _n05{-0.13179983674201e2,
                               0.68540841634434e1,
                               -0.24805148933466e-1,
                               0.36901534980333,
                               -0.31161318213925e1,
                               -0.32961626538917};

  const std::vector<int> _I5{1, 1, 1, 2, 2, 3};
  const std::vector<int> _J5{1, 2, 3, 3, 9, 7};
  const std::vector<Real> _n5{0.15736404855259e-2,
                              0.90153761673944e-3,
                              -0.50270077677648e-2,
                              0.22440037409485e-5,
                              -0.41163275453471e-5,
                              0.37919454822955e-7};

  /// Temperature scale for each region
  const std::vector<Real> _T_star{1386.0, 540.0, _T_critical, 1.0, 1000.0};
  /// Pressure scale for each region
  const std::vector<Real> _p_star{16.53e6, 1.0e6, 1.0e6, 1.0e6, 1.0e6};
};

#endif /* WATER97FLUIDPROPERTIES_H */
