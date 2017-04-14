## SDP {#PackageSDP}

`SDP` is a package that provides algorithms for the numeric solution
of semidefinite programs. Semidefinite programs are optimization
problems of the form:
$$
\begin{aligned}
  \max_{y, S} \quad & b^T y \\
  \text{s.t.} \quad & A y + S = c \\
                    & S \succeq 0
\end{aligned}
$$
where $S$ is a symmetric positive semidefinite matrix and $y$ is a
vector of decision variables.

Members are:

* [SDPMatrices](#SDPMatrices)
* [SDPSolve](#SDPSolve)
* [SDPEval](#SDPEval)
* [SDPInner](#SDPInner)

The following members are not supposed to be called directly by users:

* [SDPCheckDimensions](#SDPCheckDimensions)
* [SDPScale](#SDPScale)
* [SDPFunctions](#SDPFunctions)
* [SDPPrimalEval](#SDPPrimalEval)
* [SDPDualEval](#SDPDualEval)
* [SDPSylvesterEval](#SDPSylvesterEval)
* [SDPSylvesterDiagonalEval](#SDPSylvesterDiagonalEval)

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

For example

See also:
[SDPDualEval](#SDPDualEval),
[SDPSolve](#SDPSolve),
[SDPMatrices](#SDPMatrices).

### SDPDualEval {#SDPDualEval}

`SDPDualEval[A, X]` evaluates the linear function $A^* X$ in an `SDP`.

For example

See also:
[SDPEval](#SDPEval),
[SDPSolve](#SDPSolve),
[SDPMatrices](#SDPMatrices).

### SDPInner {#SDPInner}


### SDPCheckDimensions {#SDPCheckDimensions}

### SDPFunctions {#SDPFunctions}

### SDPPrimalEval {#SDPPrimalEval}


### SDPScale {#SDPScale}




### SDPSylvesterDiagonalEval {#SDPSylvesterDiagonalEval}


### SDPSylvesterEval {#SDPSylvesterEval}

