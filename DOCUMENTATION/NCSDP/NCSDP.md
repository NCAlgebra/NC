## NCSDP {#PackageNCSDP}

**NCSDP** is a package that allows the symbolic manipulation and numeric
solution of semidefinite programs.

Members are:

* [NCSDP](#NCSDP)
* [NCSDPForm](#NCSDPForm)
* [NCSDPDual](#NCSDPDual)
* [NCSDPDualForm](#NCSDPDualForm)

### NCSDP {#NCSDP} 

`NCSDP[inequalities,vars,obj,data]` converts the list of NC polynomials
and NC matrices of polynomials `inequalities` that are linear in the
unknowns listed in `vars` into the semidefinite program with linear
objective `obj`. The semidefinite program (SDP) should be given in the
following canonical form:

    max  <obj, vars>  s.t.  inequalities <= 0.

It returns a list with two entries:

- The first is a list with the an instance of [SDPSylvester](#PackageSDPSylvester);
- The second is a list of rules with properties of certain variables.

Both entries should be supplied to [SDPSolve](#SDPSolve) in order to
numerically solve the semidefinite program. For example:

    {abc, rules} = NCSDP[inequalities, vars, obj, data];
	
generates an instance of [SDPSylvester](#PackageSDPSylvester) that can be
solved using:

    << SDPSylvester`
    {Y, X, S, flags} = SDPSolve[abc, rules];

`NCSDP` uses the user supplied rules in `data` to set up the problem
data.

`NCSDP[inequalities,vars,data]` converts problem into a feasibility
semidefinite program. 

`NCSDP[inequalities,vars,obj,data,options]` uses `options`.

The following `options` can be given:

- `DebugLevel` (`0`): control printing of debugging information.

See also:
[NCSDPForm](#NCSDPForm), [NCSDPDual](#NCSDPDual), [SDPSolve](#SDPSolve).

### NCSDPForm {#NCSDPForm}

`NCSDPForm[[inequalities,vars,obj]` prints out a pretty formatted
version of the SDP expressed by the list of NC
polynomials and NC matrices of polynomials `inequalities` that are
linear in the unknowns listed in `vars`.

See also:
[NCSDP](#NCSDP), [NCSDPDualForm](#NCSDPDualForm).

### NCSDPDual {#NCSDPDual}

`{dInequalities, dVars, dObj} = NCSDPDual[inequalities,vars,obj]`
calculates the symbolic dual of the SDP expressed by the list of NC
polynomials and NC matrices of polynomials `inequalities` that are
linear in the unknowns listed in `vars` with linear objective `obj`
into a dual semidefinite in the following canonical form:

    max <dObj, dVars>  s.t.  dInequalities == 0,   dVars >= 0.

`{dInequalities, dVars, dObj} = NCSDPDual[inequalities,vars,obj,dualVars]`
uses the symbols in `dualVars` as `dVars`.

`NCSDPDual[inequalities,vars,...,options]` uses `options`.

The following `options` can be given:

- `DualSymbol` (`"w"`): letter to be used as symbol for dual variable;
- `DebugLevel` (`0`): control printing of debugging information.

See also:
[NCSDPDualForm](#NCSDPDualForm), [NCSDP](#NCSDP).

### NCSDPDualForm {#NCSDPDualForm}

`NCSDPForm[[dInequalities,dVars,dObj]` prints out a pretty formatted
version of the dual SDP expressed by the list of NC polynomials and NC
matrices of polynomials `dInequalities` that are linear in the
unknowns listed in `dVars` with linear objective `dObj`.

See also:
[NCSDPDual](#NCSDPDual), [NCSDPForm](#NCSDPForm).
