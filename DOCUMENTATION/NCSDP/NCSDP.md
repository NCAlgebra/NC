# NCSDP {#PackageNCSDP}

**NCSDP** is a package that allows the symbolic manipulation and numeric
solution of semidefinite programs.

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
