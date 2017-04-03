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

#ifndef MULTIAPPDTKUSEROBJECTTRANSFER_H
#define MULTIAPPDTKUSEROBJECTTRANSFER_H

#include "libmesh/libmesh_config.h"

#ifdef LIBMESH_TRILINOS_HAVE_DTK

// MOOSE includes
#include "MultiAppTransfer.h"
#include "MooseVariableInterface.h"
#include "MultiAppDTKUserObjectEvaluator.h"

// libMesh includes
#include "libmesh/dtk_adapter.h"

// Ignore warnings coming from DTK/Trilinos headers
#include "libmesh/ignore_warnings.h"

// DTK includes
#include <DTK_VolumeSourceMap.hpp>
#include <DTK_MeshManager.hpp>
#include <DTK_MeshContainer.hpp>
#include <DTK_MeshTypes.hpp>
#include <DTK_MeshTraitsFieldAdapter.hpp>
#include <DTK_FieldEvaluator.hpp>
#include <DTK_FieldManager.hpp>
#include <DTK_FieldContainer.hpp>
#include <DTK_FieldTools.hpp>
#include <DTK_CommTools.hpp>
#include <DTK_GeometryManager.hpp>
#include <DTK_Box.hpp>

// Trilinos includes
#include <Teuchos_RCP.hpp>
#include <Teuchos_ArrayRCP.hpp>
#include <Teuchos_CommHelpers.hpp>
#include <Teuchos_DefaultComm.hpp>
#include <Teuchos_GlobalMPISession.hpp>
#include <Teuchos_Ptr.hpp>

// Restore the warnings.
#include "libmesh/restore_warnings.h"

// Forward declarations
class MultiAppDTKUserObjectTransfer;
class DTKInterpolationAdapter;

template <>
InputParameters validParams<MultiAppDTKUserObjectTransfer>();

/**
 * Transfers from spatially varying UserObjects in a MultiApp to the "master" system.
 */
class MultiAppDTKUserObjectTransfer : public MultiAppTransfer, public MooseVariableInterface
{
public:
  MultiAppDTKUserObjectTransfer(const InputParameters & parameters);

  typedef long unsigned int GlobalOrdinal;

  virtual void execute() override;

protected:
  std::string _user_object_name;

  bool _setup;

  Teuchos::RCP<const Teuchos::MpiComm<int>> _comm_default;

  Teuchos::RCP<MultiAppDTKUserObjectEvaluator> _multi_app_user_object_evaluator;

  Teuchos::RCP<
      DataTransferKit::FieldEvaluator<GlobalOrdinal, DataTransferKit::FieldContainer<double>>>
      _field_evaluator;

  Teuchos::RCP<DataTransferKit::GeometryManager<DataTransferKit::Box, GlobalOrdinal>>
      _multi_app_geom;

  DTKInterpolationAdapter * _to_adapter;

  DataTransferKit::VolumeSourceMap<DataTransferKit::Box,
                                   GlobalOrdinal,
                                   DataTransferKit::MeshContainer<GlobalOrdinal>> * _src_to_tgt_map;

  Teuchos::RCP<DataTransferKit::FieldManager<DTKAdapter::FieldContainerType>> _to_values;
};

#endif // LIBMESH_TRILINOS_HAVE_DTK
#endif // MULTIAPPDTKUSEROBJECTTRANSFER_H
