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

#ifndef FACTORY_H
#define FACTORY_H

#include <set>
#include <vector>
#include <time.h>

// MOOSE includes
#include "MooseObject.h"
#include "MooseTypes.h"
#include "FileLineInfo.h"

// Forward declarations
class InputParameters;

/**
 * Macros
 */
#define stringifyName(name) #name
#define registerObject(name) factory.reg<name>(stringifyName(name), __FILE__, __LINE__)
#define registerNamedObject(obj, name) factory.reg<obj>(name, __FILE__, __LINE__)
#define registerDeprecatedObject(name, time)                                                       \
  factory.regDeprecated<name>(stringifyName(name), time, __FILE__, __LINE__)
#define registerDeprecatedObjectName(obj, name, time)                                              \
  factory.regReplaced<obj>(stringifyName(obj), name, time, __FILE__, __LINE__)

// for backward compatibility
#define registerKernel(name) registerObject(name)
#define registerNodalKernel(name) registerObject(name)
#define registerBoundaryCondition(name) registerObject(name)
#define registerAux(name) registerObject(name)
#define registerAuxKernel(name) registerObject(name)
#define registerMaterial(name) registerObject(name)
#define registerPostprocessor(name) registerObject(name)
#define registerVectorPostprocessor(name) registerObject(name)
#define registerInitialCondition(name) registerObject(name)
#define registerDamper(name) registerObject(name)
#define registerDiracKernel(name) registerObject(name)
#define registerDGKernel(name) registerObject(name)
#define registerInterfaceKernel(name) registerObject(name)
#define registerExecutioner(name) registerObject(name)
#define registerFunction(name) registerObject(name)
#define registerDistribution(name) registerObject(name)
#define registerMesh(name) registerObject(name)
#define registerMeshModifier(name) registerObject(name)
#define registerConstraint(name) registerObject(name)
#define registerScalarKernel(name) registerObject(name)
#define registerUserObject(name) registerObject(name)
#define registerPreconditioner(name) registerObject(name)
#define registerIndicator(name) registerObject(name)
#define registerMarker(name) registerObject(name)
#define registerProblem(name) registerObject(name)
#define registerMultiApp(name) registerObject(name)
#define registerTransfer(name) registerObject(name)
#define registerTimeStepper(name) registerObject(name)
#define registerTimeIntegrator(name) registerObject(name)
#define registerPredictor(name) registerObject(name)
#define registerSplit(name) registerObject(name)
#define registerOutput(name) registerObject(name)
#define registerControl(name) registerObject(name)
#define registerPartitioner(name) registerObject(name)

#define registerNamedKernel(obj, name) registerNamedObject(obj, name)
#define registerNamedNodalKernel(obj, name) registerNamedObject(obj, name)
#define registerNamedBoundaryCondition(obj, name) registerNamedObject(obj, name)
#define registerNamedAux(obj, name) registerNamedObject(obj, name)
#define registerNamedAuxKernel(name) registerNamedObject(obj, name)
#define registerNamedMaterial(obj, name) registerNamedObject(obj, name)
#define registerNamedPostprocessor(obj, name) registerNamedObject(obj, name)
#define registerNamedVectorPostprocessor(obj, name) registerNamedObject(obj, name)
#define registerNamedInitialCondition(obj, name) registerNamedObject(obj, name)
#define registerNamedDamper(obj, name) registerNamedObject(obj, name)
#define registerNamedDiracKernel(obj, name) registerNamedObject(obj, name)
#define registerNamedDGKernel(obj, name) registerNamedObject(obj, name)
#define registerNamedExecutioner(obj, name) registerNamedObject(obj, name)
#define registerNamedFunction(obj, name) registerNamedObject(obj, name)
#define registerNamedDistribution(obj, name) registerNamedObject(obj, name)
#define registerNamedMesh(obj, name) registerNamedObject(obj, name)
#define registerNamedMeshModifier(name) registerNamedObject(obj, name)
#define registerNamedConstraint(obj, name) registerNamedObject(obj, name)
#define registerNamedUserObject(obj, name) registerNamedObject(obj, name)
#define registerNamedPreconditioner(obj, name) registerNamedObject(obj, name)
#define registerNamedIndicator(obj, name) registerNamedObject(obj, name)
#define registerNamedMarker(obj, name) registerNamedObject(obj, name)
#define registerNamedProblem(obj, name) registerNamedObject(obj, name)
#define registerNamedMultiApp(obj, name) registerNamedObject(obj, name)
#define registerNamedTransfer(obj, name) registerNamedObject(obj, name)
#define registerNamedTimeStepper(obj, name) registerNamedObject(obj, name)
#define registerNamedTimeIntegrator(obj, name) registerNamedObject(obj, name)
#define registerNamedPredictor(obj, name) registerNamedObject(obj, name)
#define registerNamedSplit(obj, name) registerNamedObject(obj, name)
#define registerNamedOutput(obj, name) registerNamedObject(obj, name)
#define registerNamedControl(obj, name) registerNamedObject(obj, name)
#define registerNamedPartitioner(obj, name) registerNamedObject(obj, name)

