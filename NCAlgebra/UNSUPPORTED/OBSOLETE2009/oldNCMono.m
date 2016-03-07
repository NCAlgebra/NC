(* :Title: 	NCMono.m // Mathematica 1.2 and 2.0 *)

(* :Author: 	David Hurst (dhurst). *)

(* :Context: 	NCTools` *)

(* :Summary:	NCMono[ expression ] converts expressions or parts
		of expressions that are powers into linear factors.
		For example, NCMono[ x^3 ] --gives-- x ** x ** x.
*)

(* :Alias:	None. *)

(* :Warnings: 	NCMono[] expands only integer exponents.  *)

(* :History: 
   :9/91	Created. (dhurst)
   :8/16/92	Context changed to NCTools`. (dhurst)
*)

BeginPackage[ "NCTools`",
     "NonCommutativeMultiply`" ];

NCMono::usage =
     "NCMono[ expression ] replaces nth integer powers of the \
     NonCommutative variable x, with the product of n copies of x";

Begin[ "`Private`" ];

NCMono[ expr_ ] :=
    Block[ {a, b, ,exp1, out},
	exp1 = expr//.{b_^a_Integer?Negative :>
	       Apply[ NonCommutativeMultiply, Table[ inv[b],{-a} ]]};
        out = exp1//.{b_^a_Integer?Positive :>
              Apply[ NonCommutativeMultiply, Table[ b, {a} ]]};
        Return[ out ]
     ];

End[];

EndPackage[]

(* :Demo:	If commented out, reactivate and
		Type 'ncmonodemo' for demonstration.
ncmonodemo:=(
Print["x = ",NCMono[x]];
Print["x^2 = ",NCMono[x^2]];
Print["x^x = ",NCMono[x^x]];
Print["x^0 = ",NCMono[x^0]];
Print["x^.5 = ",NCMono[x^.5]];
Print["x^1 = ",NCMono[x^1]];
Print["x^-1 = ",NCMono[x^(-1)]];
Print["x^-5 = ",NCMono[x^(-5)]];
Print["(x^3)**(x^-3) = ",NCMono[(x^3)**(x^-3)]];
Print["(x^6)**(y^2) = ",NCMono[(x^6)**(y^2)]];
Print["(x^-6)**(y^2) = ",NCMono[(x^-6)**(y^2)]];
Print["x^2 + y^2 + z^2= ",NCMono[x^2 + y^2 + z^2]];
);
*)

