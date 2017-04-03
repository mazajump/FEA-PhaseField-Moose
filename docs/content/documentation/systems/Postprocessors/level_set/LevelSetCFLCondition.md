# LevelSetCFLCondition
Computes the minimum timestep based on the Courant–Friedrichs–Lewy (CFL) condition. The CFL condition, is defined as

\begin{equation}
C = \Delta t \sum_{i=1}^{n}\frac{u_{x_i}}{\Delta x_i} \leq C_{max},
\end{equation}
where $C$ is the Courant number, $C_{max}$ is the maximum allowed Courant number, $u$ is the magnitude of the velocity, $\Delta t$ is the time step, and $\Delta x$ is
the interval distance, and $i$, in three dimensions, represents the index for the $x$, $y$, and $z$ components.

The `LevelSetCFLCondition` postprocessor estimates $C$ by using the the magnitude of the maximum velocity across
quadrature points of an element ($u_{max}$) and computing the minimum element length for all elements in the
finite element mesh ($h_min$):

\begin{equation}
C = \frac{u_{max}\Delta t}{h_{min}} \leq C_{max}.
\end{equation}

Finally, assuming that $C_{max} = 1$ the maximum allowable Courant number, the maximum allowable timestep is computed
as:

\begin{equation}
\Delta t \leq \frac{h_{min}}{u_{max}}.
\end{equation}

## Example Syntax
The [LevelSetCFLCondition](#) is added to the input file in the [`[Postprocessors]`](/Postprocessors/index.md) block
as follows.

!input modules/level_set/tests/reinitialization/master.i block=cfl label=False prefix=[Postprocessors] suffix=[] indent=2

and it is designed to work to set the timestep within the ['[TimeStepper]'](/TimeStepper/index.md) block. Also, notice
that at this point is possible to apply a "scaling" factor to the computed timestep to allow the simulation to operate
at some level below the timestep limitation.

!input modules/level_set/tests/reinitialization/master.i block=Executioner label=False

!parameters /UserObjects/LevelSetCFLCondition

!inputfiles /UserObjects/LevelSetCFLCondition

!childobjects /UserObjects/LevelSetCFLCondition
