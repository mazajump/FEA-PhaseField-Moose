# LevelSetOlssonVortex

!description /Functions/LevelSetOlssonVortex

One of the most often utilized benchmark problems for the level set equation involve a vortex velocity field in two-dimensions that result in a full reversal of the advected variable after some time. The LevelSetOlssonVortex provides the velocity in the x and y direction ($v_x$ and $v_y$) defined by \citet{olsson2005conservative} as:

$$ \begin{align} v_x &= \sin^2(\pi x)\sin(2\pi y)\ v_y &= -\sin^2(\pi y) \sin(2\pi x) \end{align} $$

There are two methods defined for reversing the velocity direction ("instantenous" and "cosine"). The former simply switches the sine of the velocity at mid-point of the provided reversal time. The later applies a cosine multiplier so that the reversal is smooth.
Example Input Syntax

!input modules/level_set/tests/functions/olsson_vortex/olsson_vortex.i block=Functions

!parameters /Functions/LevelSetOlssonVortex

!inputfiles /Functions/LevelSetOlssonVortex

!childobjects /Functions/LevelSetOlssonVortex

## References
\bibliographystyle{unsrt}
\bibliography{docs/bib/level_set.bib}
