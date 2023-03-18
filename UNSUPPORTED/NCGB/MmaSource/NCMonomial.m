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
*)

BeginPackage[ "NCMonomial`","NonCommutativeMultiply`"];

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


Begin[ "`Private`" ];

NCMonomial[expr_] :=
Module[{a,b,exp1,out},
     exp1 = expr//.{b_^a_Integer?Negative :>
                    Apply[ NonCommutativeMultiply, 
                           Table[ NonCommutativeMultiply`inv[b],{-a} ]]};
     out = exp1//.{b_^a_Integer?Positive :>
                   Apply[ NonCommutativeMultiply, Table[ b, {a} ]]};
     Return[out]; 
];

NCUnMonomial[expr_] :=
Module[{j,k,m,n,x},
     Return[expr//.{
          Literal[NonCommutativeMultiply[front___,x_,x_,back___]] :>
                   front**(x^2)**back,
          Literal[NonCommutativeMultiply[front___,x_^j_,x_,back___]] :>
                   front**(x^(j+1))**back,
          Literal[NonCommutativeMultiply[front___,x_,x_^k_,back___]] :>
                   front**(x^(k+1))**back,
          Literal[NonCommutativeMultiply[front___,x_^m_,x_^n_,back___]] :>
                   front**(x^(m+n))**back
                    }];
];

End[];
EndPackage[]
