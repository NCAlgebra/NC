## SDPSylvester {#PackageSDPSylvester}

`SDPSylvester` is a package that provides data structures for the
numeric solution of semidefinite programs of the form:
$$
\begin{aligned}
  \max_{y, S} \quad & \sum_i \operatorname{trace}(b_i^T y_i) \\
  \text{s.t.} \quad & A y + S = \frac{1}{2} \sum_i a_i y_i b_i + (a_i y_i b_i)^T + S = C \\
                    & S \succeq 0
\end{aligned}
$$
where $S$ is a symmetric positive semidefinite matrix and $y = \{ y_1, \ldots, y_n \}$ is a list of matrix decision variables.

Members are:

* [SDPEval](#SDPSylvesterSDPEval)
* [SDPSylvesterPrimalEval](#SDPSylvesterPrimalEval)
* [SDPSylvesterDualEval](#SDPSylvesterDualEval)
* [SDPSylvesterSylvesterEval](#SDPSylvesterSylvesterEval)

### SDPEval {#SDPSylvesterSDPEval}

`SDPEval[A, y]` evaluates the linear function $A y = \frac{1}{2} \sum_i a_i y_i b_i + (a_i y_i b_i)^T$ in an `SDPSylvester`.

This is a convenient replacement for [SDPSylvesterPrimalEval](#SDPSylvesterPrimalEval) in which the list `y` can be used directly.

See also:
[SDPSylvesterPrimalEval](#SDPSylvesterPrimalEval),
[SDPSylvesterDualEval](#SDPSylvesterDualEval).

### SDPSylvesterPrimalEval {#SDPSylvesterPrimalEval}

`SDPSylvesterPrimalEval[a, y]` evaluates the linear function $A y = \frac{1}{2} \sum_i a_i y_i b_i + (a_i y_i b_i)^T$ in an `SDPSylvester`.

See [SDPSylvesterEval](#SDPSylvesterEval) for a convenient replacement for `SDPPrimalEval` in which the list `y` can be used directly.

See also:
[SDPSylvesterDualEval](#SDPSylvesterDualEval),
[SDPSylvesterSylvesterEval](#SDPSylvesterSylvesterEval).

### SDPSylvesterDualEval {#SDPSylvesterDualEval}

`SDPSylvesterDualEval[A, X]` evaluates the linear function $A^* X = \{ b_1 X a_1, \cdots, b_n X a_n \}$ in an `SDPSylvester`.

For example

See also:
[SDPSylvesterPrimalEval](#SDPSylvesterPrimalEval),
[SDPSylvesterSylvesterEval](#SDPSylvesterSylvesterEval).

### SDPSylvesterSylvesterEval {#SDPSylvesterSylvesterEval}

`SDPSylvesterEval[a, W]` returns a matrix
representation of the Sylvester mapping $A^* (W A (\Delta_y) W)$
when applied to the scaling `W`.

`SDPSylvesterEval[a, Wl, Wr]` returns a matrix
representation of the Sylvester mapping $A^* (W_l A (\Delta_y) W_r)$
when applied to the left- and right-scalings `Wl` and `Wr`.

See also:
[SDPSylvesterPrimalEval](#SDPSylvesterPrimalEval),
[SDPSylvesterDualEval](#SDPSylvesterDualEval).
