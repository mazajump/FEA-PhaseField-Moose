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

#ifndef LINEARINTERPOLATION_H
#define LINEARINTERPOLATION_H

#include <vector>
#include <fstream>
#include <sstream>
#include <string>

#include "Moose.h"

/**
 * This class interpolates values given a set of data pairs and an abscissa.
 */
class LinearInterpolation
{
public:
  /* Constructor, Takes two vectors of points for which to apply the fit.  One should be of the
   * independent variable while the other should be of the dependent variable.  These values should
   * correspond to one and other in the same position.
   */
  LinearInterpolation(const std::vector<Real> & X, const std::vector<Real> & Y);
  LinearInterpolation() : _x(std::vector<Real>()), _y(std::vector<Real>()) {}

  virtual ~LinearInterpolation() = default;

  /**
   * Set the x and y values.
   */
  void setData(const std::vector<Real> & X, const std::vector<Real> & Y)
  {
    _x = X;
    _y = Y;
    errorCheck();
  }

  void errorCheck();

  /**
   * This function will take an independent variable input and will return the dependent variable
   * based on the generated fit
   */
  Real sample(Real x) const;

  /**
   * This function will take an independent variable input and will return the derivative of the
   * dependent variable
   * with respect to the independent variable based on the generated fit
   */
  Real sampleDerivative(Real x) const;

  /**
   * This function will dump GNUPLOT input files that can be run to show the data points and
   * function fits
   */
  void dumpSampleFile(std::string base_name,
                      std::string x_label = "X",
                      std::string y_label = "Y",
                      Real xmin = 0,
                      Real xmax = 0,
                      Real ymin = 0,
                      Real ymax = 0);

  /**
   * This function returns the size of the array holding the points, i.e. the number of sample
   * points
   */
  unsigned int getSampleSize();

  /**
   * This function returns the integral of the function
   */
  Real integrate();

  Real domain(int i) const;
  Real range(int i) const;

private:
  std::vector<Real> _x;
  std::vector<Real> _y;

  static int _file_number;
};

#endif // LINEARINTERPOLATION_H
