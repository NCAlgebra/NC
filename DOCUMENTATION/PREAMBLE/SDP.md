# Semidefinite Programming {#SemidefiniteProgramming}

The package [NCSDP](#PackageNCSDP) allows the symbolic manipulation
and numeric solution of semidefinite programs.

The package must be loaded using:

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
one can load [`SDPSylvester`](#SDPSylvester) and use `NCSDP` to create
a problem instance as follows:

    << SDPSylvester`
    {abc, rules} = NCSDP[F, vars, obj, data];

The resulting `abc` and `rules` objects are used for calculating the
numerical solution using [`SDPSolve`](#SDPSolve). The command:

    {Y, X, S, flags} = SDPSolve[abc, rules];
	
produces an output like the folowing:

?? ADD OUTPUT OF SDPSolve ??

The variables `Y` and `S` are the *primal* solutions and `X` is the
*dual* solution.

An explicit symbolic dual problem can be calculated easily using
[`NCSDPDual`](#NCSDPDual):
	
    {dIneqs, dVars, dObj} = NCSDPDual[ineqs, vars, obj];

The corresponding dual program is expressed in the *canonical form*:
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
Dual semidefinite programs can be visualized using [`NCSDPDualForm`](#NCSDPDualForm) as in:

    NCSDPDualForm[dIneqs, dVars, dObj]
