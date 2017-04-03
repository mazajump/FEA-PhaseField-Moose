
# OrientedBoxMarker
!description /Adaptivity/Markers/OrientedBoxMarker

## Description
The `OrientedBoxMarker` operates the in a similar
fashion as the [BoxMarker](/BoxMarker.md); however, the box is
defined given a center, width, length, and height. The box is then
oriented by defining direction vectors for the width and length
dimensions.

The refinement flags for elements inside and/or outside of the box are
then defined.

## Example Input Syntax
!input test/tests/markers/oriented_box_marker/obm.i block=Adaptivity

!parameters /Adaptivity/Markers/OrientedBoxMarker

!inputfiles /Adaptivity/Markers/OrientedBoxMarker

!childobjects /Adaptivity/Markers/OrientedBoxMarker
