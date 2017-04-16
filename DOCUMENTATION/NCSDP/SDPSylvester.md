## SDPSylvester {#PackageSDPSylvester}

`SDPSylvester` is a package that provides algorithms for the numeric
solution of semidefinite programs. `SDPSylvester` solves semidefinite
programs of the form:
$$
\begin{aligned}
  \max_{y, S} \quad & \sum_i \operatorname{trace}(b_i^T y_i) \\
  \text{s.t.} \quad & A y + S = \frac{1}{2} \sum_i a_i y_i b_i + (a_i y_i b_i)^T + S = C \\
                    & S \succeq 0
\end{aligned}
$$
where $S$ is a symmetric positive semidefinite matrix and $y = \{ y_1, \ldots, y_n \}$ is a list of matrix decision variables.

Members are:

* [SDPSolve](#SDPSylvesterSolve)
* [SDPEval](#SDPSylvesterEval)
* [SDPDualEval](#SDPSylvesterDualEval)


### SDPSolve {#SDPSylvesterSolve}

`SDPSolve[{A,b,c}]` solves an SDP in the form:
$$
\begin{aligned}
  \max_{y, S} \quad & \sum_i \operatorname{trace}(b_i^T y_i) \\
  \text{s.t.} \quad & A y + S = \frac{1}{2} \sum_i a_i y_i b_i + (a_i y_i b_i)^T + S = C \\
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

The easiest way to create parameters `abc` to be solved by `SDPSolve`
is using [NCSDP](#NCSDP).

See also:
[NCSDP](#NCSDP).

### SDPEval {#SDPSylvesterEval}

`SDPEval[A, y]` evaluates the linear function $A y = \frac{1}{2} \sum_i a_i y_i b_i + (a_i y_i b_i)^T$ in an `SDPSylvester`.

For example

See also:
[SDPDualEval](#SDPSylvesterDualEval),
[SDPSolve](#SDPSylvesterSolve),
[SDPMatrices](#SDPSylvesterMatrices).

### SDPDualEval {#SDPSylvesterDualEval}

`SDPDualEval[A, X]` evaluates the linear function $A^* X = \{ b_1 X a_1, \cdots, b_n X a_n \}$ in an `SDPSylvester`.

For example

See also:
[SDPEval](#SDPSylvesterEval),
[SDPSolve](#SDPSylvesterSolve),
[SDPMatrices](#SDPSylvesterMatrices).



