# Kim-Kim-Suzuki Example for three or more components

!text modules/phase_field/examples/kim-kim-suzuki/kks_example_ternary.i max-height=300px strip-extra-newlines=True overflow-y=scroll

When additional chemical components are added to the KKS model, a Cahn-Hilliard
equation must be added for each additional component. (For $n$ components, $n-1$
Cahn-Hilliard equations are required). Each additional Cahn-Hilliard equation
requires the kernels:

* [`KKSSplitCHCRes`](KKSSplitCHCRes.md)
* [`CoupledTimeDerivative`](framework/CoupledTimeDerivative.md)
* [`SplitCHWRes`](phase_field/SplitCHWRes.md)

To enforce the composition and chemical potential constraints, each additional component also requires the kernels

* [`KKSPhaseConcentration`](KKSPhaseConcentration.md)
* [`KKSPhaseChemicalPotential`](KKSPhaseChemicalPotential.md)

The Allen-Cahn equation is also modified when additional components are added. The residual becomes

$$
R=-\frac{dh}{d\eta} \left(F_a-F_b- \sum_{i=1}^{n-1} \frac{dF_a}{dc_{ia}}(c_{ia}-c_{ib})\right) + w\frac{dg}{d\eta}.
$$

where $n$ is the number of components. A single [`KKSACBulkF`](KKSACBulkF.md) kernel is
needed as in the 2-component case, and an additional [`KKSACBulkC`](KKSACBulkC.md)
kernel must added for each additional component.
