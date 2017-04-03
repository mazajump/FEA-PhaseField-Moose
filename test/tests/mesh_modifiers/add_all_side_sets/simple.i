[Mesh]
  type = FileMesh
  file = twoblocks.e
  # This MeshModifier currently only works with ReplicatedMesh.
  # For more information, refer to #2129.
  parallel_type = replicated
[]

[MeshModifiers]
  [./block_1]
    type = AddAllSideSetsByNormals
  [../]
[]

# This input file is intended to be run with the "--mesh-only" option so
# no other sections are required
