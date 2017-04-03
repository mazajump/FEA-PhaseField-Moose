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

#ifndef GLOBALPARAMSACTION_H
#define GLOBALPARAMSACTION_H

#include "Action.h"

class GlobalParamsAction;

template <>
InputParameters validParams<GlobalParamsAction>();

class GlobalParamsAction : public Action
{
public:
  GlobalParamsAction(InputParameters params);

  virtual void act() override;

  /**
   * This function is here to remove parameters of a type so that global parameters
   * can potentially use the same named variable as a different type depending on the
   * application.
   */
  void remove(const std::string & name);

  template <typename T>
  inline T & setScalarParam(const std::string & name)
  {
    return parameters().set<T>(name);
  }

  template <typename T>
  inline std::vector<T> & setVectorParam(const std::string & name)
  {
    return parameters().set<std::vector<T>>(name);
  }

  template <typename T>
  inline std::vector<std::vector<T>> & setDoubleIndexParam(const std::string & name)
  {
    return parameters().set<std::vector<std::vector<T>>>(name);
  }
};
#endif // GLOBALPARAMSACTION_H
