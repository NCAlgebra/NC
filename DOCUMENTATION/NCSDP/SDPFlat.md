## SDPFlat {#PackageSDPFlat}

`SDPFlat` is a package that provides data structures for the numeric solution
of semidefinite programs of the form:
$$
\begin{aligned}
  \max_{y, S} \quad & b^T y \\
  \text{s.t.} \quad & A y + S = c \\
                    & S \succeq 0
\end{aligned}
$$
where $S$ is a symmetric positive semidefinite matrix and $y$ is a
vector of decision variables.

It is a potentially more efficient alternative to the basic
implementation provided by the package [SDP](#PackageSDP).

Members are:

* [SDPFlatData](#SDPFlatData)
* [SDPFlatPrimalEval](#SDPFlatPrimalEval)
* [SDPFlatDualEval](#SDPFlatDualEval)
* [SDPFlatSylvesterEval](#SDPFlatSylvesterEval)

### SDPFlatData {#SDPFlatData}

`SDPFlatData[{a,b,c}]` converts the triplet `{a,b,c}` from the format
of the package [SDP](#PackageSDP) to the `SDPFlat` format.

It returns a list with four entries:

- The first is the input array `a`;
- The second is its flattened version `AFlat`;
- The third is the flattened version of `c`, `cFlat`;
- The fourth is an array with the flattened dimensions.

See also:
[SDP](#PackageSDP).

### SDPFlatPrimalEval {#SDPFlatPrimalEval}

`SDPFlatPrimalEval[aFlat, y]` evaluates the linear function $A y$ in an `SDPFlat`.

See also:
[SDPFlatDualEval](#SDPFlatDualEval),
[SDPFlatSylvesterEval](#SDPFlatSylvesterEval).

### SDPFlatDualEval {#SDPFlatDualEval}

`SDPFlatDualEval[aFlat, X]` evaluates the linear function $A^* X$ in an `SDPFlat`.

See also:
[SDPFlatPrimalEval](#SDPFlatPrimalEval),
[SDPFlatSylvesterEval](#SDPFlatSylvesterEval).

### SDPFlatSylvesterEval {#SDPFlatSylvesterEval}

`SDPFlatSylvesterEval[a, aFlat, W]` returns a matrix
representation of the Sylvester mapping $A^* (W A (\Delta_y) W)$
when applied to the scaling `W`.

`SDPFlatSylvesterEval[a, aFlat, Wl, Wr]` returns a matrix
representation of the Sylvester mapping $A^* (W_l A (\Delta_y) W_r)$
when applied to the left- and right-scalings `Wl` and `Wr`.

See also:
[SDPFlatPrimalEval](#SDPFlatPrimalEval),
[SDPFlatDualEval](#SDPFlatDualEval).
