# NCSDP {#PackageNCSDP}

`NCSDP` is a package that allows the symbolic manipulation and numeric
solution of semidefinite programs.

Members are:

* [NCSDP](#NCSDP)
* [NCSDPDual](#NCSDPDual)
* [NCSDPDualForm](#NCSDPDualForm)
* [NCSDPForm](#NCSDPForm)

## NCSDP {#NCSDP} 

`NCSDP[constraints,vars,obj,data]` converts the list of NC polynomials and
NC matrices of polynomials `constraints` that are linear in the
unknowns listed in `vars` into the semidefinite program with linear
objective `obj`. An equivalent semidefinite program (SDP) is
constructed as follows:

    max  <obj, vars>  s.t.  constraints <= 0.

`NCSDP` uses the user supplied rules in `data` to set up the problem
data.

`NCSDP[constraints,vars,data]` converts problem into a feasibility
semidefinite program.  

## NCSDPDual {#NCSDPDual}

## NCSDPDualForm {#NCSDPDualForm}

## NCSDPForm {#NCSDPForm}

