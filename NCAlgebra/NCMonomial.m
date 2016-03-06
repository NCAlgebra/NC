(* :Title: 	NCMonomial // Mathematica 1.2 and 2.0 *)

(* :Author: 	Mark Stankus (mstankus)
                STRONGLY Based on the work of David Hurst (dhurst). *)

(* :Context: 	NCMonomial` *)

(* :Summary:	NCMonomial[expression] converts expressions or parts
		of expressions that are powers into linear factors.
		For example, NCMono[ x^3 ] --gives-- x ** x ** x.
*)

(* :Alias:	None. *)

(* :Warnings: 	NCMonomial[] expands only integer exponents.  *)

(* :History: 
   :8/8/93:  Made this new package to decouple it from NCTools.
             Also added NCUnMonomial. This should replace
             NCMono.m eventually. (mstankus)
   :3/3/16:  Remove module
   :3/3/16:  Fixed rule to leave noncommutative powers intact
*)

(*
BeginPackage["NCMonomial`", "NonCommutativeMultiply`"];
*)

BeginPackage["NonCommutativeMultiply`"];

(*

Clear[NCMonomial];

NCMonomial::usage =
     "NCMonomial[expression] replaces nth integer powers of the \
      NonCommutative variable x, with the product of n copies of x
      or inv[x] (if n is negative).";

Clear[NCUnMonomial];

NCUnMonomial::usage =
     "NCMonomial[expression] replaces a product of n copies of x \
      or inv[x] with integer powers of the \
      NonCommutative variable x.";

*)

Begin[ "`Private`" ];

  (* Expand monomial rules *)
  Unprotect[Power];
  Power[b_, c_Integer?Positive] := 
    Apply[NonCommutativeMultiply, Table[b, {c}]] /; !CommutativeQ[b];
  Power[b_, c_Integer?Negative] := 
    inv[Apply[NonCommutativeMultiply, Table[b, {-c}]]] /; !CommutativeQ[b];
  Protect[Power];

(*
  NCMonomial[expr_] := (
    expr //. { (Power[b_, a_Integer?Negative] /; !CommutativeQ[b]) :>
                      Apply[NonCommutativeMultiply, 
                             Table[NonCommutativeMultiply`inv[b], {-a}]],
               (Power[b_, a_Integer?Positive] /; !CommutativeQ[b]) :>
                      Apply[NonCommutativeMultiply, Table[ b, {a}]] } )

  NCUnMonomial[expr_] := (
    expr//.{
            Literal[NonCommutativeMultiply[front___,x_,x_,back___]] :>
                     front**(x^2)**back,
            Literal[NonCommutativeMultiply[front___,x_^j_,x_,back___]] :>
                     front**(x^(j+1))**back,
            Literal[NonCommutativeMultiply[front___,x_,x_^k_,back___]] :>
                     front**(x^(k+1))**back,
            Literal[NonCommutativeMultiply[front___,x_^m_,x_^n_,back___]] :>
                     front**(x^(m+n))**back
                      } )
*)

End[];
EndPackage[]
