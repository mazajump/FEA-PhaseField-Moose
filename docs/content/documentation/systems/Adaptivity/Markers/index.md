# Markers System

The marker system is a sub-system of the [Adaptivity system](systems/Adaptivity/index.md)
in MOOSE. The `Marker` objects serve to set the refinement flag to one of
four states as defined by the C++ Enum `MarkerValue`. MOOSE
will call the `computeElementMarker` method,
which returns a `MarkerValue`. This value is then applied to an
elemental [AuxVariable](systems/AuxVariables/index.md). The automatic mesh
refinement engine will then use this field to refine and coarsen the
mesh in a consistent manner, as detailed in the [Adaptivity system](systems/Adaptivity/index.md).

## Marker Values
The four possible `MarkerValue` states are defined in `Marker.h` as
follows:

!text framework/include/markers/Marker.h include_end=True start=enum MarkerValue end=};

The purpose of each value of the `MarkerValue` is define in the
following table.

| State | Description |
| ----- | ----------- |
| DONT_MARK | Do not apply any refinement flag to the element. |
| COARSEN | Marks an element to be coarsened, if possible. |
| DO_NOTHING | Does not change the marker flag from the current state. |
| REFINE | Marks and element to be refined, if possible. |

## Example Syntax
!input test/tests/markers/combo_marker/combo_marker_test.i block=Adaptivity

!subobjects /Adaptivity/Markers title=Available Marker Objects
