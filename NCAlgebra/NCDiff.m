(* :Title: 	NCDiff *)

(* :Author: 	mauricio *)

(* :Context: 	NCDiff` *)

(* :Summary:    NCDiff is a package containing several functions that 
		are used in noncommutative differention of functions,
		and polynomials.
*)

(*
*)

(* :Warnings:
*)

(* :History: *)

BeginPackage[ "NCDiff`", 
              "NonCommutativeMultiply`"];

Clear[DirectionalD];
DirectionalD::usage = "\
DirectionalD[expr, var, h] takes the directional derivative of \n
expression expr w.r.t. variable var in direction h.

See NCDirectionalD.";

Clear[NCDirectionalD];
NCDirectionalD::usage = "\
NCDirectionalD[expr, {var1, h1}, ...] takes the directional \
derivative of expression expr w.r.t. variables var1, var2, ... \
successively in the directions h1, h2, ....

See DirectionalD.";

Begin["`Private`"];

  (* DirectionalD *)
               
  (* Rules for inv *)
  Unprotect[D];
  inv /: D[inv[f_], x_] := -inv[f] ** D[f, x] ** inv[f];
  D[g_ inv[f_], x_] := D[g, x] inv[f] - g inv[f] ** D[f, x] ** inv[f];
  D[g_ + inv[f_], x_] := D[g, x] - inv[f] ** D[f, x] ** inv[f];
  Protect[D];
  
  DirectionalD[f_, x_, h_] := Module[
     {t},
     SetCommutative[t];
     D[f /. x -> x + t h /. Conjugate[t] -> t, t] /. t -> 0
  ];

  (* NCDirectionalD *)
               
  NCDirectionalD[f_, xhs__] := 
    Plus @@ Map[(DirectionalD @@ Prepend[##, f])&, {xhs}];

  (* NCHessian *)
               
  NCHessian[f_, xhs__] := 
    NCDirectionalD[NCDirectionalD[f, xhs], xhs];
               
End[ ]

EndPackage[ ]
