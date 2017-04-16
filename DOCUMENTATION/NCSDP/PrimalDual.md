## PrimalDual {#PackagePrimalDual}

`PrimalDual` provides an algorithm for solving semidefinite
programs. The algorithm is parametrized and users should provide their
own means of evaluating the required functions. This allows for the
development of custom algorithms that can take advantage of special
structure, as done for instance in [NCSDP](#PackageNCSDP).

Members are:

* [PrimalDual](#PrimalDual)

### PrimalDual {#PrimalDual}

`PrimalDual[PrimalEval,DualEval,SylvesterEval,SylvesterDiagEval,b,c]`
solves the semidefinite program using a primal dual method.

`PrimalDual[PrimalEval,DualEval,SylvesterEval,SylvesterDiagEval,b,c,options]` uses `options`.

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
- `SymmetricVariables` (`{}`): list of index of variables to be
  considered symmetric.

- `ScaleHessian` (`True`): whether to scale the least-squares subproblem
  coefficient;
- `LeastSquares` (`Direct`): how to solve the least-squares
  subproblem; only `Direct` is reliable at this point;
- `LeastSquaresSolver` (`Null`): user-provided least-squares solver;
- `LeastSquaresSolverFactored` (`Null`): user-provided least-squares
  solver;
 
- `PrintSummary` (`True`): whether to print summary information;
- `PrintIterations` (`True`): whether to print progrees at each iteration;
- `DebugLevel` (0): whether to print debug information;

- `Profiling` (`False`): prints messages with timing of steps.
