## PrimalDual {#PackagePrimalDual}

`PrimalDual` provides an algorithm for solving a pair of primal-dual
semidefinite programs in the form 
$$
\tag{Primal}
\begin{aligned}
  \min_{X} \quad & \operatorname{trace}(c X) \\
  \text{s.t.} \quad & A^*(X) = b \\
                    & X \succeq 0
\end{aligned}
$$
$$
\tag{Dual}
\begin{aligned}
  \max_{y, S} \quad & b^T y \\
  \text{s.t.} \quad & A(y) + S = c \\
                    & S \succeq 0
\end{aligned}
$$
where $X$ is the primal variable and $(y,S)$ are the dual variables.

The algorithm is parametrized and users should provide their own means
of evaluating the mappings $A$, $A^*$ and also the Sylvester mapping
$$
	A^*(W_l A(\Delta_y) W_r)
$$
used to solve the least-square subproblem. 

Users can develop custom algorithms that can take advantage of special
structure, as done for instance in [NCSDP](#PackageNCSDP).

The algorithm constructs a feasible solution using the Self-Dual
Embedding of [].

Members are:

* [PrimalDual](#PrimalDual)

### PrimalDual {#PrimalDual}

`PrimalDual[PrimalEval,DualEval,SylvesterEval,b,c]`
solves the semidefinite program using a primal dual method.

`PrimalEval` should return the primal mapping $A^*(X)$ when applied to
the current primal variable `X` as in `PrimalEval @@ X`.

`DualEval` should return the dual mapping $A(y)$ when applied to the
current dual variable `y` as in `DualEval @@ y`.

`SylvesterVecEval` should return a matrix representation of the
Sylvester mapping $A^* (W_l A (\Delta_y) W_r)$ when applied to the left- and
right-scalings `Wl` and `Wr` as in `SylvesterVecEval @@ {Wl, Wr}`.

`PrimalDual[PrimalEval,DualEval,SylvesterEval,b,c,options]` uses `options`.

The following `options` can be given:

- `Method` (`PredictorCorrector`): choice of method for updating
  duality gap; possible options are `ShortStep`, `LongStep` and
  `PredictorCorrector`;
- `SearchDirection` (`NT`): choice of search direction to use;
  possible options are `NT` for Nesterov-Todd, `KSH` for HRVM/KSH/M,
  `KSHDual` for dual HRVM/KSH/M;

- `FeasibilityTol` (10^-3): tolerance used to assess feasibility;
- `GapTol` (10^-9): tolerance used to assess optimality;
- `MaxIter` (250): maximum number of iterations allowed;

- `SparseWeights` (`True`): whether weights should be converted to a
  `SparseArray`;
- `RationalizeIterates` (`False`): whether to rationalize iterates in an attempt to construct a rational solution;
- `SymmetricVariables` (`{}`): list of index of dual variables to be
  considered symmetric.

- `ScaleHessian` (`True`): whether to scale the least-squares subproblem
  coefficient matrix;
 
- `PrintSummary` (`True`): whether to print summary information;
- `PrintIterations` (`True`): whether to print progrees at each iteration;
- `DebugLevel` (0): whether to print debug information;

- `Profiling` (`False`): whether to print messages with detailed timing of steps.
