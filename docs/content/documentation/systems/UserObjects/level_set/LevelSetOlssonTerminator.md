# LevelSetOlssonTerminator
This object is utilized to terminate a level set reinitialization solve, when steady-state for $U_h$ (see [LevelSetOlssonReinitialization](level_set/LevelSetOlssonReinitialization.md)) is detected:

\begin{equation}
  \label{eqn:steady_state}
  \frac{\|U_h^{m+1} - U_h^{m}\|}{\Delta\tau} < \delta,
\end{equation}

where $\delta$ is a problem-dependent tolerance, and $U_h^m \equiv
U_h(\tau=m\Delta \tau)$.  When steady-state is achieved, $u_h$ is set
equal to the re-initialized solution $U_h$, and the entire process
is repeated at time $t+\Delta t$.

## Example Syntax
!input modules/level_set/tests/reinitialization/reinit.i block=UserObjects

!parameters /UserObjects/LevelSetOlssonTerminator

!inputfiles /UserObjects/LevelSetOlssonTerminator

!childobjects /UserObjects/LevelSetOlssonTerminator
