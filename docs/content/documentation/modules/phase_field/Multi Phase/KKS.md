# Kim-Kim-Suzuki Model

The Kim-Kim-Suzuki (KKS) model in its current implementation is an implementation of the
two-phase model presented in \cite{kim_phase-field_1999}.
It features a single order parameter $\eta$, but has - compared to the [WBM](Multi Phase/WBM.md) -
the added complexity of introducing phase-concentrations $(c_a, c_b)$, i.e. a
concentration variable for each component and each phase, in addition to the
global concentrations ($c$).

$$
c=\left(1-h(\eta)\right)c_a + h(\eta)c_b
$$

The main advantage this addition yields is the ability to chose the interfacial
free energy of the system _independent_ of the interfacial width (and thus length scale).
KKS models are especially suited for systems with high heat of solution, which in
conventional phase field models can lead to unphysically high interfacial free
energies due to the miscibility gap contributions along the smooth interface.

Note that while the KKS implementation is for two-_phase_ systems it allows for
an arbitrary number of _components_, whereas each component is represented by
one global concentration variable and two phase concentration variables.

The total free energy $F$ of the system is given by the Phase-free energies as

$$
F = \left(1-h(\eta)\right) F_a(c_a) + h(\eta)F_b(c_b) + Wg(\eta)
$$

The phase free energies are only functions of the respective phase concentrations.

The additional variables require additional constraint equations, which are the
_mass conservation_ equation (above) and the pointwise equality of the phase
chemical potentials

$$
\frac{\partial f_a}{\partial c_a} = \frac{\partial f_b}{\partial c_b}
$$

## See also

* [Derivation of the KKS system residuals and Jacobians](Multi Phase/KKS Derivations.md)
* [Comparison with the analytical solution for an equilibrium interface](Multi Phase/KKS Analytical.md) for a simple 2-component example of the KKS model.
* [KKS phase-field model with 3 or more components](Multi Phase/KKS Multi Component Example.md)

\bibliography{docs/bib/phase_field.bib}
