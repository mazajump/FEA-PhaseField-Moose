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

#ifndef USERFUNCTIONTEST_H
#define USERFUNCTIONTEST_H

// CPPUnit includes
#include "GuardedHelperMacros.h"

// Forward declarations
class MooseMesh;
class FEProblem;
class Factory;
class MooseApp;

class ParsedFunctionTest : public CppUnit::TestFixture
{

  CPPUNIT_TEST_SUITE(ParsedFunctionTest);

  CPPUNIT_TEST(basicConstructor);
  CPPUNIT_TEST(advancedConstructor);
  CPPUNIT_TEST(testVariables);
  CPPUNIT_TEST(testConstants);

  CPPUNIT_TEST_SUITE_END();

public:
  void basicConstructor();
  void advancedConstructor();
  void testVariables();
  void testConstants();

  void init();
  void finalize();

protected:
  MooseApp * _app;
  Factory * _factory;
  MooseMesh * _mesh;
  FEProblem * _fe_problem;
};

#endif // USERFUNCTIONTEST_H
