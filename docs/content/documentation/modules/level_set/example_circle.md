[circle_16.i]: https://github.com/idaholab/moose/blob/devel/modules/level_set/examples/circle/circle_16.i

# Constant Velocity Circle
One of the simplest problems for demonstrating the level set equation is to apply a constant velocity field to an
initial field, in this case a circle in two dimensions. The following example assumes that you have a compiled and
working level set module executable and is based on the content in the `moose/modules/level_set/circle` directory.

## Create Input File
This example begins by defining a minimal input file for solving the level set equation. The input file that is used
initially is [circle_16.i].

### Mesh
First, the [Mesh](/Mesh/index.md) must be defined, which for this simple problem is a rectangular two-dimensional domain
ranging from 0 to 1 in the x and y directions.

!input modules/level_set/examples/circle/circle_16.i block=Mesh label=False

### Variables
The unknown that will be solved is defined ("phi") as well as the auxiliary variables that will define the
velocity input to the level set equation. Notice that when the velocity variables are defined ("vel_x" and "vel_y")
each is defined an initial condition of 3. For this problem the velocity will remain constant, the value of which
is defined by the initial condition.

!text modules/level_set/examples/circle/circle_16.i start=[Variables] end=[ICs] label=False

### Initial Condition
The initial condition for the auxiliary variables was defined via a short-cut syntax in the previous section; however,
the "phi" variable must also be initialized. This will be accomplished by using the [LevelSetOlssonBubble](level_set/LevelSetOlssonBubble.md) function that is a part of the level set module. In this case,
a circle with a radius of 0.15 is defined at the midpoint of the domain.

!text modules/level_set/examples/circle/circle_16.i start=[ICs] end=[BCs] label=False

### Boundary Conditions
This problem assigns periodic boundary conditions for the "phi" in the x an y directions, which is easily
accomplished within MOOSE.

!input modules/level_set/examples/circle/circle_16.i block=BCs label=False

### Kernels
The level set equation (see [Theory](level_set/theory.md)) may be defined in MOOSE using two [Kernel](systems/Kernels/index.md)
objects: [TimeDerivative](framework/TimeDerivative.md) and [LevelSetAdvection](level_set/LevelSetAdvection.md).

Notice, that the [LevelSetAdvection](level_set/LevelSetAdvection.md) requires that the unknown to be solved for ("phi")
to be assigned in the "variable" parameters as well as the two velocity variables in the "velocity_x" and "velocity_y"
parameters.

!input modules/level_set/examples/circle/circle_16.i block=Kernels label=False

### Postprocessors
In this example a single [Postprocessors](/Postprocessors/index.md) is defined. The  [LevelSetCFLCondition](level_set/LevelSetCFLCondition.md) is used to define the minimum
timestep that should be used when executing the solve of this equation, as discussed in the following section.

!input modules/level_set/examples/circle/circle_16.i block=Postprocessors label=False

### Execution
This example is a transient problem, hence the [Transient](framework/Transient.md) execution is used. The other
important aspect to illustrate in the [Executioner](/Executioner/index.md) block is the use of the
[PostprocessorDT](framework/PostprocessorDT.md) time stepper, which allows for the
[LevelSetCFLCondition](level_set/LevelSetCFLCondition.md) postprocessor to govern the timestepping for this problem.

!input modules/level_set/examples/circle/circle_16.i block=Executioner label=False

### Output
Finally, the [Outputs](/Outputs/index.md) defines a single types of output. The exodus output contains the
mesh and field data for the simulation.

!input modules/level_set/examples/circle/circle_16.i block=Outputs label=False

## Results

!figure docs/media/level_set/example_circle_16.gif width=40% margin-left=10px float=right id=example_circle_16 caption=Results of executing [circle_16.i] showing the "phi" field variable and the  0.5 contour initially (black) and as the solution progresses (green).

Figure \ref{example_circle_16} show the results of the simulation defined by executing the [circle_16.i] input file,
which can be done using the following commands.

```bash
cd ~/projects/moose/modules/level_set/examples/circle
../../level_set-opt -i circle_16.i
```

Given the constant velocity of 3 in the input file for the x and y directions the
initial circle translates at a 45 degree angle and performs three complete transects of the domain, more or less
cycles could be achieved by altering the end time in the Executioner block.

Ideally, the circle would maintain it shape throughout the simulation since it is simply being advected by a constant
velocity. This is not the case in the results shown in Figure \ref{example_circle_16}, which clearly shows the
initial circle being deformed during the simulation.

One method to improve the solution is to increase the number of finite elements in the mesh, which can be done
from the command line:

```bash
../../level_set-opt -i circle_16.i Mesh/uniform_refine=2
```

This will cause two uniform refinements of the mesh. Doing this increases the problem size dramatically due to the
increased number of elements and for this problem it also causes the time step to decrease because the timestep is
a function of the element size (see [LevelSetCFLCondition](level_set/LevelSetCFLCondition.md)). For this simple
example, the increased number of timesteps and the increased problem size are noticeable but do not cause an
intractable increase of run time.

!figure docs/media/level_set/example_circle_64.gif width=40% margin-left=10px float=right id=example_circle_64 caption=Results of executing [circle_16.i], with two uniform refinement levels, showing the "phi" field variable and the  0.5 contour initially (black) and as the solution progresses (green).

Figure \ref{example_circle_64} shows the results from running [circle_16.i] with two uniform refinements applied, the
improvement in the solution is drastic and for this simple example may be adequate.
