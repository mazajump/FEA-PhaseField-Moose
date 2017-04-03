# StitchedMesh
!description /Mesh/StitchedMesh

## Overview
The `StitchedMesh` object allows for multiple mesh files to be "stitched" together to form a single mesh for use
in a simulation. For example, consider the following three meshes.

!image docs/media/mesh/stitched_mesh_left.png width=32% float=left caption=Fig. 1: Left portion of "stitched" mesh (left.e).

!image docs/media/mesh/stitched_mesh_center.png width=32% float=left margin-left=2% caption=Fig. 2: Center portion of "stitched" mesh (center.e).

!image docs/media/mesh/stitched_mesh_right.png width=32% float=right caption=Fig. 3: Right portion of "stitched" mesh (right.e).

Using the `StitchedMesh` object from within the [Mesh](/Mesh/index.md) block of the input file, as shown in the input
file snippet below, these three square meshes are joined into a single mesh as shown in Figure 4.

!input test/tests/mesh/stitched_mesh/stitched_mesh.i block=Mesh

!image docs/media/mesh/stitched_mesh_out.png caption=Fig. 4: Resulting "stitched" mesh from combination of three square meshes.

!parameters /Mesh/StitchedMesh

!inputfiles /Mesh/StitchedMesh

!childobjects /Mesh/StitchedMesh
