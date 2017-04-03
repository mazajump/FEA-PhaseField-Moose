/****************************************************************/
/*               DO NOT MODIFY THIS HEADER                      */
/* MOOSE - Multiphysics Object Oriented Simulation Environment  */
/*                                                              */
/*           (c) 2010 Battelle Energy Alliance, LLC             */
/*                   ALL RIGHTS RESERVED                        */
/*                                                              */
/*          Prepared by Battelle Energy Alliance, LLC           */
/*            Under Contract No. DE-AC07-05ID14517              */
/*            With the U. S. Department of Energy               */
/*                                                              */
/*            See COPYRIGHT for full restrictions               */
/****************************************************************/

#ifndef CRANKNICOLSON_H
#define CRANKNICOLSON_H

#include "TimeIntegrator.h"

class CrankNicolson;

template <>
InputParameters validParams<CrankNicolson>();

/**
 * Crank-Nicolson time integrator.
 *
 * The scheme is defined as:
 *   \f$ \frac{du}{dt} = 1/2 * (F(U^{n+1}) + F(U^{n})) \f$,
 * but the form we are using it in is:
 *   \f$ 2 * \frac{du}{dt} = (F(U^{n+1}) + F(U^{n})) \f$.
 */
class CrankNicolson : public TimeIntegrator
{
public:
  CrankNicolson(const InputParameters & parameters);
  virtual ~CrankNicolson();

  virtual int order() { return 2; }
  virtual void computeTimeDerivatives();
  virtual void preSolve();
  virtual void postStep(NumericVector<Number> & residual);
  virtual void postSolve();

protected:
  NumericVector<Number> & _residual_old;
};

#endif /* CRANKNICOLSON_H */
