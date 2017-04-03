/****************************************************************/
/* MOOSE - Multiphysics Object Oriented Simulation Environment  */
/*                                                              */
/*          All contents are licensed under LGPL V2.1           */
/*             See LICENSE for full restrictions                */
/****************************************************************/

#ifndef RICHARDSSEFF_H
#define RICHARDSSEFF_H

#include "GeneralUserObject.h"

class RichardsSeff;

template <>
InputParameters validParams<RichardsSeff>();

/**
 * Base class for effective saturation as a function of porepressure(s)
 * The functions seff, dseff and d2seff must be over-ridden in the derived class
 */
class RichardsSeff : public GeneralUserObject
{
public:
  RichardsSeff(const InputParameters & parameters);

  void initialize();
  void execute();
  void finalize();

  /**
   * effective saturation as a function of porepressure(s) at given quadpoint of the element
   * @param p the porepressure(s).  Eg (*p[0])[qp] is the zeroth pressure evaluated at quadpoint qp
   * @param qp the quad point of the element to evaluate effective saturation at.
   */
  virtual Real seff(std::vector<const VariableValue *> p, unsigned int qp) const = 0;

  /**
   * derivative(s) of effective saturation as a function of porepressure(s) at given quadpoint of
   * the element
   * If there are three porepressures, this will return at length-3 vector (dSeff/dP[0],
   * dSeff/dP[1], dSeff/dP[2])
   * @param p the porepressure(s).  Eg (*p[0])[qp] is the zeroth pressure evaluated at quadpoint qp
   * @param qp the quad point of the element to evaluate the derivative at
   * @param result the derivtives will be placed in this array
   */
  virtual void dseff(std::vector<const VariableValue *> p,
                     unsigned int qp,
                     std::vector<Real> & result) const = 0;

  /**
   * second derivative(s) of effective saturation as a function of porepressure(s) at given
   * quadpoint of the element
   * d2seff[m][n] = d^2 Seff/dP[m]/dP[n]
   * @param p the porepressure(s).  Eg (*p[0])[qp] is the zeroth pressure evaluated at quadpoint qp
   * @param qp the quad point of the element to evaluate the derivative at
   * @param result the derivtives will be placed in this array
   */
  // virtual std::vector<std::vector<Real> > d2seff(std::vector<const VariableValue *> p, unsigned
  // int qp) const = 0;
  virtual void d2seff(std::vector<const VariableValue *> p,
                      unsigned int qp,
                      std::vector<std::vector<Real>> & result) const = 0;
};

#endif // RICHARDSSEFF_H
