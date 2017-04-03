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

#ifndef XFEMINTERFACE_H
#define XFEMINTERFACE_H

#include "ConsoleStreamInterface.h"
#include "MooseTypes.h"
#include "MooseVariableBase.h"
#include "InputParameters.h"

class MooseApp;
class AuxiliarySystem;
class NonlinearSystemBase;
class MaterialData;
class FEProblemBase;

namespace libMesh
{
class MeshBase;
class QBase;
}

/**
 * This is the XFEMInterface class.  This is an abstract base
 * class that defines interfaces with a class that dynamically
 * modifies the mesh in support of a phantom node approach for XFEM
 */

// ------------------------------------------------------------
// XFEMInterface class definition
class XFEMInterface : public ConsoleStreamInterface
{
public:
  /**
   * Constructor
   */
  explicit XFEMInterface(const InputParameters & params)
    : ConsoleStreamInterface(*params.getCheckedPointerParam<MooseApp *>("_moose_app")),
      _fe_problem(params.getCheckedPointerParam<FEProblemBase *>("_fe_problem_base")),
      _material_data(NULL),
      _bnd_material_data(NULL),
      _mesh(NULL),
      _mesh2(NULL)
  {
  }

  /**
   * Destructor
   */
  virtual ~XFEMInterface() {}

  /**
   * Set the pointer to the primary mesh that is modified by XFEM
   */
  void setMesh(MeshBase * mesh) { _mesh = mesh; }

  /**
   * Set the pointer to the secondary (displaced) mesh that is modified by XFEM
   */
  void setSecondMesh(MeshBase * mesh2) { _mesh2 = mesh2; }

  /**
   * Set the pointer to the MaterialData
   */
  void setMaterialData(std::vector<std::shared_ptr<MaterialData>> * material_data)
  {
    _material_data = material_data;
  }

  /**
   * Set the pointer to the Boundary MaterialData
   */
  void setBoundaryMaterialData(std::vector<std::shared_ptr<MaterialData>> * bnd_material_data)
  {
    _bnd_material_data = bnd_material_data;
  }

  /**
   * Method to update the mesh due to modified cut definitions
   */
  virtual bool update(Real time) = 0;

  /**
   * Initialize the solution on newly created nodes
   */
  virtual void initSolution(NonlinearSystemBase & nl, AuxiliarySystem & aux) = 0;

  /**
   * Get the factors for the QP weighs for XFEM partial elements
   */
  virtual bool getXFEMWeights(MooseArray<Real> & weights,
                              const Elem * elem,
                              QBase * qrule,
                              const MooseArray<Point> & q_points) = 0;

protected:
  FEProblemBase * _fe_problem;
  std::vector<std::shared_ptr<MaterialData>> * _material_data;
  std::vector<std::shared_ptr<MaterialData>> * _bnd_material_data;

  MeshBase * _mesh;
  MeshBase * _mesh2;
};

#endif // XFEMINTERFACE_H
