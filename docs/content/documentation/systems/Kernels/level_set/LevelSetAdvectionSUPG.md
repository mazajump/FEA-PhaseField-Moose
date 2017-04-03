# LevelSetAdvectionSUPG
This kernel adds the Streamline Upwind/Petrov-Galerkin (SUPG) stabilization
term \citep{brooks1982streamline, donea2003finite} to the advection term of the level set equation.

\begin{equation}
\label{eq:LevelSetAdvectionSUPG:weak}
\left(-\tau \vec{v} \psi_i,\, \vec{v}\cdot\nabla u_h\right) = 0,
\end{equation}

where $\vec{v}$ is the level set velocity, $f$ is the forcing term, and $\tau$ as defined below.

\begin{equation}
\label{eq:LevelSetAdvectionSUPG:tau}
\tau = \frac{h}{2\|\vec{v}\|},
\end{equation}

where $h$ is the element length.

## Example Syntax
The LevelSetAdvectionSUPG [Kernel](systems/Kernels/index.md) should be used in conjunction with a complete level set equation.
For example, the following provides the necessary objects for the complete level set equation
with SUPG stabilization.

!input modules/level_set/examples/vortex/vortex_supg.i block=Kernels label=False


!parameters /Kernels/LevelSetAdvectionSUPG

!inputfiles /Kernels/LevelSetAdvectionSUPG

!childobjects /Kernels/LevelSetAdvectionSUPG

## References

\bibliographystyle{unsrt}
\bibliography{docs/bib/level_set.bib}
