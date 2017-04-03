# ImageMesh
!description /Mesh/ImageMesh

## Description
The `ImageMesh` object is a convenience tool for setting up a mesh to match the pixel structure of a two or three
dimensional image. It is generally used in union with the [ImageFunction](framework/ImageFunction.md) object to
perform simulations that rely on image data, such as setting up an initial condition of a grain structure. By default
the generated mesh is sized to the dimensions of the images and creates one element per pixel.

## Example Syntax
!input test/tests/functions/image_function/image_mesh_3d.i block=Mesh

!parameters /Mesh/ImageMesh

!inputfiles /Mesh/ImageMesh

!childobjects /Mesh/ImageMesh
