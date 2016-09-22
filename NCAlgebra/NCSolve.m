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

BeginPackage[ "NCSolve`",
              "NCReplace`", "NCCollect`",
              "NonCommutativeMultiply`"];

NCSolveAux::usage = 
     "NCSolveAux[ LhsOfEquation, RhsOfEquation, var] is an internal
     function that prepares the rhs of the solution.  Alias: none.";

NCSolve::multivar =
     "Warning: NCSolve can not solve for multi-variables yet.";

NCSolve::eqf =
     "`` is not a well-formed equation.";

NCSolve::nonref =
     "Warning:  equation does not contain the variable.";

NCSolve::tauto =
     "Warning:  equation evaluates to True.";

NCSolve::contrad =
     "Warning:  equation evaluates to False.";

NCSolve::notsolve =
     "Warning:  NCSolve could not solve this equation."

NCSolve::diagnostics =
     "\n
      Since the following expression is not zero\n
                                                `` \n
      you may want to double check the result. \n
      This expression can be retrieved by the command NCSolveCheck[]. \n";

NCSolve::ignor =
     "NCCollect is in error! Result from NCCollect disregarded.";

Begin["`Private`"];

NCSolveCheckVariable = 0;

NCSolveCheck[] := NCSolveCheckVariable;

NCSolveFreeQ[expr_, var_] := 
     TrueQ[expr == Transform[expr,var->0]];
 
NCSolve[ equation_Equal, {}] :=
     Return[ {{}} ];

NCSolve[ True, vars_] :=
     Block[{},
          Message[ NCSolve::tauto ];
          Return[ {{}} ]
     ];

NCSolve[False, vars_] :=
     Block[{},
          Message[ NCSolve::contrad ];
          Return[ {{}} ]
     ];

NCSolve[ equation_, {var_}] :=
     NCSolve[ equation, var ];

NCSolve[equation_, vars_] :=
     Block[{},
          Message[ NCSolve::eqf, equation ];
	  Return[ {{}} ]
     ] /; Head[equation] =!= Equal;

NCSolve[equation_, vars_] :=
     Block[{},
          Message[ NCSolve::nonref ];
          Return[ {{}} ]
     ] /; NCSolveFreeQ[equation, vars];

NCSolve[ equation_, vars_List ] :=
     Block[ {},
          Message[  NCSolve::multivar ];
          Return[ {{}} ]
     ];

NCSolve[left_==right_, vars_] :=
     Block[ {test, zerofun, stuff, Solution, result, temp },
          zerofun = ExpandNonCommutativeMultiply[left-right];

(* :inert code:	There used to be a never-executed "then" block in an
		If[test,then,else].  Removed the "then" block, because
		NCSolve::nonref takes care of it. 
*)         

          Solution = -zerofun /. vars->0;
          temp = ExpandNonCommutativeMultiply[zerofun+Solution];
          stuff = NCCollect[ExpandNonCommutativeMultiply[temp],vars];
          test = 
               ExpandNonCommutativeMultiply[stuff] - 
               ExpandNonCommutativeMultiply[temp];
          If[ test=!=0,
               stuff=temp;
               Message[ NCSolve::ignor ];
          ];
          temp = NCSolveAux[stuff,Solution,vars];
          If[ Head[temp] === NCSolveAux,
               Message[ NCSolve::notsolve ];
               Return[ {vars -> temp } ]
          ];
          temp = ExpandNonCommutativeMultiply[temp];
          NCSolveCheckVariable = 
               ExpandNonCommutativeMultiply[ Transform[zerofun, vars->temp]];
          If[ NCSolveCheckVariable=!=0, 
               Message[ NCSolve::diagnostics, NCSolveCheckVariable ];
          ];
          result = {vars->temp};
          Return[result];
     ];
     
SetNonCommutative[vars];

NCSolveAux[a_*left_, right_, vars_] :=
     NCSolveAux[left, right/a, vars] /; FreeQ[a, vars];

NCSolveAux[ NonCommutativeMultiply[a_, left___], right_, vars_]//
Literal :=
     NCSolveAux[ NonCommutativeMultiply[left],
     NonCommutativeMultiply[ inv[a], right], vars] /; FreeQ[a, vars];

NCSolveAux[ NonCommutativeMultiply[left___, a_], right_, vars_]//
Literal := 
     NCSolveAux[NonCommutativeMultiply[left],
     NonCommutativeMultiply[right, inv[a]], vars] /; FreeQ[a, vars];

NCSolveAux[vars_, right_, vars_] := right;

NCSolveAux[tp[vars_], right_, vars_] := tp[right];

NCSolveAux[inv[vars_], right_, vars_] := inv[right];

NCSolveAux[rt[vars_], right_, vars_] := right**right;

End[]

EndPackage[]