/**
 * alias to wrap shared pointer type
 */
using MooseObjectPtr = std::shared_ptr<MooseObject>;

/**
 * alias for validParams function
 */
using paramsPtr = InputParameters (*)();

/**
 * alias for method to build objects
 */
using buildPtr = MooseObjectPtr (*)(const InputParameters & parameters);

/**
 * alias for registered Object iterator
 */
using registeredMooseObjectIterator = std::map<std::string, paramsPtr>::iterator;

/**
 * Build an object of type T
 */
template <class T>
MooseObjectPtr
buildObject(const InputParameters & parameters)
{
  return MooseObjectPtr(new T(parameters));
}

/**
 * Generic factory class for build all sorts of objects
 */
class Factory
{
public:
  Factory(MooseApp & app);
  virtual ~Factory();

  /**
   * Register a new object
   * @param obj_name Name of the object to register
   */
  template <typename T>
  void reg(const std::string & obj_name, const std::string & file = "", int line = -1)
  {

    /*
     * If _registerable_objects has been set the user has requested that we only register some
     * subset
     * of the objects for a dynamically loaded application. The objects listed in *this*
     * application's
     * registerObjects() method will have already been registered before that member was set.
     *
     * If _registerable_objects is empty, the factory is unrestricted
     */
    if (_registerable_objects.empty() ||
        _registerable_objects.find(obj_name) != _registerable_objects.end())
    {
      if (_name_to_build_pointer.find(obj_name) == _name_to_build_pointer.end())
      {
        _name_to_build_pointer[obj_name] = &buildObject<T>;
        _name_to_params_pointer[obj_name] = &validParams<T>;
      }
      else
        mooseError("Object '" + obj_name + "' already registered.");
    }
    _name_to_line.addInfo(obj_name, file, line);
    // TODO: Possibly store and print information about objects that are skipped here?
  }
  /**
   * Gets file and line information where an object was initially registered.
   * @param name Object name
   * @return The FileLineInfo associated with name
   */
  FileLineInfo getLineInfo(const std::string & name) const;

  /**
   * Register a deprecated object that expires
   * @param obj_name The name of the object to register
   * @param t_str String containing the expiration date for the object
   */
  template <typename T>
  void regDeprecated(const std::string & obj_name,
                     const std::string t_str,
                     const std::string & file,
                     int line)
  {
    // Register the name
    reg<T>(obj_name, file, line);

    // Store the time
    _deprecated_time[obj_name] = parseTime(t_str);
  }

