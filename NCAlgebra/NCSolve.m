(* :Title: 	NCSolve // Mathematica 1.2 and 2.0 *)

(* :Author: 	Unknown. 
		Revised by Mark Stankus (mstankus) and 
                David Hurst (dhurst). *)

(* :Context: 	NCSolveLinear1` *)

(* :Summary:    NCSolve is a package containing several functions that 
		are used to solve equations of the type 
                expr1**x + expr2 === expr3.
*)

(* :Alias's:    NCSolve ::= NCSolveLinear1 *)

(* :Warnings:   None.  *)

(* :History: 
   :6/19/91     -  Rewrote NCSolveLinear1. (mstankus) 
   :7/28/91     -  Final revisions on rewrite. (mstankus)
   :9/22/91	-  Corrected typos, indenting. (dhurst) 
   :8/13/92     -  Changed comments and clarified usage statements. 
		-  Changed the Substitute to a Transform. 
		-  Modified so that it would print out a warning only if 
		-  there is a possible error. (mstankus) 
   :8/28/92	-  Replaced Print[]'s with Messages.
		-  Left :inert code: comment where I removed it.
		-  Replaced Literal[ expr ] with expr //Literal for 
		   readibility.  (dhurst)
   :9/6/92    	-  Added NCSolveCheck as Global' variable to check if
		   it isn't zero. (dhurst)
   :9/6/92    	-  Changed implementation of NCSolveCheck. (mstankus)
*)

BeginPackage[ "NCSolveLinear1`",
     "Global`", "NonCommutativeMultiply`", "NCSubstitute`", "NCCollect`"];

NCSolveCheck::usage = 
     "NCSolveCheck[] retrieves that value of the expression being held \
     by the internal diagnostics for NCSolve.";

NCSolveLinear1::usage = 
     "NCSolveLinear1[ equation, var ] solves linear equations of the type
     a**x+b==c and x**a+b==c in noncommutative algebras.  Alias:
     NCSolve.";

NCSolveLinear1Aux::usage = 
     "NCSolveLinear1Aux[ LhsOfEquation, RhsOfEquation, var] is an internal
     function that prepares the rhs of the solution.  Alias: none.";

NCSolveLinear1::multivar =
     "Warning: NCSolve can not solve for multi-variables yet.";

NCSolveLinear1::eqf =
     "`` is not a well-formed equation.";

NCSolveLinear1::nonref =
     "Warning:  equation does not contain the variable.";

NCSolveLinear1::tauto =
     "Warning:  equation evaluates to True.";

NCSolveLinear1::contrad =
     "Warning:  equation evaluates to False.";

NCSolveLinear1::notsolve =
     "Warning:  NCSolve could not solve this equation."

NCSolveLinear1::diagnostics =
     "\n
      Since the following expression is not zero\n
                                                `` \n
      you may want to double check the result. \n
      This expression can be retrieved by the command NCSolveCheck[]. \n";

NCSolveLinear1::ignor =
     "NCCollect is in error! Result from NCCollect disregarded.";

Begin["`Private`"];

NCSolveCheckVariable = 0;

NCSolveCheck[] := NCSolveCheckVariable;

NCSolveLinear1FreeQ[expr_, var_] := 
     TrueQ[expr == Transform[expr,var->0]];
 
NCSolveLinear1[ equation_Equal, {}] :=
     Return[ {{}} ];

NCSolveLinear1[ True, vars_] :=
     Block[{},
          Message[ NCSolveLinear1::tauto ];
          Return[ {{}} ]
     ];

NCSolveLinear1[False, vars_] :=
     Block[{},
          Message[ NCSolveLinear1::contrad ];
          Return[ {{}} ]
     ];

NCSolveLinear1[ equation_, {var_}] :=
     NCSolveLinear1[ equation, var ];

NCSolveLinear1[equation_, vars_] :=
     Block[{},
          Message[ NCSolveLinear1::eqf, equation ];
	  Return[ {{}} ]
     ] /; Head[equation] =!= Equal;

NCSolveLinear1[equation_, vars_] :=
     Block[{},
          Message[ NCSolveLinear1::nonref ];
          Return[ {{}} ]
     ] /; NCSolveLinear1FreeQ[equation, vars];

NCSolveLinear1[ equation_, vars_List ] :=
     Block[ {},
          Message[  NCSolveLinear1::multivar ];
          Return[ {{}} ]
     ];

NCSolveLinear1[left_==right_, vars_] :=
     Block[ {test, zerofun, stuff, Solution, result, temp },
          zerofun = ExpandNonCommutativeMultiply[left-right];

(* :inert code:	There used to be a never-executed "then" block in an
		If[test,then,else].  Removed the "then" block, because
		NCSolveLinear1::nonref takes care of it. 
*)         

          Solution = -zerofun /. vars->0;
          temp = ExpandNonCommutativeMultiply[zerofun+Solution];
          stuff = NCCollect[ExpandNonCommutativeMultiply[temp],vars];
          test = 
               ExpandNonCommutativeMultiply[stuff] - 
               ExpandNonCommutativeMultiply[temp];
          If[ test=!=0,
               stuff=temp;
               Message[ NCSolveLinear1::ignor ];
          ];
          temp = NCSolveLinear1Aux[stuff,Solution,vars];
          If[ Head[temp] === NCSolveLinear1Aux,
               Message[ NCSolveLinear1::notsolve ];
               Return[ {vars -> temp } ]
          ];
          temp = ExpandNonCommutativeMultiply[temp];
          NCSolveCheckVariable = 
               ExpandNonCommutativeMultiply[ Transform[zerofun, vars->temp]];
          If[ NCSolveCheckVariable=!=0, 
               Message[ NCSolveLinear1::diagnostics, NCSolveCheckVariable ];
          ];
          result = {vars->temp};
          Return[result];
     ];
     
SetNonCommutative[vars];

NCSolveLinear1Aux[a_*left_, right_, vars_] :=
     NCSolveLinear1Aux[left, right/a, vars] /; FreeQ[a, vars];

NCSolveLinear1Aux[ NonCommutativeMultiply[a_, left___], right_, vars_]//
Literal :=
     NCSolveLinear1Aux[ NonCommutativeMultiply[left],
     NonCommutativeMultiply[ inv[a], right], vars] /; FreeQ[a, vars];

NCSolveLinear1Aux[ NonCommutativeMultiply[left___, a_], right_, vars_]//
Literal := 
     NCSolveLinear1Aux[NonCommutativeMultiply[left],
     NonCommutativeMultiply[right, inv[a]], vars] /; FreeQ[a, vars];

NCSolveLinear1Aux[vars_, right_, vars_] := right;

NCSolveLinear1Aux[tp[vars_], right_, vars_] := tp[right];

NCSolveLinear1Aux[inv[vars_], right_, vars_] := inv[right];

NCSolveLinear1Aux[rt[vars_], right_, vars_] := right**right;

End[]

EndPackage[]

