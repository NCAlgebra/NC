# Semidefinite Programming {#SemidefiniteProgramming}

If you want a living version of this chapter just run the notebook
`NC/DEMOS/4_SemidefiniteProgramming.nb`.

There are two different packages for solving semidefinite programs:

* [`SDP`](#PackageSDP) provides a template algorithm that can be
  customized to solve semidefinite programs with special
  structure. Users can provide their own functions to evaluate the
  primal and dual constraints and the associated Newton system. A
  built in solver along conventional lines, working on vector
  variables, is provided by default. It does not require NCAlgebra to
  run.

* [`NCSDP`](#PackageNCSDP) coordinates with NCAlgebra to handle matrix
  variables, allowing constraints, etc, to be entered directly as
  noncommutative expressions.


## Semidefinite Programs in Matrix Variables

The package [NCSDP](#PackageNCSDP) allows the symbolic manipulation
and numeric solution of semidefinite programs.

After loading NCAlgebra, the package NCSDP must be loaded using:

    << NCSDP`

Semidefinite programs consist of symbolic noncommutative expressions
representing inequalities and a list of rules for data
replacement. For example the semidefinite program:
$$
\begin{aligned}
\min_Y \quad & <I,Y> \\
\text{s.t.} \quad & A Y + Y A^T + I \preceq 0 \\
            & Y \succeq 0
\end{aligned}
$$
can be solved by defining the noncommutative expressions

    SNC[a, y];
    obj = {-1};
    ineqs = {a ** y + y ** tp[a] + 1, -y};

The inequalities are stored in the list `ineqs` in the form of
noncommutative linear polyonomials in the variable `y` and the
objective function constains the symbolic coefficients of the inner
product, in this case `-1`. The reason for the negative signs in the
objective as well as in the second inequality is that semidefinite
programs are expected to be cast in the following *canonical form*: 
$$
\begin{aligned} 
  \max_y \quad & <b,y> \\ 
  \text{s.t.} \quad & f(y) \preceq 0 
\end{aligned}
$$
or, equivalently:
$$
\begin{aligned} 
  \max_y \quad & <b,y> \\ 
  \text{s.t.} \quad & f(y) + s = 0, \quad s \succeq 0
\end{aligned}
$$

Semidefinite programs can be visualized using
[`NCSDPForm`](#NCSDPForm) as in:

    vars = {y};
    NCSDPForm[ineqs, vars, obj]

The above commands produce a formatted output similar to the ones
shown above.

In order to obtaining a numerical solution for an instance of the
above semidefinite program one must provide a list of rules for data
substitution. For example:

    A = {{0, 1}, {-1, -2}};
    data = {a -> A};

Equipped with the above list of rules representing a problem instance
one can load [`SDPSylvester`](#PackageSDPSylvester) and use `NCSDP` to create
a problem instance as follows:

    {abc, rules} = NCSDP[ineqs, vars, obj, data];

The resulting `abc` and `rules` objects are used for calculating the
numerical solution using [`SDPSolve`](#SDPSolve). The command:

    << SDPSylvester`
    {Y, X, S, flags} = SDPSolve[abc, rules];
	
produces an output like the folowing:

	Problem data:
	* Dimensions (total):
      - Variables             = 4
	  - Inequalities          = 2
	* Dimensions (detail):
	  - Variables             = {{2,2}}
	  - Inequalities          = {2,2}
	Method:
	* Method                  = PredictorCorrector
	* Search direction        = NT
	Precision:
	* Gap tolerance           = 1.*10^(-9)
	* Feasibility tolerance   = 1.*10^(-6)
	* Rationalize iterates    = False
	Other options:
	* Debug level             = 0
	
	 K     <B, Y>         mu  theta/tau      alpha     |X S|2    |X S|oo  |A* X-B|   |A Y+S-C|
	-------------------------------------------------------------------------------------------
	 1  1.638e+00  1.846e-01  2.371e-01  8.299e-01  1.135e+00  9.968e-01  9.868e-16  2.662e-16
	 2  1.950e+00  1.971e-02  2.014e-02  8.990e-01  1.512e+00  9.138e-01  2.218e-15  2.937e-16
	 3  1.995e+00  1.976e-03  1.980e-03  8.998e-01  1.487e+00  9.091e-01  1.926e-15  3.119e-16
	 4  2.000e+00  9.826e-07  9.826e-07  9.995e-01  1.485e+00  9.047e-01  8.581e-15  2.312e-16
	 5  2.000e+00  4.913e-10  4.913e-10  9.995e-01  1.485e+00  9.047e-01  1.174e-14  4.786e-16
	-------------------------------------------------------------------------------------------
	* Primal solution is not strictly feasible but is within tolerance
	(0 <= max eig(A* Y - C) = 8.06666*10^-10 < 1.*10^-6 )
	* Dual solution is within tolerance
	(|| A X - B || = 1.96528*10^-9 < 1.*10^-6)
	* Feasibility radius = 0.999998
	(should be less than 1 when feasible)
  
The output variables `Y` and `S` are the *primal* solutions and `X` is
the *dual* solution.

A symbolic dual problem can be calculated easily using
[`NCSDPDual`](#NCSDPDual):
	
    {dIneqs, dVars, dObj} = NCSDPDual[ineqs, vars, obj];

The dual program for the example problem above is:
$$
\begin{aligned} 
  \max_x \quad & <c,x> \\ 
  \text{s.t.} \quad & f^*(x) + b = 0, \quad x \succeq 0
\end{aligned}
$$
In the case of the above problem the dual program is
$$
\begin{aligned}
\max_{X_1, X_2} \quad & <I,X_1> \\
\text{s.t.} \quad & A^T X_1 + X_1 A -X_2 - I = 0 \\
            & X_1 \succeq 0, \\
	    & X_2 \succeq 0
\end{aligned}
$$
which can be visualized using [`NCSDPDualForm`](#NCSDPDualForm) using:

    NCSDPDualForm[dIneqs, dVars, dObj]

## Semidefinite Programs in Vector Variables

The package [SDP](#PackageSDP) provides a crude and not very efficient
way to define and solve semidefinite programs in standard form, that
is vectorized. You do not need to load `NCAlgebra` if you just want to
use the semidefinite program solver. But you still need to load `NC`
as in:

    << NC`
    << SDP`

Semidefinite programs are optimization problems of the form:
$$
\begin{aligned}
  \max_{y, S} \quad & b^T y \\
  \text{s.t.} \quad & A y + S = c \\
                    & S \succeq 0
\end{aligned}
$$
where $S$ is a symmetric positive semidefinite matrix and $y$ is a
vector of decision variables.

A user can input the problem data, the triplet $(A, b, c)$, or use the
following convenient methods for producing data in the proper format. 

For example, problems can be stated as:
$$
\begin{aligned} 
  \min_y \quad & f(y), \\
  \text{s.t.} \quad & G(y) \succeq 0
\end{aligned}
$$
where $f(y)$ and $G(y)$ are affine functions of the vector
of variables $y$.

Here is a simple example:

    y = {y0, y1, y2};
    f = y2;
    G = {y0 - 2, {{y1, y0}, {y0, 1}}, {{y2, y1}, {y1, 1}}};

The list of constraints in `G` is to be interpreted as:
$$
\begin{aligned} 
  y_0 - 2 \geq 0, \\
  \begin{bmatrix} y_1 & y_0 \\ y_0 & 1 \end{bmatrix} \succeq 0, \\
  \begin{bmatrix} y_2 & y_1 \\ y_1 & 1 \end{bmatrix} \succeq 0.
\end{aligned}
$$
The function [`SDPMatrices`](#SDPMatrices) convert the above symbolic
problem into numerical data that can be used to solve an SDP.

    abc = SDPMatrices[f, G, y]

All required data, that is $A$, $b$, and $c$, is stored in the
variable `abc` as Mathematica's sparse matrices. Their contents can be
revealed using the Mathematica command `Normal`.

    Normal[abc]

The resulting SDP is solved using [`SDPSolve`](#SDPSolve):

    {Y, X, S, flags} = SDPSolve[abc];

The variables `Y` and `S` are the *primal* solutions and `X` is the
*dual* solution. Detailed information on the computed solution is
found in the variable `flags`.

The package `SDP` is built so as to be easily overloaded with more
efficient or more structure functions. See for example
[SDPFlat](#PackageSDPFlat) and [SDPSylvester](#PackageSDPSylvester).