  /**
   * Register a deprecated object that expires and has a replacement object
   * @param obj_name The name of the object to register (the new object you want people to use)
   * @param name The name of the object that is deprecated
   * @param t_str String containing the expiration date for the object
   */
  template <typename T>
  void regReplaced(const std::string & obj_name,
                   const std::string & name,
                   const std::string t_str,
                   const std::string & file,
                   int line)
  {
    // Register the name
    regDeprecated<T>(name, t_str, file, line);

    // Store the new name
    _deprecated_name[name] = obj_name;
  }

  /**
   * Get valid parameters for the object
   * @param name Name of the object whose parameter we are requesting
   * @return Parameters of the object
   */
  InputParameters getValidParams(const std::string & name);

  /**
   * Build an object (must be registered) - THIS METHOD IS DEPRECATED (Use create<T>())
   * @param obj_name Type of the object being constructed
   * @param name Name for the object
   * @param parameters Parameters this object should have
   * @param tid The thread id that this copy will be created for
   * @param print_deprecated controls the deprecated message
   * @return The created object
   */
  std::shared_ptr<MooseObject> create(const std::string & obj_name,
                                      const std::string & name,
                                      InputParameters parameters,
                                      THREAD_ID tid = 0,
                                      bool print_deprecated = true);

  /**
   * Build an object (must be registered)
   * @param obj_name Type of the object being constructed
   * @param name Name for the object
   * @param parameters Parameters this object should have
   * @param tid The thread id that this copy will be created for
   * @return The created object
   */
  template <typename T>
  std::shared_ptr<T> create(const std::string & obj_name,
                            const std::string & name,
                            InputParameters parameters,
                            THREAD_ID tid = 0)
  {
    std::shared_ptr<T> new_object =
        std::dynamic_pointer_cast<T>(create(obj_name, name, parameters, tid, false));
    if (!new_object)
      mooseError("We expected to create an object of type '" + demangle(typeid(T).name()) +
                 "'.\nInstead we received a parameters object for type '" + obj_name +
                 "'.\nDid you call the wrong \"add\" method in your Action?");

    return new_object;
  }

  /**
   * Calling this object with a non-empty vector will cause this factory to ignore registrations
   * from any object
   * not contained within the list.
   * @param names a vector containing the names of objects that this factory will register
   */
  void restrictRegisterableObjects(const std::vector<std::string> & names);

  /**
   * Access to registered object iterator (begin)
   */
  registeredMooseObjectIterator registeredObjectsBegin() { return _name_to_params_pointer.begin(); }

  /**
   * Access to registered object iterator (end)
   */
  registeredMooseObjectIterator registeredObjectsEnd() { return _name_to_params_pointer.end(); }

  /**
   * Get a list of all constructed Moose Object types
   */
  std::vector<std::string> getConstructedObjects() const;

protected:
  /**
   * Parse time string (mm/dd/yyyy HH:MM)
   * @param t_str String with the object expiration date, this must be in the form mm/dd/yyyy HH:MM
   * @return A time_t object with the expiration date
   */
  time_t parseTime(std::string);

  /**
   * Show the appropriate message for deprecated objects
   * @param obj_name Name of the deprecated object
   */
  void deprecatedMessage(const std::string obj_name);

  /**
   * Prints error information when an object is not registered
   */
  void reportUnregisteredError(const std::string & obj_name) const;

  /// Reference to the application
  MooseApp & _app;

  /// Storage for pointers to the object
  std::map<std::string, buildPtr> _name_to_build_pointer;

  /// Storage for pointers to the parameters objects
  std::map<std::string, paramsPtr> _name_to_params_pointer;

  FileLineInfoMap _name_to_line;

  /// Storage for deprecated object experiation dates
  std::map<std::string, time_t> _deprecated_time;

  /// Storage for the deprecated objects that have replacements
  std::map<std::string, std::string> _deprecated_name;

  /// The list of objects that may be registered
  std::set<std::string> _registerable_objects;

  /// Object id count
  MooseObjectID _object_count;

  /// Constructed Moose Object types
  std::set<std::string> _constructed_types;
};

#endif /* FACTORY_H */
