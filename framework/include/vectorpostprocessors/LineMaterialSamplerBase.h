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

#ifndef LINEMATERIALSAMPLERBASE_H
#define LINEMATERIALSAMPLERBASE_H

// MOOSE includes
#include "GeneralVectorPostprocessor.h"
#include "SamplerBase.h"
#include "BlockRestrictable.h"
#include "LineSegment.h"
#include "RayTracing.h" // Moose::elementsIntersectedByLine()
#include "Assembly.h"   // Assembly::qRule()
#include "MooseMesh.h"  // MooseMesh::getMesh()
#include "SwapBackSentinel.h"
#include "FEProblem.h"

// libMesh includes
#include "libmesh/quadrature.h" // _qrule->n_points()

// Forward Declarations
class MooseMesh;
template <typename T>
class LineMaterialSamplerBase;

template <>
InputParameters validParams<LineMaterialSamplerBase<Real>>();

/**
 * This is a base class for sampling material properties for the
 * integration points in all elements that are intersected by a
 * user-defined line.  The positions of those points are output in x,
 * y, z coordinates, as well as in terms of the projected positions of
 * those points along the line.  Derived classes can be created to
 * sample arbitrary types of material properties.
 */
template <typename T>
class LineMaterialSamplerBase : public GeneralVectorPostprocessor,
                                public SamplerBase,
                                public BlockRestrictable
{
public:
  /**
   * Class constructor
   * Sets up variables for output based on the properties to be output
   * @param parameters The input parameters
   */
  LineMaterialSamplerBase(const InputParameters & parameters);

  /**
   * Initialize
   * Calls through to base class's initialize()
   */
  virtual void initialize() override;

  /**
   * Finds all elements along the user-defined line, loops through them, and samples their
   * material properties.
   */
  virtual void execute() override;

  /**
   * Finalize
   * Calls through to base class's finalize()
   */
  virtual void finalize() override;

  /**
   * Reduce the material property to a scalar for output
   * @param property The material property
   * @param curr_point The point corresponding to this material property
   * @return A scalar value from this material property to be output
   */
  virtual Real getScalarFromProperty(const T & property, const Point & curr_point) = 0;

protected:
  /// The beginning of the line
  Point _start;

  /// The end of the line
  Point _end;

  /// The material properties to be output
  std::vector<const MaterialProperty<T> *> _material_properties;

  /// The mesh
  MooseMesh & _mesh;

  /// The quadrature rule
  QBase *& _qrule;

  /// The quadrature points
  const MooseArray<Point> & _q_point;
};

template <typename T>
LineMaterialSamplerBase<T>::LineMaterialSamplerBase(const InputParameters & parameters)
  : GeneralVectorPostprocessor(parameters),
    SamplerBase(parameters, this, _communicator),
    BlockRestrictable(parameters),
    _start(getParam<Point>("start")),
    _end(getParam<Point>("end")),
    _mesh(_subproblem.mesh()),
    _qrule(_subproblem.assembly(_tid).qRule()),
    _q_point(_subproblem.assembly(_tid).qPoints())
{
  std::vector<std::string> material_property_names = getParam<std::vector<std::string>>("property");
  for (unsigned int i = 0; i < material_property_names.size(); ++i)
  {
    if (!hasMaterialProperty<T>(material_property_names[i]))
      mooseError("In LineMaterialSamplerBase material property: " + material_property_names[i] +
                 " does not exist.");
    _material_properties.push_back(&getMaterialProperty<T>(material_property_names[i]));
  }

  SamplerBase::setupVariables(material_property_names);
}

template <typename T>
void
LineMaterialSamplerBase<T>::initialize()
{
  SamplerBase::initialize();
}

template <typename T>
void
LineMaterialSamplerBase<T>::execute()
{
  std::vector<Elem *> intersected_elems;
  std::vector<LineSegment> segments;

  std::unique_ptr<PointLocatorBase> pl = _mesh.getPointLocator();
  Moose::elementsIntersectedByLine(_start, _end, _mesh, *pl, intersected_elems, segments);

  const RealVectorValue line_vec = _end - _start;
  const Real line_length(line_vec.norm());
  const RealVectorValue line_unit_vec = line_vec / line_length;
  std::vector<Real> values(_material_properties.size());

  std::set<unsigned int> needed_mat_props;
  const std::set<unsigned int> & mp_deps = getMatPropDependencies();
  needed_mat_props.insert(mp_deps.begin(), mp_deps.end());
  _fe_problem.setActiveMaterialProperties(needed_mat_props, _tid);

  for (const auto & elem : intersected_elems)
  {
    if (elem->processor_id() != processor_id())
      continue;

    if (!hasBlocks(elem->subdomain_id()))
      continue;

    _subproblem.prepare(elem, _tid);
    _subproblem.reinitElem(elem, _tid);

    // Set up Sentinel class so that, even if reinitMaterials() throws, we
    // still remember to swap back during stack unwinding.
    SwapBackSentinel sentinel(_fe_problem, &FEProblem::swapBackMaterials, _tid);
    _fe_problem.reinitMaterials(elem->subdomain_id(), _tid);

    for (unsigned int qp = 0; qp < _qrule->n_points(); ++qp)
    {
      const RealVectorValue qp_pos(_q_point[qp]);

      const RealVectorValue start_to_qp(qp_pos - _start);
      const Real qp_proj_dist_along_line = start_to_qp * line_unit_vec;

      if (qp_proj_dist_along_line < 0 || qp_proj_dist_along_line > line_length)
        continue;

      for (unsigned int j = 0; j < _material_properties.size(); ++j)
        values[j] = getScalarFromProperty((*_material_properties[j])[qp], _q_point[qp]);

      addSample(_q_point[qp], qp_proj_dist_along_line, values);
    }
  }
  _fe_problem.clearActiveMaterialProperties(_tid);
}

template <typename T>
void
LineMaterialSamplerBase<T>::finalize()
{
  SamplerBase::finalize();
}

#endif
