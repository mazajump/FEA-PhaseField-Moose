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

#ifndef DEPENDENCYRESOLVERTEST_H
#define DEPENDENCYRESOLVERTEST_H

// CPPUnit includes
#include "GuardedHelperMacros.h"

#include "DependencyResolver.h"

#include <string>

class DependencyResolverTest : public CppUnit::TestFixture
{
  CPPUNIT_TEST_SUITE(DependencyResolverTest);

  CPPUNIT_TEST(operatorParensTest);
  CPPUNIT_TEST(resolverSets);
  CPPUNIT_TEST(ptrTest);
  CPPUNIT_TEST(simpleTest);

  CPPUNIT_TEST_SUITE_END();

public:
  void setUp();

  void operatorParensTest();
  void resolverSets();
  void ptrTest();
  void simpleTest();

private:
  DependencyResolver<std::string> _resolver;
  DependencyResolver<std::string> _strict_ordering;
};

#endif // DEPENDENCYRESOLVERTEST_H
