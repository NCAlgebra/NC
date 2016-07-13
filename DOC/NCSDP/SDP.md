# SDP {#PackageSDP}

The package **SDP** provides a crude and highly inefficient way to
define and solve semidefinite programs in standard form, that is
vectorized. You do not need to load `NCAlgebra` if you just want to use
the semidefinite program solver. But you still need to load `NC` as in:

    << NC`
    << SDP`

Semidefinite programs are optimization problems of the form:
$$
\begin{aligned}
  \min_{y, S} \quad & b^T y \\
  \text{s.t.} \quad & A y + c = S \\
                    & S \succeq 0
\end{aligned}
$$
where $S$ is a symmetric positive semidefinite matrix.

For convenience, problems can be stated as:
$$
\begin{aligned} 
  \min_y \quad & \operatorname{obj}(y), \\
  \text{s.t.} \quad & \operatorname{ineqs}(y) >= 0
\end{aligned}
$$
where $obj(y)$ and $ineqs(y)$ are affine functions of the vector
variable $y$.

Here is a simple example:

    ineqs = {y0 - 2, {{y1, y0}, {y0, 1}}, {{y2, y1}, {y1, 1}}};
    obj = y2;
    y = {y0, y1, y2};

The list of constraints in `ineqs` are to be interpreted as:
$$
\begin{aligned} 
  y_0 - 2 \geq 0, \\
  \begin{bmatrix} y_1 & y_0 \\ y_0 & 1 \end{bmatrix} \succeq 0, \\
  \begin{bmatrix} y_2 & y_1 \\ y_1 & 1 \end{bmatrix} \succeq 0.
\end{aligned}
$$
The function [`SDPMatrices`](#SDPMatrices) convert the above symbolic
problem into numerical data that can be used to solve an SDP.

    abc = SDPMatrices[by, ineqs, y]

All required data, that is $A$, $b$, and $c$, is stored in the
variable `abc` as Mathematica's sparse matrices. Their contents can be
revealed using the Mathematica command `Normal`.

    Normal[abc]

The resulting SDP is solved using [`SDPSolve`](#SDPSolve):

    {Y, X, S, flags} = SDPSolve[abc];


The variables `Y` and `S` are the *primal* solutions and `X` is the
*dual* solution. Detailed information on the computed solution is
found in the variable `flags`.

The package **SDP** is built so as to be easily overloaded with more
efficient or more structure functions. See for example
[SDPFlat](#SDPFlat) and [SDPSylvester](#SDPSylvester).

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

## SDPMatrices {#SDPMatrices}

## SDPSolve {#SDPSolve}

## SDPEval {#SDPEval}

## SDPInner {#SDPInner}


## SDPCheckDimensions {#SDPCheckDimensions}

## SDPDualEval {#SDPDualEval}

## SDPFunctions {#SDPFunctions}

## SDPPrimalEval {#SDPPrimalEval}


## SDPScale {#SDPScale}




## SDPSylvesterDiagonalEval {#SDPSylvesterDiagonalEval}


## SDPSylvesterEval {#SDPSylvesterEval}

