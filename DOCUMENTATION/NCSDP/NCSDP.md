# NCSDP {#PackageNCSDP}

**NCSDP** is a package that allows the symbolic manipulation and numeric
solution of semidefinite programs.

Problems consist of symbolic noncommutative expressions representing
inequalities and a list of rules for data replacement. For example the
semidefinite program:
$$
\begin{aligned}
\min_Y \quad & <I,Y> \\
\text{s.t.} \quad & A Y + Y A^T + I \preceq 0 \\
            & Y \succeq 0
\end{aligned}
$$
can be solved by defining the noncommutative expressions

    << NCSDP`
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

Semidefinite programs can be visualized using [`NCSDPForm`](#NCSDPForm) as in:

    vars = {y};
    NCSDPForm[ineqs, vars, obj]

In order to obtaining a numerical solution to an instance of the above
semidefinite program one must provide a list of rules for data
substitution. For example:

    A = {{0, 1}, {-1, -2}};
    data = {a -> A};

Equipped with a list of rules one can invoke [`NCSDP`](#NCSDP) to produce an
instance of [`SDPSylvester`](#SDPSylvester):

    << SDPSylvester`
    {abc, rules} = NCSDP[F, vars, obj, data];

It is the resulting `abc` and `rules` objects that are used for
calculating the numerical solution using [`SDPSolve`](#SDPSolve):

    {Y, X, S, flags} = SDPSolve[abc, rules];

The variables `Y` and `S` are the *primal* solutions and `X` is the
*dual* solution.

An explicit symbolic dual problem can be calculated easily using [`NCSDPDual`](#NCSDPDual):

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

Members are:

* [NCSDP](#NCSDP)
* [NCSDPForm](#NCSDPForm)
* [NCSDPDual](#NCSDPDual)
* [NCSDPDualForm](#NCSDPDualForm)

## NCSDP {#NCSDP} 

`NCSDP[inequalities,vars,obj,data]` converts the list of NC polynomials
and NC matrices of polynomials `inequalities` that are linear in the
unknowns listed in `vars` into the semidefinite program with linear
objective `obj`. The semidefinite program (SDP) should be given in the
following canonical form:

    max  <obj, vars>  s.t.  inequalities <= 0.

`NCSDP` uses the user supplied rules in `data` to set up the problem
data.

`NCSDP[constraints,vars,data]` converts problem into a feasibility
semidefinite program. 

See also:
[NCSDPForm](#NCSDPForm), [NCSDPDual](#NCSDPDual).

## NCSDPForm {#NCSDPForm}

`NCSDPForm[[inequalities,vars,obj]` prints out a pretty formatted
version of the SDP expressed by the list of NC
polynomials and NC matrices of polynomials `inequalities` that are
linear in the unknowns listed in `vars`.

See also:
[NCSDP](#NCSDP), [NCSDPDualForm](#NCSDPDualForm).

## NCSDPDual {#NCSDPDual}

`{dInequalities, dVars, dObj} = NCSDPDual[inequalities,vars,obj]`
calculates the symbolic dual of the SDP expressed by the list of NC
polynomials and NC matrices of polynomials `inequalities` that are
linear in the unknowns listed in `vars` with linear objective `obj`
into a dual semidefinite in the following canonical form:

    max <dObj, dVars>  s.t.  dInequalities == 0,   dVars >= 0.

See also:
[NCSDPDualForm](#NCSDPDualForm), [NCSDP](#NCSDP).

## NCSDPDualForm {#NCSDPDualForm}

`NCSDPForm[[dInequalities,dVars,dObj]` prints out a pretty formatted
version of the dual SDP expressed by the list of NC polynomials and NC
matrices of polynomials `dInequalities` that are linear in the
unknowns listed in `dVars` with linear objective `dObj`.

See also:
[NCSDPDual](#NCSDPDual), [NCSDPForm](#NCSDPForm).
