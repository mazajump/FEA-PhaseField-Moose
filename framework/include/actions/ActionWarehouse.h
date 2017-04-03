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

#ifndef ACTIONWAREHOUSE_H
#define ACTIONWAREHOUSE_H

#include <string>
#include <set>
#include <map>
#include <vector>
#include <list>
#include <ostream>

// MOOSE includes
#include "Action.h"
#include "ConsoleStreamInterface.h"

/// alias to hide implementation details
using ActionIterator = std::list<Action *>::iterator;

class MooseMesh;
class Syntax;
class ActionFactory;
class FEProblem;

/**
 * Storage for action instances.
 */
class ActionWarehouse : public ConsoleStreamInterface
{
public:
  ActionWarehouse(MooseApp & app, Syntax & syntax, ActionFactory & factory);
  ~ActionWarehouse();

  /**
   * Builds all auto-buildable tasks.  This method is typically called after the Parser has
   * created Actions based on an input file.
   */
  void build();

  /**
   * This method deletes all of the Actions in the warehouse.
   */
  void clear();

  /**
   * \p returns a Boolean indicating whether the warehouse is empty or not.
   */
  bool empty() const { return _action_blocks.empty(); }

  /**
   * This method add an \p Action instance to the warehouse.
   */
  void addActionBlock(std::shared_ptr<Action> blk);

  /**
   * This method checks the actions stored in the warehouse against the list of required registered
   * actions to see if all of them have been satisfied.  It should be called before running
   * a MOOSE problem
   */
  void checkUnsatisfiedActions() const;

  /**
   * This method is used only during debugging when \p show_actions is set to \p true.
   * It prints all of the actions sets in the correct dependency resolved order with
   * all of the Action objects inside.
   */
  void printActionDependencySets() const;

  /**
   * This method uses the Actions in the warehouse to reproduce the input file.  This method
   * is useful for debugging as it can assist in finding difficult to track parsing or input
   * file problems.
   * @param out A writable \p ostream object where the output will be sent.
   */
  void printInputFile(std::ostream & out);

  /**
   * Iterators to the Actions in the warehouse.  Iterators should always be used when executing
   * Actions to capture dynamically added Actions (meta-Actions).  Meta-Actions are allowed to
   * create and add additional Actions to the warehouse on the fly.  Those Actions will fire
   * as long as their associated task hasn't already passed (i.e. matches or is later).
   */
  ActionIterator actionBlocksWithActionBegin(const std::string & task);
  ActionIterator actionBlocksWithActionEnd(const std::string & task);

  /**
   * Retrieve a constant list of \p Action pointers associated with the passed in task.
   */
  const std::list<Action *> & getActionListByName(const std::string & task) const;

  /**
   * Retrieve an action with its name and the desired type.
   * @param name The action name.
   */
  template <class T>
  const T & getAction(const std::string & name)
  {
    T * p = NULL;
    for (auto i = beginIndex(_all_ptrs); i < _all_ptrs.size(); ++i)
    {
      auto act = _all_ptrs[i].get();
      if (act->name() == name)
      {
        p = dynamic_cast<T *>(act);
        if (p)
          break;
      }
    }
    if (!p)
      mooseError("Action with name being ", name, " does not exist");
    return *p;
  }

  /**
   * Retrieve all actions in a specific type ordered by their names.
   */
  template <class T>
  std::vector<const T *> getActions()
  {
    // we need to create the map first to ensure that all actions in the map are unique
    // and the actions are sorted by their names
    std::map<std::string, const T *> actions;
    for (auto i = beginIndex(_all_ptrs); i < _all_ptrs.size(); ++i)
    {
      auto act = _all_ptrs[i].get();
      T * p = dynamic_cast<T *>(act);
      if (p)
        actions.insert(std::pair<std::string, const T *>(act->name(), p));
    }
    // construct the vector from the map entries
    std::vector<const T *> action_vector;
    for (auto & pair : actions)
      action_vector.push_back(pair.second);
    return action_vector;
  }

  /**
   * Check if Actions associated with passed in task exist.
   */
  bool hasActions(const std::string & task) const;

  /**
   * This method loops over all actions in the warehouse and executes them.  Meta-actions
   * may add new actions to the warehouse on the fly and they will still be executed in order
   */
  void executeAllActions();

  /**
   * This method executes only the actions in the warehouse that satisfy the task
   * passed in.
   */
  void executeActionsWithAction(const std::string & name);

  /**
   * This method sets a Boolean which is used to show debugging information during
   * various warehouse operations during the problem setup phase.
   * @param state Flag indicating whether to show action information.
   */
  void showActions(bool state = true) { _show_actions = state; }

  void showParser(bool state = true) { _show_parser = state; }

  //// Getters
  Syntax & syntax() { return _syntax; }

  // We are not really using the reference counting capabilities of
  // shared pointers here, just their memory management capability.
  // Therefore, _mesh is actually being used more like a unique_ptr in
  // this context.  Since full support for unique_ptr is not quite
  // available yet, we've implemented it as a std::shared_ptr.
  std::shared_ptr<MooseMesh> & mesh() { return _mesh; }
  std::shared_ptr<MooseMesh> & displacedMesh() { return _displaced_mesh; }

  std::shared_ptr<FEProblemBase> & problemBase() { return _problem; }
  std::shared_ptr<FEProblem> problem();
  MooseApp & mooseApp() { return _app; }
  const std::string & getCurrentTaskName() const { return _current_task; }

protected:
  /**
   * This method auto-builds all Actions that needs to be built and adds them to ActionWarehouse.
   * An Action needs to be built if it is associated with a task that is marked as required and
   * all of it's parameters are valid (are not required or have default values supplied).
   *
   * @param task The name of the task to find and build Actions for.
   */
  void buildBuildableActions(const std::string & task);

  std::vector<std::shared_ptr<Action>> _all_ptrs;

  /// The MooseApp this Warehouse is associated with
  MooseApp & _app;
  /// Reference to a "syntax" of actions
  Syntax & _syntax;
  /// The Factory that builds Actions
  ActionFactory & _action_factory;
  /// Pointers to the actual parsed input file blocks
  std::map<std::string, std::list<Action *>> _action_blocks;
  /// Action blocks that have been requested
  std::map<std::string, std::vector<Action *>> _requested_action_blocks;
  /// The container that holds the sorted action names from the DependencyResolver
  std::vector<std::string> _ordered_names;
  /// Use to store the current list of unsatisfied dependencies
  std::set<std::string> _unsatisfied_dependencies;

  /**
   *  Flag to indicate whether or not there is an active iterator on this class.
   *  There can only be a single active iterator because of the potential for
   *  meta Actions to add new Actions into the warehouse on the fly
   */
  bool _generator_valid;

  // DEBUGGING
  bool _show_actions;
  bool _show_parser;

  // When executing the actions in the warehouse, this string will always contain
  // the current task name
  std::string _current_task;

  //
  // data created by actions
  //

  /// Mesh class
  std::shared_ptr<MooseMesh> _mesh;

  /// Possible mesh for displaced problem
  std::shared_ptr<MooseMesh> _displaced_mesh;

  /// Problem class
  std::shared_ptr<FEProblemBase> _problem;
};

#endif // ACTIONWAREHOUSE_H
