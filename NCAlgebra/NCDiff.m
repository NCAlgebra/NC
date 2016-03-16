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
              "NCPolynomial`",
              "NonCommutativeMultiply`"];

Clear[DirectionalD];
DirectionalD::usage = "\
DirectionalD[f, var, h] takes the directional derivative of \n
expression f w.r.t. variable var in direction h.

See NCDirectionalD.";

Clear[NCDirectionalD];
NCDirectionalD::usage = "\
NCDirectionalD[f, {var1, h1}, ...] takes the directional \
derivative of expression f w.r.t. variables var1, var2, ... \
successively in the directions h1, h2, ....

See DirectionalD.";

Clear[NCGrad];
NCGrad::usage = "\
NCGrad[f, var1, ...] gives the nc gradient of the expression f w.r.t. \
variables var1, ....

The transpose of the gradient of the nc expression f is the derivative \
w.r.t h of the trace of the directional derivative of f in the direction h.

For example, if
\tf = x**a**x**b + x**c**x**d
then its directional derivative in the direction h is 
\tdf = h**a**x**b + x**a**h**b + h**c**x**d + x**c**h**d
and its nc gradient is
\tgradf = a**x**b + b**x**a + c**x**d + d**x**c

See also NCDirectionalD.";
               
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
               
  (* NCGrad *)
  Clear[NCGradAux];
  NCGradAux[{scalar_, term1_, term2_}] := scalar * term2 ** term1;

  NCGrad[f_, xs__] := Module[
    {n = Length[{xs}], hs, df, grad, tmp},

    (* Create directions *)
    hs = Table[Unique["$h"], n];
    SetNonCommutative[hs];

    (* Print["hs = ", hs]; *)

    (* Calculate directional derivative *)
    df = NCToNCPolynomial[
            NCDirectionalD @@ Prepend[Transpose[{{xs},hs}], f], hs];

    (* Print["df = ", df]; *)

    grad = ConstantArray[0, n];
      
    (* Terms in hs *)
    tmp = Map[NCPTerm[df, #]&, hs];
                            
    (* Print["tmp = ", tmp]; *)

    grad += Apply[Plus, Map[NCGradAux, tmp, {2}], {1}];
      
    (* Print["grad = ", grad]; *)

    (* Terms in tp[hs] *)
    tmp = Map[NCPTerm[df, #]&, Map[tp,hs]];

    (* Print["tmp = ", tmp]; *)
      
    grad += Map[tp, Apply[Plus, Map[NCGradAux, tmp, {2}], {1}]];

    (* Terms in aj[hs] *)
    tmp = Map[NCPTerm[df, #]&, Map[aj,hs]];

    (* Print["tmp = ", tmp]; *)
      
    grad += Map[aj, Apply[Plus, Map[NCGradAux, tmp, {2}], {1}]];
      
    Return[If [n > 1, grad, Part[grad, 1]] ];
      
  ];
      
End[ ]

EndPackage[ ]
