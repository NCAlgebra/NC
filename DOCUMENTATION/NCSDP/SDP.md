## SDP {#PackageSDP}

`SDP` is a package that provides data structures for the numeric solution
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

See the package [SDP](#PackageSDP) for a potentially more efficient
alternative to the basic implementation provided by this package.

Members are:

* [SDPMatrices](#SDPMatrices)
* [SDPSolve](#SDPSolve)
* [SDPEval](#SDPEval)
* [SDPPrimalEval](#SDPPrimalEval)
* [SDPDualEval](#SDPDualEval)
* [SDPSylvesterEval](#SDPSylvesterEval)

### SDPMatrices {#SDPMatrices}

`SDPMatrices[f, G, y]` converts the symbolic linear functions `f`,
`G` in the variables `y` associated to the semidefinite program:

$$
\begin{aligned} 
  \min_y \quad & f(y), \\
  \text{s.t.} \quad & G(y) \succeq 0
\end{aligned}
$$

into numerical data that can be used to solve an SDP in the form:

$$
\begin{aligned}
  \max_{y, S} \quad & b^T y \\
  \text{s.t.} \quad & A y + S = c \\
                    & S \succeq 0
\end{aligned}
$$

`SDPMatrices` returns a list with three entries:

- The first is the coefficient array `A`;
- The second is the coefficient array `b`;
- The third is the coefficient array `c`.

For example:

	f = -x
	G = {{1, x}, {x, 1}}
	vars = {x}
	{A,b,c} = SDPMatrices[f, G, vars]

results in

	A = {{{{0, -1}, {-1, 0}}}}
	b = {{{1}}}
	c = {{{1, 0}, {0, 1}}}

All data is stored as `SparseArray`s.

See also:
[SDPSolve](#SDPSolve).

### SDPSolve {#SDPSolve}

`SDPSolve[{A,b,c}]` solves an SDP in the form:

$$
\begin{aligned}
  \max_{y, S} \quad & b^T y \\
  \text{s.t.} \quad & A y + S = c \\
                    & S \succeq 0
\end{aligned}
$$

`SDPSolve` returns a list with four entries:

- The first is the primal solution $y$;
- The second is the dual solution $X$;
- The third is the primal slack variable $S$;
- The fourth is a list of flags:
    - `PrimalFeasible`: `True` if primal problem is feasible;
    - `FeasibilityRadius`: less than one if primal problem is feasible;
    - `PrimalFeasibilityMargin`: close to zero if primal problem is feasible;
    - `DualFeasible`: `True` if dual problem is feasible;
    - `DualFeasibilityRadius`: close to zero if dual problem is feasible. 

For example:

    {Y, X, S, flags} = SDPSolve[abc]
	
solves the SDP `abc`.

`SDPSolve[{A,b,c}, options]` uses `options`.

`options` are those of [PrimalDual](#PrimalDual).

See also:
[SDPMatrices](#SDPMatrices).

### SDPEval {#SDPEval}

`SDPEval[A, y]` evaluates the linear function $A y$ in an `SDP`.

This is a convenient replacement for [SDPPrimalEval](#SDPPrimalEval) in which the list `y` can be used directly.

See also:
[SDPPrimalEval](#SDPPrimalEval),
[SDPDualEval](#SDPDualEval),
[SDPSolve](#SDPSolve),
[SDPMatrices](#SDPMatrices).

### SDPPrimalEval {#SDPPrimalEval}

`SDPPrimalEval[A, {{y}}]` evaluates the linear function $A y$ in an `SDP`.

See [SDPEval](#SDPEval) for a convenient replacement for `SDPPrimalEval` in which the list `y` can be used directly.

See also:
[SDPEval](#SDPEval),
[SDPDualEval](#SDPDualEval),
[SDPSolve](#SDPSolve),
[SDPMatrices](#SDPMatrices).

### SDPDualEval {#SDPDualEval}

`SDPDualEval[A, X]` evaluates the linear function $A^* X$ in an `SDP`.

See also:
[SDPPrimalEval](#SDPPrimalEval),
[SDPSolve](#SDPSolve),
[SDPMatrices](#SDPMatrices).

### SDPSylvesterEval {#SDPSylvesterEval}

`SDPSylvesterEval[a, W]` returns a matrix
representation of the Sylvester mapping $A^* (W A (\Delta_y) W)$
when applied to the scaling `W`.

`SDPSylvesterEval[a, Wl, Wr]` returns a matrix
representation of the Sylvester mapping $A^* (W_l A (\Delta_y) W_r)$
when applied to the left- and right-scalings `Wl` and `Wr`.

See also:
[SDPPrimalEval](#SDPPrimalEval),
[SDPDualEval](#SDPDualEval).
