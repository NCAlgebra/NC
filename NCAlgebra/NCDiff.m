(* :Title: 	NCDiff // Mathematica 1.2 and 2.0 *)

(* :Author: 	Unknown. Revised by Mark Stankus (mstankus). *)

(* :Context: 	NCDiff` *)

(* :Summary:    NCDiff is a package containing several functions that 
		are used in noncommutative differention of functions,
		and polynomials.
*)

(* :Alias's:    DirD ::= DirectionalD,
		DirDP ::= DirectionalDPolynomial,
		Cri ::= CriticalPoint,
		Crit ::= CriticalPoint,
		NCGradPoly ::= NCGrad,
*)

(* :Warnings:   DirectionalD[ function[x], x, h] works only for a
		limited set of functions.

               	NCGrad gives correct answers only for a limited class
		of polynomials"
*)

(* :History: 
   :3/13/31	Changed Grad to NCGrad to avoid conflict with MMAV9. (mauricio)
   :9/91	Packaged. (dhurst)
   :6/25        Rewrote DirectionalD and DirectionalDPolynomial. (mstankus) 
   :7/01        Added a transpose to Grad and removed it from CriticalPoints.
		(mstankus)
   :9/26	Corrected typos, indenting. (dhurst) 
   :7/2/92	Debugging and Packaging. (dhurst)
*)

BeginPackage[ "NCDiff`", 
     "NonCommutativeMultiply`", "NCSolveLinear1`"];

DirectionalD::usage =
     "DirectionalD[expr, var, h] takes the Directional Derivative of \n
     expression expr w.r.t. variable var in direction h.  Alias: DirD.";

DirectionalDPolynomial::usage =
     "Replaced by DirectionalD. DirectionalDPolynomial now just \
     invokes DirectionalD.  Alias: DirDP."

NCGrad::usage = "...  Alias: NCGradPoly.";
NCGrad::limited = "NCGrad gives correct answers only for a limited class of functions!";

CriticalPoint::usage = "...  Alias: Cri, Crit.";

Begin["`Private`"];
SetNonCommutative[var, h, a, b];
Clear[DirectionalD];

(* :The familiar sum and product rules for derivatives.
*) 

DirectionalD[a_ + b_, var_, h_] := 
     DirectionalD[a, var, h] + DirectionalD[b, var, h];
DirectionalD[a___**b_, var_, h_] := 
     DirectionalD[ NonCommutativeMultiply[a], var, h] **
     NonCommutativeMultiply[b] + 
     NonCommutativeMultiply[a] **
     DirectionalD[ NonCommutativeMultiply[b], var, h];
DirectionalD[a_ b_, var_, h_] := 
     DirectionalD[a, var, h]*b + a*DirectionalD[b, var, h];

(* :If the variable does not occur, in the expression, then the derivative 
   :is zero. 
*) 

DirectionalD[x_, var_, h_] := 0 /; FreeQ[x, var];

(* :We know how to differentiate a few special functions.
*) 

DirectionalD[var_, var_, h_] := h; 
DirectionalD[var_^n_, var_, h_] := n h var^(n-1);
DirectionalD[tp[a_], var_, h_] := tp[DirectionalD[a, var, h]]; 
DirectionalD[inv[a_], var_, h_] := -inv[a]**DirectionalD[a, var, h]**inv[a];

(* This works- even for any bilinear function 

DirectionalD[Schur[f_, b_], x_, h_] := 
     Schur[DirectionalD[f, x, h], b]+ Schur[f, DirectionalD[b, x, h]];
*)

DirectionalD[func_[f_, b_], x_, h_] := 
     func[DirectionalD[f, x, h], b] + func[f, DirectionalD[b, x, h]] /;
          BilinearQ[func];
DirectionalD[func_[f_, b_], x_, h_] := 
     func[DirectionalD[f, x, h], b] + func[f, DirectionalD[b, x, h]] /;
          SesquilinearQ[func];
DirectionalD[func_[f_], x_, h_] := 
     func[DirectionalD[f, x, h]] /;
          LinearQ[func];
DirectionalD[func_[f_], x_, h_] := 
     func[DirectionalD[f, x, h]] /;
          ConjugateLinearQ[func];

(* :If we are differentiating a commutative expression, use the built-in 
   :Mathematica function.  
*)

DirectionalD[a_, var_, h_] := 
     Block[{temp},  
          SetCommutative[T];
          temp = a/.var-> var + T h;
          temp = D[temp, T];
          temp = temp//.T->0;
          Return[temp]
     ] /; TrueQ[CommutativeQ[a]];

DirectionaD[var_, var_, h_] := h; 

DirectionalDPolynomial[x___] := DirectionalD[x];

(* :Now we compute a gradient. 
   :THIS GIVES RIGHT ANSWERS ONLY IN SPECIAL CASES.
*)

SetNonCommutative[func, DV, V]
PreGrad[func_, V_, DV_] := DirectionalD[func, V, DV]/.tp[DV]->0;
                  
(* : Now we compute gradients when the variable commutes or is invertible 
   :this may well be easy. The Gradient NCGradPoly only works for variables 
   :VV which occur only on the "ends" of products within an expression.  
   :Right now NCGradPoly always produces a "row vector" for the Gradient.  
   :This is easy to change once we decide what convention we want to 
   :follow regarding results of a Gradient operation.      
*)

SetNonCommutative[p, q, func, hhhh, VV];

(*
SetNonCommutative[p, q, func, hhhh, VV];
AuxGradient[p_ + q_ ] := AuxGradient[p] + AuxGradient[q];
*)
SetNonCommutative[hhhh,b,x];
SetLinear[AuxGradient];
AuxGradient[tp[hhhh]**b___] := 
     tp[NonCommutativeMultiply[b]]**hhhh;
AuxGradient[hhhh**b___] := 
     tp[NonCommutativeMultiply[b]]**tp[hhhh];
AuxGradient[x_**b___] := 
     NonCommutativeMultiply[x, NonCommutativeMultiply[b]] /; FreeQ[x, hhhh];
AuxGradient[x___] := 
     NonCommutativeMultiply[x] /; FreeQ[x, hhhh];
AuxGradient[x_ y_] := x AuxGradient[y] /; FreeQ[x, hhhh];

NCGrad[func_, VV_] := Block[
  {temp},  

   Message[NCGrad::limited];
   temp = AuxGradient[
     ExpandNonCommutativeMultiply[
       DirectionalD[func, VV, hhhh]
     ]
   ];
   temp = temp//.hhhh->Id;
   Return[tp[temp]];
];

(* : The GradQuadratic function is a Kluge which works only for polys up 
   :to 2nd(?) order which are symmetric in the variable of differentiation.  
   :Use GradPoly for more general polys. 
*)

SetNonCommutative[func, VV, hhhh];
NCGradQuadratic[func_, VV_] :=
     Block[{hhhh, tpg1}, 
          SetNonCommutative[hhhh];
          tpg1 = PreGrad[func, VV, hhhh];
          tpg = tpg1/.hhhh->Id;
          Print[
               "GradQuadratic gives correct answers only for up to \
		2nd order polynomials symmetric in variable of \
		differentiation."
          ];
          Return[2*tpg] 
     ];

CriticalPoint[expr_, var_] :=
     Block[{temp1, temp2},
(* was GradPoly *)          temp1 = NCGrad[expr, var];
          temp2 = ExpandNonCommutativeMultiply[temp1];
          temp = NCSolveLinear1[temp2 == 0, var];
          Return[temp]
     ];

End[ ]

EndPackage[ ]
